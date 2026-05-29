# Lead Tracker

A mobile app built for independent used car dealers to manage and follow up on sales leads.

## Overview

Independent car dealers running small operations (10–25 vehicle lots) often manage leads manually — juggling calls, texts, and emails with no central system. Lead Tracker gives solo dealers a simple, mobile-first tool to capture leads, track follow-ups, and never let a potential sale slip through the cracks.

## Features

- **Lead Management** — capture inbound leads from multiple channels (phone, SMS, email, website, social media)
- **Lead Detail** — view full contact info, lead source, status, and original message in one place
- **One-tap Contact** — call, text, or email a lead directly from the app
- **Status Tracking** — update lead status (Fresh, Contacted, Closed, Lost) to prioritize follow-up
- **Follow-up Log** — log every contact attempt with channel, response status, and notes
- **Real-time Updates** — all data syncs instantly across sessions via Firestore streams
- **Secure Authentication** — email/password sign up and sign in via Firebase Auth

## Tech Stack

- **Flutter** — cross-platform mobile framework
- **Dart** — programming language
- **Firebase Auth** — user authentication
- **Cloud Firestore** — real-time NoSQL database
- **get_it** — service locator for dependency injection

## Architecture

Built with MVVM (Model-View-ViewModel) architecture and a repository pattern:
`UI (Screens) → ViewModels → Repositories → Firebase`

- **Models** — immutable data classes with Firestore serialization
- **Repositories** — single source of truth for all Firestore operations
- **ViewModels** — business logic and state management using `ValueNotifier`
- **Screens** — UI layer, no direct data access

## Project Background

This app was built as a portfolio project after conducting market research into the independent used car dealer space, including scraping and analyzing forum data from industry communities to identify underserved workflows. The lead management problem was validated through dealer forum posts and first-hand experience working with independent dealers during a 15-year career in auto retail at CarMax.

## Setup

This project requires a Firebase project with Firestore and Authentication enabled. Add your own `firebase_options.dart` file generated via the FlutterFire CLI:

`flutterfire configure --project=your-project-id`