class RegisterRequest {
  String? email;
  String? password;
  String? confirmPassword;

  RegisterRequest({this.email, this.password, this.confirmPassword});

  RegisterRequest.fromJson(Map<String, dynamic> json) {
    email = json['Email'];
    password = json['Password'];
    confirmPassword = json['ConfirmPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Email'] = email;
    data['Password'] = password;
    data['ConfirmPassword'] = confirmPassword;
    return data;
  }
}