import 'lib/models/user_model.dart';
import 'lib/utils/logger.dart';

void main() {
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

  log('=== Debug UserModel Display Email Issue ===', name: 'DEBUG_EMAIL_TEST');
  log('user.email: ${user.email}', name: 'DEBUG_EMAIL_TEST');
  log('user.professionalEmail: ${user.professionalEmail}', name: 'DEBUG_EMAIL_TEST');
  log('user.displayEmail (default): ${user.displayEmail}', name: 'DEBUG_EMAIL_TEST');
  log('user.getDisplayEmail(\'personal\'): ${user.getDisplayEmail('personal')}', name: 'DEBUG_EMAIL_TEST');
  log('user.getDisplayEmail(\'professional\'): ${user.getDisplayEmail('professional')}', name: 'DEBUG_EMAIL_TEST');
  
  log('\n=== Phone Debug ===', name: 'DEBUG_PHONE_TEST');
  log('user.phoneNumber: ${user.phoneNumber}', name: 'DEBUG_PHONE_TEST');
  log('user.professionalPhoneNumber: ${user.professionalPhoneNumber}', name: 'DEBUG_PHONE_TEST');
  log('user.displayPhone (default): ${user.displayPhone}', name: 'DEBUG_PHONE_TEST');
  log('user.getDisplayPhone(\'personal\'): ${user.getDisplayPhone('personal')}', name: 'DEBUG_PHONE_TEST');
  log('user.getDisplayPhone(\'professional\'): ${user.getDisplayPhone('professional')}', name: 'DEBUG_PHONE_TEST');
}
