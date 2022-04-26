class LocalUser {
  LocalUser({
    this.id,
    this.name,
    this.email,
  });

  factory LocalUser.fromMap(Map<String, dynamic> data) {
    return LocalUser(
        id: data['id'], name: data['name'], email: data['email']);
  }

  final String id;
  final String name;
  final String email;
}