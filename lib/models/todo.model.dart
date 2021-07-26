class MTodo {
  num id;
  String title;
  String description;
  num status;
  String image;
  String createdAt;
  String updatedAt;

  MTodo(
      {this.id = 1,
      this.title = '',
      this.description = '',
      this.status = 1,
      this.image = '',
      this.createdAt = '',
      this.updatedAt = ''});

  factory MTodo.fromJson(json) {
    return MTodo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      image: json['image'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
