
class UserModel {
  int id;
  String name;
  String email;
  dynamic roles;
  dynamic image;

  UserModel({ required this.id, required this.name, required this.email,required this.roles, required this.image});

  factory UserModel.fromJson(Map json){
    return  UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      roles: json['roles'],
      image: json['image'],

    );
  }

  static List<UserModel?> listFromJson(List jsonData){
    return jsonData.map((obj) => UserModel.fromJson(obj)).toList();
  }

  Map toMap(){
    return {
      "id" : id,
      "name" : name,
      "email" :email,
      'roles':roles,
      'image': image

    };
  }

  @override
  String toString() {
    return '$name , $email ';
  }
}