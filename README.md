# Qatar Teachers

A Flutter mobile app that connects students in Qatar with private teachers. Students browse courses, view teacher profiles and book sessions. Teachers manage their courses, availability and incoming bookings.

The app has two sides, **Student** and **Teacher**, each with its own 4-tab bottom navigation and its own set of API endpoints.

---

## Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Navigation](#navigation)
- [API Overview](#api-overview)
- [Getting Started](#getting-started)
- [Project Status](#project-status)
- [Roadmap](#roadmap)

---

## Features

### Student side

- **Home:** greeting, subject chips, upcoming sessions preview, recommended courses, quick search shortcut
- **Explore:** browse active courses with pagination, keyword search, filter by subject or teacher, course details, public teacher profile, Book Now
- **Bookings:** book a session, view bookings by status (All, Pending, Confirmed, Completed, Cancelled), cancel pending or confirmed bookings
- **Profile:** personal information, edit profile, settings (language, notifications), logout

Guest browsing is supported: Explore uses public endpoints, so a login is only required when the student taps **Book Now**.

### Teacher side

- **Home:** dashboard statistics, booking counts, upcoming sessions preview, course management (create, view, update, delete)
- **Bookings:** all bookings by status, booking details, accept or reject a booking, mark a session as completed
- **Schedule:** weekly calendar, view, add and remove availability slots
- **Profile:** personal information, qualifications, subjects, languages, hourly rate, years of experience, edit profile, settings, logout

---

## Tech Stack

| Area | Choice |
| --- | --- |
| Framework | Flutter (Dart) |
| State management | Riverpod |
| Architecture | Clean Architecture (data / domain / presentation) |
| Backend | REST API (`/api/Student/*`, `/api/Teacher/*`), JWT authentication |

---

## Architecture

The app follows **Clean Architecture**. Every bottom-navigation tab maps to one feature folder, and each feature has three layers:

```
presentation  ->  domain  <-  data
(screens,         (entities,    (models, data sources,
 widgets,          repository    repository
 providers)        contracts,    implementations)
                   use cases)
```

- **Presentation:** screens, widgets and Riverpod providers. Widgets receive domain entities and only handle display.
- **Domain:** pure Dart entities and repository contracts. It has no Flutter or network dependencies.
- **Data:** API calls, DTO models and repository implementations. Errors are mapped to `Failure` objects so the UI can show friendly messages.

Design rules used across the app:

- Each section of a screen watches only its own provider, so a change in one section does not rebuild the others.
- Long lists use slivers so items are built lazily.
- Loading, error (with retry) and empty states are handled for every remote section.
- Display formatting (dates, prices) lives in small shared formatters, not in per-screen UI models.

---

## Project Structure

```
android/              # Android platform project
ios/                  # iOS platform project
assets/               # Images and other static assets
test/                 # Tests
lib/
  core/
    error/            # Failure types
    utils/            # Colors, formatters, shared helpers
  features/
    student side/
      home/
        data/
        domain/
        presentation/
          providers/
          screens/
          widgets/
      explore/
      booking/
      profile/
    teacher side/
      home/
      bookings/
      schedule/
      profile/
```

---

## Navigation

Both sides use a floating bottom navigation bar with four tabs. Tabs are kept alive with an `IndexedStack`, so each tab keeps its scroll position and state when you switch.

| Student | Responsibility |
| --- | --- |
| Home | Discovery and upcoming sessions |
| Explore | Find and view courses and teachers |
| Bookings | Create, list and cancel session bookings |
| Profile | Account information and settings |

| Teacher | Responsibility |
| --- | --- |
| Home | Dashboard and course management |
| Bookings | Sessions and booking requests |
| Schedule | Availability management |
| Profile | Account and professional details |

---

## API Overview

All endpoints are served under `/api/Student` or `/api/Teacher`. Browsing endpoints are public. Booking, profile and all teacher endpoints require a JWT with the matching role.

### Student

| Method | Endpoint | Auth | Purpose |
| --- | --- | --- | --- |
| GET | `/api/Student/subjects` | Public | Subjects that have active courses |
| GET | `/api/Student/courses` | Public | Browse courses (`subject`, `teacherId`, `search`, `page`, `pageSize`) |
| GET | `/api/Student/courses/{id}` | Public | Course details |
| GET | `/api/Student/teachers/{id}` | Public | Public teacher profile |
| POST | `/api/Student/bookings` | Student | Book a session (starts as Pending) |
| GET | `/api/Student/bookings` | Student | My bookings (`status`, `page`, `pageSize`) |
| PUT | `/api/Student/bookings/{id}/cancel` | Student | Cancel a pending or confirmed booking |
| GET | `/api/Student/profile` | Student | Get profile (proposed) |
| PUT | `/api/Student/profile` | Student | Update profile (proposed) |

The Home tab has no endpoints of its own. It reuses the subjects, courses and bookings endpoints with small page sizes (for example `status=Confirmed&pageSize=3` for upcoming sessions).

### Teacher

| Method | Endpoint | Purpose |
| --- | --- | --- |
| GET | `/api/Teacher/dashboard` | Dashboard statistics |
| GET | `/api/Teacher/bookings/counts` | Booking statistics |
| GET | `/api/Teacher/bookings/upcoming` | Upcoming sessions preview |
| GET / POST | `/api/Teacher/courses` | List / create courses |
| GET / PUT / DELETE | `/api/Teacher/courses/{id}` | Course details / update / delete |
| GET | `/api/Teacher/bookings` | All bookings |
| GET | `/api/Teacher/bookings/{id}` | Booking details |
| PUT | `/api/Teacher/bookings/{id}/status` | Accept, reject or update status |
| PUT | `/api/Teacher/bookings/{id}/complete` | Mark a booking as completed |
| GET / POST | `/api/Teacher/availability` | Get / add availability |
| DELETE | `/api/Teacher/availability/{id}` | Delete an availability slot |
| GET / PUT | `/api/Teacher/profile` | Get / update teacher profile |

---

## Getting Started

### Prerequisites

- Flutter SDK (stable channel, 3.13 or newer)
- Android Studio or VS Code with the Flutter extension
- A running instance of the Qatar Teachers backend API

### Setup

```bash
# Clone the repository
git clone https://github.com/Mahmouuddiab/qatar-teacher-app.git
cd qatar-teacher-app

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Configuration

Set the backend base URL in your API client configuration before running the app against a real server. Replace the placeholder with your own value:

```dart
const baseUrl = 'https://dev-qatar-teachers.runasp.net';
```

### Useful commands

```bash
flutter pub get                 # Install dependencies
flutter pub outdated            # Check for newer package versions
flutter analyze                 # Static analysis
dart format lib test            # Format the code
flutter test                    # Run tests
flutter clean                   # Clear build artifacts (use if the build acts up)

flutter run                     # Run on a connected device or emulator
flutter run --release           # Run in release mode

flutter build apk --release         # Android APK
flutter build appbundle --release   # Android App Bundle (Play Store)
flutter build ipa --release         # iOS archive (macOS only)
```

---

## Project Status

| Area | Status |
| --- | --- |
| Student navigation shell | Done |
| Student Home tab | Done (notifications screen and course details not yet connected) |
| Student Explore, Bookings, Profile | In progress |
| Teacher side | Planned (API plan complete) |

---

## Roadmap

- Student notifications screen (the Home header bell is already in place)
- Course details screen and the Book Now flow
- Booking cancellation with a confirmation dialog
- Arabic localization with right-to-left layout
- Teacher side screens and navigation
- Unread notification badge

---

## Notes

- The API plan lists no `GET /bookings/{id}` for students. Booking details reuse the data from the list item until that endpoint is added.
- The student profile endpoints are proposed and mirror the teacher profile endpoints.