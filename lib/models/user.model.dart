class MUser {
  num id;
  String name;
  String email;
  String createdAt;
  String updatedAt;
  String token;
  MUser(
      {required this.id,
      this.name = '',
      this.email = '',
      this.createdAt = '',
      this.updatedAt = '',
      this.token = ''});

  factory MUser.fromJson(json) {
    return MUser(
      id: json['data']['user']['id'],
      name: json['data']['user']['name'],
      email: json['data']['user']['email'],
      createdAt: json['data']['user']['created_at'],
      updatedAt: json['data']['user']['updated_at'],
      token: json['data']['token'],
    );
  }
}
