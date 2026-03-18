# PayRoute Africa Technical Architecture

## Frontend Stack

- Flutter
- Dart
- Provider for app state
- GoRouter for navigation
- Google Fonts and custom theming
- fl_chart for data visualizations

## Backend and Data Services

- Firebase Authentication
- Cloud Firestore
- Firebase web configuration via generated `firebase_options.dart`

## Application Initialization

At startup, the app:

1. initializes Flutter bindings
2. initializes Firebase with generated platform options
3. creates the auth provider
4. creates the GoRouter instance
5. mounts the app with light and dark themes

## State Management

Primary providers:

- `AuthProvider`
- `OrganizationApplicationProvider`

### AuthProvider Responsibilities

- initialize auth state
- load remember-me preference
- manage current Firebase user
- fetch and store user profile data
- perform sign-in and sign-up
- handle social auth
- expose loading and error state

### OrganizationApplicationProvider Responsibilities

- persist multi-step organization onboarding form state
- validate required data before submit
- create a Firestore application record
- manage submission state and errors

## Route Map

Defined routes:

- `/`
- `/login`
- `/select-account-type`
- `/create-account`
- `/entity-details`
- `/authorized-rep`
- `/ownership`
- `/review`
- `/success`
- `/dashboard`
- `/wallet`
- `/activity`
- `/exchange`
- `/cards`
- `/payment-links`
- `/settings`
- `/smart-send`
- `/saving-goals`
- `/roi-analytics`
- `/cross-border`

## Data Models

### User Model

Represents an authenticated user profile with:

- `id`
- `email`
- `accountType`
- timestamps

### OrganizationApplicationModel

Represents an organization onboarding submission with:

- `id`
- `userId`
- `entityType`
- `incorporationDocumentUrl`
- `authorizedRepName`
- `authorizedRepDob`
- `authorizedRepPosition`
- `authorizedRepIdType`
- `beneficialOwners`
- `status`
- `createdAt`
- `updatedAt`

### BeneficialOwner

Represents:

- `fullName`
- `ownershipPercent`
- `nationality`

## Firestore Rules and Indexing

Project files indicate:

- users can only read and write their own user data
- organization applications can only be accessed by the creating user
- a Firestore composite index exists for organization applications by `user_id` and `created_at`

## Current Implementation Notes

- this repository mixes production-like app structure with placeholder UI data in several pages
- some pages show rich dashboards without evidence of full backend wiring for every control
- AI responses should separate implemented authentication and Firestore-backed flows from purely presentational UI sections

