class MetadataModel {
  MetadataModel({
    this.id,
    this.private,
    this.createdAt,
    this.name,
    this.sqlquery,
  });
  final String? id;
  final bool? private;
  final String? createdAt;
  final String? name;
  final String? sqlquery;

  MetadataModel.fromJson(
    Map<String, dynamic> json,
  )   : id = json['id'],
        private = json['private'] == 1 ? true : false,
        createdAt = json['createdAt'],
        name = json['name'],
        sqlquery = json['sqlquery'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'private': private! ? 1 : 0,
      'createdAt': createdAt,
      'name': name,
      'sqlquery': sqlquery,
    };
  }
}
