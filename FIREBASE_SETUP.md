# Firebase Setup Documentation

## Overview
This project has been configured with Firebase Authentication and Cloud Firestore for backend services.

## Project Structure

### Models (`lib/models/`)
- **`user_model.dart`**: User data model with email, account type, and timestamps
- **`organization_application_model.dart`**: Organization application data with entity details, authorized representative info, and beneficial owners

### Services (`lib/services/`)
- **`user_service.dart`**: CRUD operations for user data in Firestore
- **`organization_application_service.dart`**: Manages organization applications with queries, updates, and real-time listeners

### Authentication (`lib/auth/`)
- **`auth_manager.dart`**: Abstract authentication interface
- **`firebase_auth_manager.dart`**: Firebase Authentication implementation with email/password sign-in, sign-up, and password reset

### Providers (`lib/providers/`)
- **`auth_provider.dart`**: ChangeNotifier that manages authentication state throughout the app

## Firebase Configuration Files

### `firestore.rules`
Security rules implementing private data access:
- **Users collection**: Users can only read/write their own data
- **Organization applications**: Users can only access applications they created

### `firestore.indexes.json`
Composite index for querying organization applications by user_id and created_at (descending order).

### `firebase.json`
Firebase project configuration file with Firestore rules and indexes deployment settings.

## Usage Examples

### Authentication
```dart
// Access auth provider
final authProvider = Provider.of<AuthProvider>(context, listen: false);

// Sign in
await authProvider.signIn(email, password);

// Sign up
await authProvider.signUp(email, password, accountType);

// Sign out
await authProvider.signOut();
```

### User Service
```dart
final userService = UserService();

// Get user by ID
final user = await userService.getUserById(userId);

// Create user
await userService.createUser(userModel);

// Watch user changes
userService.watchUser(userId).listen((user) {
  // Handle user updates
});
```

### Organization Application Service
```dart
final orgService = OrganizationApplicationService();

// Create application
final applicationId = await orgService.createApplication(application);

// Get user's applications
final applications = await orgService.getApplicationsByUserId(userId);

// Watch applications
orgService.watchUserApplications(userId).listen((applications) {
  // Handle application updates
});
```

## Next Steps

### 1. Enable Authentication in Firebase Console
Visit: https://console.firebase.google.com/u/0/project/rqr88qtom5amftxo8feci8jvycmnx5/authentication/providers

Enable Email/Password authentication provider.

### 2. Deploy Firestore Rules and Indexes
Open the Firebase panel in the left sidebar and deploy:
- Firestore security rules
- Firestore indexes

### 3. Test Authentication Flow
- Test user sign-up on the Create Account page
- Test user sign-in on the Login page
- Verify that user data is properly stored in Firestore

## Security Best Practices
- All user data is private and only accessible by the authenticated user
- Organization applications are only accessible by the user who created them
- All Firebase operations include proper error handling and logging
- Authentication errors are user-friendly and provide clear guidance
