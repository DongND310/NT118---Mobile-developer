class UserModel {
  String name;
  String id;
  String email;
  String phone;
  String dob;
  String gender;
  String nation;
  // String img;
  String bio;
  List following;
  List followers;

  UserModel(this.id, this.name, this.email, this.phone, this.dob, this.gender,
      this.nation, this.bio, this.followers, this.following);
}
