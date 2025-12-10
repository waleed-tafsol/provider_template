import '../models/auth_response_dto.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/auth_result.dart';

/// Mapper for converting DTOs to Domain entities
class AuthMapper {
  /// Maps AuthDataDto to User entity
  static User toUser(AuthDataDto dto) {
    return User(
      id: dto.id ?? '',
      fullName: dto.fullName,
      email: dto.email,
      phoneNumber: dto.phoneNumber,
      isVerified: dto.isVerified,
      isGuest: dto.isGuest,
      refreshToken: dto.refreshToken,
      clientToken: dto.clientToken,
    );
  }

  /// Maps AuthResponseDto to AuthResult entity
  static AuthResult toAuthResult(AuthResponseDto dto) {
    if (dto.isSuccess && dto.data != null) {
      return AuthResult.success(
        user: toUser(dto.data!),
        message: dto.message,
      );
    } else {
      return AuthResult.failure(
        message: dto.message ?? 'Sign in failed',
      );
    }
  }
}

