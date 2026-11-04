import '../../domain/entities/user_profile.dart';

class UserProfileModel {
  const UserProfileModel({
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

  UserProfile toEntity() {
    return UserProfile(
      name: name,
      initials: initials,
      element: element,
      modality: modality,
      rulingPlanet: rulingPlanet,
      sunSign: sunSign,
      moonSign: moonSign,
      birthDateLabel: birthDateLabel,
    );
  }
}
