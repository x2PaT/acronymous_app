class MetadataModel {
  MetadataModel({
    required this.id,
    required this.private,
    required this.createdAt,
    required this.name,
  });
  final int id;
  final bool private;
  final String createdAt;
  final String name;

  MetadataModel.fromJson(
    Map<String, dynamic> json,
  )   : id = json['id'],
        private = json['private'] == 1 ? true : false,
        createdAt = json['createdAt'],
        name = json['name'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'private': private ? 1 : 0,
      'createdAt': createdAt,
      'name': name,
    };
  }
}
