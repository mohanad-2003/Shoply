<div align="center">

# 🛍️ Shoply

**A premium e-commerce mobile app built with Flutter, Clean Architecture & Bloc.**

[![Flutter](https://img.shields.io/badge/Flutter-3.44-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.8-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![State Management](https://img.shields.io/badge/State-Bloc-13B9FD)](https://bloclibrary.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Clean-4CAF50)](#-architecture)
[![License](https://img.shields.io/badge/License-Private-lightgrey)](#-license)

</div>

---

## 📖 Overview

**Shoply** is a modern, production-grade e-commerce application showcasing a scalable
**Clean Architecture** approach with the **Bloc** pattern. It ships with a complete
pre-purchase flow — onboarding, authentication, product browsing, cart and wishlist —
alongside full **RTL / LTR internationalization** (English & Arabic), **light/dark theming**,
and responsive layouts.

> Built as a reference-quality UI kit and app foundation for premium shopping experiences.

---

## 📸 Screenshots

> Drop your captured screens into the [`screenshots/`](screenshots/) folder using the file
> names below and they will render automatically.

| Onboarding | Login | Home |
|:---:|:---:|:---:|
| <img src="screenshots/onboarding.png" width="220"/> | <img src="screenshots/login.png" width="220"/> | <img src="screenshots/home.png" width="220"/> |

| Product Details | Cart | Wishlist |
|:---:|:---:|:---:|
| <img src="screenshots/product.png" width="220"/> | <img src="screenshots/cart.png" width="220"/> | <img src="screenshots/wishlist.png" width="220"/> |

<sub>To capture a screen while the app runs on an emulator:
`flutter screenshot --out=screenshots/home.png`</sub>

---

## ✨ Features

| Area | Highlights |
|------|-----------|
| 🚀 **Onboarding** | Animated multi-page onboarding with skip / next flow |
| 🌐 **Localization** | Full English & Arabic support with RTL layout mirroring |
| 🔐 **Authentication** | Login, Sign Up, Forgot Password, OTP verification, password reset |
| 🏠 **Home & Catalog** | Curated product feed with categories and search-ready routing |
| 📦 **Product Details** | Rich product pages with images, variants and add-to-cart |
| 🛒 **Cart** | Add / remove items, quantity control and live totals |
| ❤️ **Wishlist** | Save favourite products for later |
| 👤 **Profile** | User profile section |
| 🎨 **Theming** | Adaptive light & dark themes with a centralized design system |
| 📱 **Responsive UI** | Pixel-perfect scaling via `flutter_screenutil` & `responsive_framework` |
| ✅ **Tested** | Bloc, flow and widget tests included |

---

## 🏗️ Architecture

Shoply follows **Clean Architecture** with a clear separation into three layers per feature:

```
Presentation  ──▶  Domain  ──▶  Data
   (Bloc/UI)      (Entities,     (Models,
                   UseCases,      DataSources,
                   Repo contracts) Repo impls)
```

- **Presentation** — Widgets, Pages, and `Bloc`/`Cubit` state management.
- **Domain** — Pure business logic: entities, use cases, and repository interfaces (framework-agnostic).
- **Data** — Repository implementations, remote/local data sources, and DTO models.

Cross-cutting concerns (networking, DI, theming, routing, localization, error handling)
live under [`lib/core/`](lib/core/), keeping features self-contained and swappable.

### Project Structure

```
lib/
├── app.dart                  # Root MaterialApp (theme, locale, router)
├── main.dart                 # Bootstrap: Hive, DI, runApp
├── core/
│   ├── constants/            # App-wide constants
│   ├── di/                   # Dependency injection (get_it + injectable)
│   ├── errors/               # Failures & exceptions
│   ├── extensions/           # Dart/Flutter extensions
│   ├── localization/l10n/    # ARB files & generated localizations
│   ├── network/              # Dio client, interceptors, connectivity
│   ├── routing/              # go_router config & route names
│   ├── theme/                # Colors, spacing, radius, text styles, themes
│   ├── usecases/             # Base UseCase contracts
│   ├── utils/                # Helpers
│   └── widgets/              # Shared reusable widgets
└── features/
    ├── splash/  onboarding/  language_select/
    ├── auth/    home/         product/
    ├── cart/    wishlist/      profile/
```

---

## 🧰 Tech Stack

| Category | Packages |
|----------|----------|
| **State Management** | `flutter_bloc`, `equatable` |
| **Routing** | `go_router` |
| **Networking** | `dio`, `retrofit`, `pretty_dio_logger` |
| **Dependency Injection** | `get_it`, `injectable` |
| **Code Generation** | `freezed`, `json_serializable`, `build_runner` |
| **Local Storage** | `hive`, `shared_preferences`, `flutter_secure_storage` |
| **Functional / Errors** | `fpdart` (`Either`-based error handling) |
| **UI & Responsiveness** | `flutter_screenutil`, `responsive_framework`, `cached_network_image`, `flutter_svg`, `lottie`, `shimmer` |
| **Connectivity** | `internet_connection_checker_plus` |
| **Testing** | `bloc_test`, `mocktail`, `flutter_test` |

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) **≥ 3.44** (Dart **≥ 3.8**)
- A configured device / emulator (Android, iOS, Web, or desktop)

### Installation

```bash
# 1. Clone the repository
git clone <your-repo-url>
cd ui_kit

# 2. Install dependencies
flutter pub get

# 3. Generate code (DI, freezed, retrofit, json)
dart run build_runner build --delete-conflicting-outputs

# 4. Run the app
flutter run
```

### Localization

Localized strings are defined in [`lib/core/localization/l10n/`](lib/core/localization/l10n/)
(`app_en.arb`, `app_ar.arb`). Regenerate after editing:

```bash
flutter gen-l10n
```

---

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run a specific test
flutter test test/features/auth/auth_bloc_test.dart
```

Included test suites:

- `test/app_flow_test.dart` — end-to-end navigation flow
- `test/pre_home_flow_test.dart` / `pre_home_overflow_test.dart` — pre-home flow & layout
- `test/features/auth/auth_bloc_test.dart` — auth Bloc logic
- `test/features/cart/cart_bloc_test.dart` — cart Bloc logic
- `test/wishlist_profile_test.dart` — wishlist & profile

---

## 🎨 Design System

A centralized theme keeps the UI consistent and easy to evolve:

- **`app_colors.dart`** — Brand & semantic color palette
- **`app_text_styles.dart`** — Typography scale
- **`app_spacing.dart`** / **`app_radius.dart`** — Spacing & corner-radius tokens
- **`app_theme.dart`** — Light & dark `ThemeData`
- **`theme_cubit.dart`** — Runtime theme switching

---

## 🗺️ Roadmap

- [x] **Phase 1** — Onboarding, auth flow, home, product, cart, wishlist, profile
- [ ] **Phase 2** — Checkout, orders, notifications, settings, search *(routes reserved)*
- [ ] Payment gateway integration
- [ ] Backend API integration (currently mock-driven)

---

## 📄 License

This project is **private** and not published to pub.dev (`publish_to: none`).
All rights reserved © 2026.

---

<div align="center">
Made with ❤️ &nbsp;using Flutter
</div>
