class UserProfile {
  const UserProfile({
    required this.name,
    required this.initials,
    required this.element,
    required this.modality,
    required this.rulingPlanet,
    required this.sunSign,
    required this.moonSign,
    required this.birthDateLabel,
  });

  final String name;
  final String initials;
  final String element;
  final String modality;
  final String rulingPlanet;
  final String sunSign;
  final String moonSign;
  final String birthDateLabel;

  String get traitsLine => '$element • $modality • $rulingPlanet';
}
