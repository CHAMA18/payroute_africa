# PayRoute Africa Features and Pages

## Public Routes

### Landing Page

Route: `/`

Purpose:

- introduces PayRoute Africa
- communicates reliability, speed, routing intelligence, and cost savings
- pushes users toward onboarding

Key messaging:

- multi-rail routing
- borderless payment infrastructure
- reliability through alternative paths
- FX and routing cost savings

### Login Page

Route: `/login`

Purpose:

- email/password sign-in
- password reset
- Google sign-in
- GitHub sign-in

Important notes:

- the UI supports email or phone style input messaging
- password reset is available
- social sign-in is implemented through Firebase providers

### Account Type Selection

Route: `/select-account-type`

Purpose:

- choose between personal and organization account setup

### Personal Account Creation

Route: `/create-account`

Purpose:

- create a personal user account
- collect name, email, phone number, and country data

## Organization Onboarding Flow

This is a four-step onboarding sequence for organizational accounts.

### Step 1: Entity Details

Route: `/entity-details`

Collects:

- entity type
- incorporation document reference

Supported entity categories in UI:

- Fintech
- Neobank
- Remittance
- Enterprise

### Step 2: Authorized Representative

Route: `/authorized-rep`

Collects:

- full legal name
- date of birth
- position or title
- ID document type

Supported ID types:

- National ID Card
- International Passport
- Driver's License

### Step 3: Ownership

Route: `/ownership`

Collects beneficial owner data such as:

- full name
- ownership percentage
- nationality

The UI indicates beneficial owners are people who own or control 25% or more of the company.

### Step 4: Review

Route: `/review`

Purpose:

- review all onboarding information
- confirm declaration
- submit the organization application

### Success

Route: `/success`

Purpose:

- confirms successful account setup
- indicates verified, complete, and bank-grade security messaging in the UI

## Authenticated Application Pages

### Dashboard

Route: `/dashboard`

Focus:

- real-time routing status
- quick actions
- transaction search
- operational overview

### Wallet

Route: `/wallet`

Focus:

- balances across multiple wallets
- treasury-style overview
- analytics and transaction shortcuts

Examples shown in UI:

- ZMW Wallet
- USD Vault
- KES Settlement

### Activity

Route: `/activity`

Focus:

- transaction history
- routing analysis
- search across activity
- KPIs such as volume and successful transfers

### Cross-Border

Route: `/cross-border`

Focus:

- international transfers
- payment actions
- route and regional payment data

Quick actions include:

- Smart Send
- Payment Links
- Scheduled Payments
- Bill and Utilities

### Smart Send

Route: `/smart-send`

Focus:

- route intelligence
- comparison of available transfer paths
- recommended path selection
- estimated time and savings

The UI contrasts higher-friction paths with an optimized smart route.

### Exchange

Route: `/exchange`

Focus:

- smart FX conversion
- best-rate messaging
- send and receive amount calculation

Important note:

- the page includes a review button, but the code states the review flow is not connected yet

### Cards

Route: `/cards`

Focus:

- virtual or physical card management
- quick card actions
- card UI and card controls

Example actions:

- Freeze Card
- Show Details
- Set Limits
- Manage PIN

### Payment Links

Route: `/payment-links`

Focus:

- manage checkout links
- track link revenue
- observe conversion metrics

### ROI Analytics

Route: `/roi-analytics`

Focus:

- savings timeline
- routing optimization impact
- profitability delta versus baseline costs

### Saving Goals

Route: `/saving-goals`

Focus:

- financial milestones
- goal tracking
- monthly progress

### Settings

Route: `/settings`

Focus:

- account profile
- security preferences
- payment preferences
- developer environment wording in the UI

