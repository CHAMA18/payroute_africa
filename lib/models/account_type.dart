/// Account type enum used during onboarding
enum AccountType { 
  personal, 
  organization;

  String get displayName {
    switch (this) {
      case AccountType.personal:
        return 'Personal Account';
      case AccountType.organization:
        return 'Organization';
    }
  }
}
