# PayRoute Africa Onboarding and Authentication

## Authentication Model

Authentication is handled through Firebase Authentication.

Supported sign-in methods in code:

- email and password
- Google
- GitHub

Additional auth behavior:

- password reset email support
- remember-me persistence using shared preferences
- auth-state-based routing

## Auth Routing Logic

Public routes:

- `/`
- `/login`
- `/select-account-type`
- `/create-account`
- `/entity-details`
- `/authorized-rep`
- `/ownership`
- `/review`
- `/success`

Protected routes:

- dashboard and application pages such as wallet, activity, exchange, cards, payment links, settings, smart send, saving goals, ROI analytics, and cross-border

Behavior:

- unauthenticated users are redirected away from protected routes
- authenticated users with remember-me enabled are redirected from landing or login to dashboard

## Personal Account Flow

The personal sign-up experience creates a Firebase user and attempts to create a Firestore user document.

Current code behavior:

- sign-up uses email and password
- a default password is used in the create account flow shown in code
- the account type saved for this path is `personal`

Important AI note:

- if discussing production readiness, avoid presenting a hard-coded default password flow as ideal. It is an implementation detail in the current code and should be treated as something to improve for production.

## Organization Onboarding Flow

Organization onboarding is stateful and uses a provider to collect form data across steps.

Stored onboarding fields:

- entity type
- incorporation document URL or reference
- authorized representative name
- authorized representative date of birth
- authorized representative position
- authorized representative ID type
- list of beneficial owners

Submission behavior:

- validates required onboarding fields
- converts draft owner data into an application model
- writes a Firestore application record
- marks the initial status as `pending_review`

## User Data Model

The app stores user records with:

- user ID
- email
- account type
- created timestamp
- updated timestamp

If Firestore lookup fails but Firebase auth succeeds, the app can construct a basic user model in memory from Firebase Auth data.

## Social Sign-In Behavior

On successful Google or GitHub sign-in:

- the app attempts to fetch the existing user from Firestore
- if not found, it creates a new Firestore user document
- the default account type for this path is `personal`

## Password Reset

The login flow supports password reset by email using Firebase Authentication.

