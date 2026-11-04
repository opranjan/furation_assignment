import 'package:audioplayers/audioplayers.dart';

import '../../../../../core/constants/app_constants.dart';
import 'package:flutter/services.dart';

/// Dial tick: real click WAV + sharper haptic (SystemSound is silent on many Androids).
class DialTickFeedback {
  DialTickFeedback._();

  static final DialTickFeedback instance = DialTickFeedback._();

  static const _poolSize = 3;
  final List<AudioPlayer> _pool = [];
  int _poolIndex = 0;
  bool _ready = false;
  DateTime _lastAt = DateTime.fromMillisecondsSinceEpoch(0);

  Future<void> warmUp() async {
    if (_ready) return;
    try {
      final ctx = AudioContext(
        android: const AudioContextAndroid(
          isSpeakerphoneOn: false,
          stayAwake: false,
          contentType: AndroidContentType.sonification,
          usageType: AndroidUsageType.assistanceSonification,
          audioFocus: AndroidAudioFocus.none,
        ),
        iOS: AudioContextIOS(
          category: AVAudioSessionCategory.ambient,
          options: const {AVAudioSessionOptions.mixWithOthers},
        ),
      );

      for (var i = 0; i < _poolSize; i++) {
        final p =
            AudioPlayer()
              ..setReleaseMode(ReleaseMode.stop)
              ..setPlayerMode(PlayerMode.lowLatency);
        await p.setAudioContext(ctx);
        await p.setSource(AssetSource(AppConstants.dialTick));
        await p.setVolume(1.0);
        _pool.add(p);
      }
      _ready = true;
    } catch (_) {
      _ready = true;
    }
  }

  Future<void> tick({bool strong = false}) async {
    final now = DateTime.now();
    if (!strong && now.difference(_lastAt).inMilliseconds < 30) return;
    _lastAt = now;

    await warmUp();

    if (_pool.isNotEmpty) {
      final p = _pool[_poolIndex % _pool.length];
      _poolIndex++;
      try {
        await p.seek(Duration.zero);
        await p.resume();
      } catch (_) {
        try {
          await p.play(AssetSource(AppConstants.dialTick), volume: 1.0);
        } catch (_) {}
      }
    }

    if (strong) {
      await HapticFeedback.heavyImpact();
    } else {
      await HapticFeedback.mediumImpact();
    }
  }

  Future<void> dispose() async {
    for (final p in _pool) {
      await p.dispose();
    }
    _pool.clear();
  }
}
