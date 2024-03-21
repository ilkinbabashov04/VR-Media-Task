

class AppLocalizationsEn {
  static const Map<String, String> _localizedValues = {
    'profile': 'Profile',
    'username': 'Username',
    'password': 'Password',
    'enter_username': 'Enter Username',
    'enter_password': 'Enter Password',
    'update': 'Update',
    'logout': 'Logout',
    'delete_profile': 'Delete Profile',
    'delete_profile_confirmation': 'Are you sure you want to delete your profile?',
    'cancel': 'Cancel',
    'confirm_delete': 'Delete',
    'deleteProfile': 'Delete Profile',
  };

  static String translate(String key) {
    return _localizedValues[key] ?? key;
  }
}
