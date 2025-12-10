/// Domain entity - Pure business object (no framework dependencies)
class User {
  final String id;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final bool? isVerified;
  final bool? isGuest;
  final String? refreshToken;
  final String? clientToken;

  User({
    required this.id,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.isVerified,
    this.isGuest,
    this.refreshToken,
    this.clientToken,
  });
}

