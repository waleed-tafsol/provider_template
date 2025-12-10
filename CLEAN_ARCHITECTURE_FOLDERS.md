# 📁 Clean Architecture Folder Structure

## ✅ Final Structure

Your project now follows **Clean Architecture** folder naming conventions:

```
lib/
├── domain/          # Domain Layer (Business Logic)
├── data/            # Data Layer (Implementation)
├── presentation/    # Presentation Layer (UI)
└── core/            # Core/Shared Utilities
```

---

## 📂 Complete Folder Structure

```
lib/
├── domain/                          # 🎯 Domain Layer
│   ├── entities/                   # Pure business objects
│   │   ├── auth_result.dart
│   │   ├── sign_in_params.dart
│   │   └── user.dart
│   ├── repositories/               # Repository interfaces
│   │   └── auth_repository.dart
│   ├── use_cases/                  # Business logic operations
│   │   └── sign_in_use_case.dart
│   ├── errors/                     # Domain errors
│   │   └── failures.dart
│   └── exceptions/                 # Application exceptions
│       └── app_exception.dart
│
├── data/                           # 📦 Data Layer
│   ├── data_sources/              # Remote/Local data sources
│   │   └── auth_remote_data_source.dart
│   ├── models/                    # DTOs (Data Transfer Objects)
│   │   ├── auth_response_dto.dart
│   │   ├── sign_in_request_dto.dart
│   │   └── base_response_dto.dart
│   ├── repositories/              # Repository implementations
│   │   └── auth_repository_impl.dart
│   └── network/                   # Network layer
│       └── api_client.dart
│
├── presentation/                   # 🎨 Presentation Layer
│   ├── screens/                   # UI screens
│   │   ├── login_screen.dart
│   │   ├── splash_screen.dart
│   │   └── home_screen.dart
│   └── view_models/               # State management
│       ├── auth_view_model.dart
│       └── theme_view_model.dart
│
├── core/                           # 🔧 Core/Shared Utilities
│   ├── assets.dart
│   ├── color_constant.dart
│   ├── custom_text_styles.dart
│   ├── enums.dart
│   ├── error_handler.dart
│   ├── logger_service.dart
│   ├── screen_size.dart
│   ├── secure_storage_service.dart
│   ├── shared_pref.dart
│   └── theme.dart
│
├── app_init.dart
├── main.dart
└── route_generator.dart
```

---

## 🎯 Layer Responsibilities

### 1. **Domain Layer** (`domain/`)
- **Purpose**: Pure business logic, independent of frameworks
- **Contains**:
  - Entities (business objects)
  - Use cases (business operations)
  - Repository interfaces (contracts)
  - Exceptions and errors
- **Rules**: No Flutter dependencies, pure Dart code

### 2. **Data Layer** (`data/`)
- **Purpose**: Data access and transformations
- **Contains**:
  - Data sources (remote/local)
  - DTOs (Data Transfer Objects)
  - Repository implementations
  - Network client
- **Rules**: Implements domain interfaces, maps DTOs to entities

### 3. **Presentation Layer** (`presentation/`)
- **Purpose**: UI and state management
- **Contains**:
  - Screens (UI widgets)
  - ViewModels (state management)
- **Rules**: Depends on domain layer, uses use cases

### 4. **Core Layer** (`core/`)
- **Purpose**: Shared utilities and common functionality
- **Contains**:
  - Error handling
  - Logging service
  - Constants and enums
  - Theme and styling
  - Storage services
- **Rules**: Can be used by all layers

---

## ✅ Changes Made

1. ✅ Renamed `core/` → `domain/` (Domain Layer)
2. ✅ Renamed `utils/` → `core/` (Shared Utilities)
3. ✅ Updated all imports (15 files)
4. ✅ Verified structure follows Clean Architecture

---

## 📝 Import Examples

### Domain Layer
```dart
import 'package:provider_sample_app/domain/repositories/auth_repository.dart';
import 'package:provider_sample_app/domain/use_cases/sign_in_use_case.dart';
```

### Data Layer
```dart
import '../../domain/entities/user.dart';
import '../../domain/exceptions/app_exception.dart';
```

### Presentation Layer
```dart
import '../../domain/entities/sign_in_params.dart';
import '../../domain/use_cases/sign_in_use_case.dart';
```

### Core Utilities
```dart
import 'package:provider_sample_app/core/error_handler.dart';
import 'package:provider_sample_app/core/logger_service.dart';
import 'package:provider_sample_app/core/enums.dart';
```

---

## ✅ Verification

- ✅ Folder structure follows Clean Architecture
- ✅ All imports updated
- ✅ No linter errors
- ✅ Flutter analyze passes
- ✅ Standard naming conventions

---

## 📝 Summary

Your project now uses **standard Clean Architecture folder naming**:

- ✅ **`domain/`** - Domain Layer (Business Logic)
- ✅ **`data/`** - Data Layer (Implementation)
- ✅ **`presentation/`** - Presentation Layer (UI)
- ✅ **`core/`** - Core/Shared Utilities

**All folders renamed and imports updated!** 🚀

