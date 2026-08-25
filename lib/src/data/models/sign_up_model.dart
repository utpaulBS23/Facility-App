import '../../domain/entities/sign_up_entity.dart';

extension SignUpRequestModel on SignUpRequestEntity {
  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
    };
  }
}

class SignUpResponseModel {
  SignUpResponseModel({required this.accessToken});

  factory SignUpResponseModel.fromJson(Map<String, dynamic> json) {
    return SignUpResponseModel(accessToken: json['access_token']);
  }

  final String accessToken;
}

extension SignUpResponseMapper on SignUpResponseModel {
  SignUpResponseEntity toEntity() {
    return SignUpResponseEntity(accessToken: accessToken);
  }
}
