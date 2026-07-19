import 'package:equatable/equatable.dart';

/// A single onboarding slide. Title/body are localization keys resolved by the
/// presentation layer so copy stays in the ARB files.
class OnboardingPageEntity extends Equatable {
  const OnboardingPageEntity({
    required this.imagePath,
    required this.titleKey,
    required this.bodyKey,
  });

  final String imagePath;
  final String titleKey;
  final String bodyKey;

  @override
  List<Object?> get props => [imagePath, titleKey, bodyKey];
}
