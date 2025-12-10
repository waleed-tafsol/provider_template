import 'base_response_dto.dart';

/// Data Transfer Object (DTO) - Maps API response to domain entities
class AuthResponseDto extends BaseResponseDto {
  final AuthDataDto? data;

  AuthResponseDto({
    required super.isSuccess,
    super.message,
    this.data,
  });

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) {
    return AuthResponseDto(
      isSuccess: json['isSuccess'] ?? false,
      message: json['message'],
      data: json['data'] != null ? AuthDataDto.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isSuccess': isSuccess,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class AuthDataDto {
  final String? id;
  final int? createdOnDate;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final bool? isVerified;
  final bool? isGuest;
  final String? refreshToken;
  final String? clientToken;

  AuthDataDto({
    this.id,
    this.createdOnDate,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.isVerified,
    this.isGuest,
    this.refreshToken,
    this.clientToken,
  });

  factory AuthDataDto.fromJson(Map<String, dynamic> json) {
    return AuthDataDto(
      id: json['_id'],
      createdOnDate: json['createdOnDate'],
      fullName: json['fullName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      isVerified: json['isVerified'],
      isGuest: json['isGuest'],
      refreshToken: json['refreshToken'],
      clientToken: json['clientToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'createdOnDate': createdOnDate,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'isVerified': isVerified,
      'isGuest': isGuest,
      'refreshToken': refreshToken,
      'clientToken': clientToken,
    };
  }

}

