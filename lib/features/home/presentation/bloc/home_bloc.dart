import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/horoscope.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/get_home_horoscope.dart';
import '../../domain/usecases/get_user.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeStarted extends HomeEvent {
  const HomeStarted();
}

class HomeState extends Equatable {
  const HomeState({required this.user, required this.horoscope});

  final UserProfile user;
  final Horoscope horoscope;

  @override
  List<Object?> get props => [user, horoscope];
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required GetUser getUser,
    required GetHomeHoroscope getHomeHoroscope,
  }) : _getUser = getUser,
       _getHomeHoroscope = getHomeHoroscope,
       super(
         HomeState(user: getUser.call(), horoscope: getHomeHoroscope.call()),
       ) {
    on<HomeStarted>(_onStarted);
  }

  final GetUser _getUser;
  final GetHomeHoroscope _getHomeHoroscope;

  void _onStarted(HomeStarted event, Emitter<HomeState> emit) {
    emit(HomeState(user: _getUser.call(), horoscope: _getHomeHoroscope.call()));
  }
}
