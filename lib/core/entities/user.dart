// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserEntity {
  final String name;
  final String email;
  final String id;
  final String? img_url;
  final String? about;

  UserEntity({this.img_url, this.about, required this.name, required this.email, required this.id});
  @override
  String toString() {
    // TODO: implement toString
    return "UserEntity(id: ${id}, name: ${name}, email: ${email}, img_url: ${img_url}, about: ${about})";
  }
}
