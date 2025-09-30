import 'dart:math';

class OTPGenerator {
  static String generate6Digits() {
    final random = Random.secure();
    return (100000 + random.nextInt(900000)).toString();
  }

  static String generate4Digits() {
    final random = Random.secure();
    return (1000 + random.nextInt(9000)).toString();
  }

  static String generateCustomLength(int length) {
    if (length < 1) return '';
    
    final random = Random.secure();
    String otp = '';
    
    for (int i = 0; i < length; i++) {
      otp += random.nextInt(10).toString();
    }
    
    return otp;
  }

  static String generateAlphaNumeric(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }
}