import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  const CategoryEntity({
    required this.id,
    required this.name,
    required this.iconPath,
  });

  final String id;
  final String name;
  final String iconPath;

  @override
  List<Object?> get props => [id, name, iconPath];
}
