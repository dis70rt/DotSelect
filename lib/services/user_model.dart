class UserModel {
  final String name;
  final double dx;
  final double dy;

  UserModel({
    required this.name,
    required this.dx,
    required this.dy,
  });
  
  UserModel.empty()
      : name = '',
        dx = 0,
        dy = 0;

  factory UserModel.fromMap(Map<dynamic, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      dx: (map['dx'] as num?)?.toDouble() ?? 0.0,
      dy: (map['dy'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
