# PayRoute Africa Deployment and Operations

## Repository and Deployment Context

The project is stored in GitHub under the repository:

- `CHAMA18/payroute_africa`

The app is prepared for container-based deployment using a Dockerfile at the repository root.

## Docker Deployment Model

The deployment setup is designed for Flutter web hosting:

- build the Flutter web app in a Flutter container
- serve the generated static output through Nginx

Supporting files:

- `Dockerfile`
- `deploy/nginx.conf`
- `.dockerignore`

## Hosting Expectations

For platforms that detect Docker-based services:

- source directory should be the repository root
- the service should detect the root `Dockerfile`
- the container serves traffic on port `80`

## Firebase Setup Notes

The repository includes Firebase configuration and setup notes for:

- authentication providers
- Firestore rules
- Firestore indexes

Operational setup tasks include:

- enable Firebase Authentication providers in the Firebase console
- deploy Firestore security rules
- deploy Firestore indexes

## Known Operational Caveats

- Flutter must be installed locally to run the app outside Docker
- some local environments may not have `flutter` on the PATH
- some deployment platforms may fail auto-detection unless a `Dockerfile` exists at the repo root
- dependency resolution depends on using a Flutter image version new enough to satisfy the Dart SDK requirements

## Suggested AI Support Boundaries

The AI assistant grounded on this knowledge base should help with:

- explaining app features and routes
- guiding users through onboarding
- summarizing auth and deployment behavior
- interpreting build and deployment errors
- clarifying which parts of the app are UI-driven versus Firestore-backed

The AI assistant should avoid claiming:

- live banking connectivity not shown in the repo
- production settlement guarantees
- compliance approvals outside the implemented onboarding and status fields

