import 'package:equatable/equatable.dart';

class BannerEntity extends Equatable {
  const BannerEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });

  final String id;
  final String title;
  final String subtitle;
  final String imagePath;

  @override
  List<Object?> get props => [id, title, subtitle, imagePath];
}
