import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'lib/models/user_model.dart';

void main() {
  test('debug display email issue', () {
    final now = DateTime.now();
    final user = UserModel(
      id: '1',
      email: 'personal@example.com',
      firstName: 'John',
      lastName: 'Doe',
      professionalEmail: 'professional@company.com',
      createdAt: now,
      updatedAt: now,
    );

    if (kDebugMode) {
      debugPrint('Email: ${user.email}');
      debugPrint('Professional Email: ${user.professionalEmail}');
      debugPrint('getDisplayEmail(\'personal\'): ${user.getDisplayEmail('personal')}');
      debugPrint('getDisplayEmail(\'professional\'): ${user.getDisplayEmail('professional')}');
    }
    
    expect(user.getDisplayEmail('personal'), 'personal@example.com');
  });
}
