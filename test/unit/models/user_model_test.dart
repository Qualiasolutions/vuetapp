import 'package:flutter_test/flutter_test.dart';
import 'package:vuet_app/models/user_model.dart';

void main() {
  group('UserModel Tests', () {
    test('should create UserModel with required parameters', () {
      final now = DateTime.now();
      final user = UserModel(
        id: '1',
        email: 'test@example.com',
        firstName: 'John',
        lastName: 'Doe',
        createdAt: now,
        updatedAt: now,
      );

      expect(user.id, '1');
      expect(user.email, 'test@example.com');
      expect(user.firstName, 'John');
      expect(user.lastName, 'Doe');
      expect(user.accountType, 'personal'); // default value
      expect(user.subscriptionStatus, 'free'); // default value
      expect(user.fullName, 'John Doe');
    });

    test('should create UserModel with all parameters', () {
      final now = DateTime.now();
      final dateOfBirth = DateTime(1990, 1, 1);
      
      final user = UserModel(
        id: '1',
        email: 'test@example.com',
        firstName: 'John',
        lastName: 'Doe',
        professionalEmail: 'john.doe@company.com',
        avatarUrl: 'https://example.com/avatar.jpg',
        phone: '+1234567890',
        professionalPhone: '+0987654321',
        dateOfBirth: dateOfBirth,
        memberColor: '#FF5733',
        accountType: 'both',
        subscriptionStatus: 'premium',
        onboardingCompleted: true,
        createdAt: now,
        updatedAt: now,
      );

      expect(user.accountType, 'both');
      expect(user.phone, '+1234567890');
      expect(user.professionalEmail, 'john.doe@company.com');
      expect(user.professionalPhone, '+0987654321');
      expect(user.avatarUrl, 'https://example.com/avatar.jpg');
      expect(user.dateOfBirth, dateOfBirth);
      expect(user.memberColor, '#FF5733');
      expect(user.subscriptionStatus, 'premium');
      expect(user.onboardingCompleted, true);
    });

    test('should copy with new values', () {
      final now = DateTime.now();
      final originalUser = UserModel(
        id: '1',
        email: 'test@example.com',
        firstName: 'John',
        lastName: 'Doe',
        createdAt: now,
        updatedAt: now,
      );

      final copiedUser = originalUser.copyWith(
        firstName: 'Jane',
        accountType: 'professional',
        subscriptionStatus: 'premium',
      );

      expect(copiedUser.id, '1');
      expect(copiedUser.firstName, 'Jane');
      expect(copiedUser.lastName, 'Doe');
      expect(copiedUser.accountType, 'professional');
      expect(copiedUser.subscriptionStatus, 'premium');
    });

    test('should convert to and from JSON', () {
      final now = DateTime.parse('2025-01-01T12:00:00Z');
      final user = UserModel(
        id: '1',
        email: 'test@example.com',
        firstName: 'John',
        lastName: 'Doe',
        phone: '+1234567890',
        memberColor: '#FF5733',
        accountType: 'professional',
        subscriptionStatus: 'premium',
        onboardingCompleted: true,
        createdAt: now,
        updatedAt: now,
      );

      final json = user.toJson();
      final fromJson = UserModel.fromJson(json);

      expect(fromJson.id, user.id);
      expect(fromJson.email, user.email);
      expect(fromJson.firstName, user.firstName);
      expect(fromJson.lastName, user.lastName);
      expect(fromJson.phone, user.phone);
      expect(fromJson.memberColor, user.memberColor);
      expect(fromJson.accountType, user.accountType);
      expect(fromJson.subscriptionStatus, user.subscriptionStatus);
      expect(fromJson.onboardingCompleted, user.onboardingCompleted);
      expect(fromJson.createdAt, user.createdAt);
      expect(fromJson.updatedAt, user.updatedAt);
    });

    test('should handle equality correctly', () {
      final now = DateTime.parse('2025-01-01T12:00:00Z');
      final user1 = UserModel(
        id: '1',
        email: 'test@example.com',
        firstName: 'John',
        lastName: 'Doe',
        createdAt: now,
        updatedAt: now,
      );

      final user2 = UserModel(
        id: '1',
        email: 'test@example.com',
        firstName: 'John',
        lastName: 'Doe',
        createdAt: now,
        updatedAt: now,
      );

      final user3 = user1.copyWith(firstName: 'Jane');

      expect(user1, equals(user2));
      expect(user1, isNot(equals(user3)));
    });

    test('should validate account types', () {
      final now = DateTime.now();
      const validTypes = ['personal', 'professional', 'both'];
      
      for (final type in validTypes) {
        final user = UserModel(
          id: '1',
          email: 'test@example.com',
          firstName: 'John',
          lastName: 'Doe',
          accountType: type,
          createdAt: now,
          updatedAt: now,
        );
        expect(user.accountType, type);
      }
    });

    test('should validate subscription statuses', () {
      final now = DateTime.now();
      const validStatuses = ['free', 'premium'];
      
      for (final status in validStatuses) {
        final user = UserModel(
          id: '1',
          email: 'test@example.com',
          firstName: 'John',
          lastName: 'Doe',
          subscriptionStatus: status,
          createdAt: now,
          updatedAt: now,
        );
        expect(user.subscriptionStatus, status);
      }
    });

    test('should handle full name computation', () {
      final now = DateTime.now();
      final user = UserModel(
        id: '1',
        email: 'test@example.com',
        firstName: 'John',
        lastName: 'Doe',
        createdAt: now,
        updatedAt: now,
      );

      expect(user.fullName, 'John Doe');
    });

    test('should handle empty names gracefully', () {
      final now = DateTime.now();
      final user = UserModel(
        id: '1',
        email: 'test@example.com',
        firstName: '',
        lastName: '',
        createdAt: now,
        updatedAt: now,
      );

      expect(user.fullName.trim(), '');
    });

    test('should handle boolean getters correctly', () {
      final now = DateTime.now();
      
      final personalUser = UserModel(
        id: '1',
        email: 'test@example.com',
        firstName: 'John',
        lastName: 'Doe',
        accountType: 'personal',
        subscriptionStatus: 'free',
        createdAt: now,
        updatedAt: now,
      );

      expect(personalUser.isPersonal, true);
      expect(personalUser.isProfessional, false);
      expect(personalUser.isBothAccounts, false);
      expect(personalUser.isFree, true);
      expect(personalUser.isPremium, false);

      final professionalUser = personalUser.copyWith(
        accountType: 'professional',
        subscriptionStatus: 'premium',
      );

      expect(professionalUser.isPersonal, false);
      expect(professionalUser.isProfessional, true);
      expect(professionalUser.isBothAccounts, false);
      expect(professionalUser.isFree, false);
      expect(professionalUser.isPremium, true);

      final bothUser = personalUser.copyWith(accountType: 'both');
      expect(bothUser.isPersonal, true);
      expect(bothUser.isProfessional, true);
      expect(bothUser.isBothAccounts, true);
    });

    test('should handle display email correctly', () {
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

      // Test default behavior (should return personal email)
      expect(user.displayEmail, 'personal@example.com');
      // Test professional preference
      expect(user.getDisplayEmail('professional'), 'professional@company.com');
      
      // Test fallback when professional email is not available
      final userWithoutProfessional = user.copyWith(professionalEmail: null);
      expect(userWithoutProfessional.getDisplayEmail('professional'), 'personal@example.com');
    });

    test('should handle display phone correctly', () {
      final now = DateTime.now();
      final user = UserModel(
        id: '1',
        email: 'test@example.com',
        firstName: 'John',
        lastName: 'Doe',
        phone: '+1234567890',
        professionalPhone: '+0987654321',
        createdAt: now,
        updatedAt: now,
      );

      // Test default behavior (should return personal phone)
      expect(user.displayPhone, '+1234567890');
      // Test professional preference
      expect(user.getDisplayPhone('professional'), '+0987654321');
      
      // Test fallback when professional phone is not available
      final userWithoutProfessional = user.copyWith(professionalPhone: null);
      expect(userWithoutProfessional.getDisplayPhone('professional'), '+1234567890');
    });
  });
}
