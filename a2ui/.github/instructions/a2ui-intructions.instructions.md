# GitHub Copilot Instructions for a2ui Project

You are an expert Flutter and Dart developer working on the `a2ui` project.

## Tech Stack
- **Framework**: Flutter
- **Language**: Dart (SDK ^3.10.0)
- **Key Dependencies**:
  - `firebase_core`: For Firebase integration.
  - `genui`: For UI generation.
  - `genui_firebase_ai`: For AI-powered UI generation with Firebase.
  - `google_fonts`: For typography.
  - `logging`: For structured logging.
  - `json_schema_builder` : https://pub.dev/documentation/json_schema_builder/latest/
- **AI Agent**:
  - `gemini-2.5-pro`: For AI model

## Coding Guidelines

### General
- Write clean, maintainable, and efficient code.
- Follow the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style).
- Adhere to `flutter_lints` rules enabled in the project.
- Use `const` constructors for widgets and immutable objects whenever possible to optimize performance.
- Prefer named parameters for widget constructors.
- Using command `fvm flutter` instead of `flutter` only

### Project Structure
- **lib/**: Contains the main source code.
  - **blocs/**: Contain bloc/cubit files 
  - **ds/**: Design system contain the UI shared in the app. Each files name start with ds_*. Class name start with Ds. Example ds_button.dart will contain class DsButton 
  - **genui/**: Code related to the GenUI library implementation.
  - **models/**: Data models. Contain all models used in app
  - **routes/**: Navigation and routing logic.
  - **theme/**: App theming and styling.

### Error Handling & Logging
- Use the `logging` package for all log outputs. Avoid `print()`.
- Handle errors gracefully, especially for Firebase and network operations.

### UI Development
- Utilize `genui` components where appropriate for dynamic or AI-generated UIs.
- Use `google_fonts` for text styling to ensure consistency.
- Ensure the UI is responsive and works across supported platforms (Android, iOS, Web, macOS, Windows, Linux).

### State Management
- Bloc/Cubit

## Interaction
- When generating code, provide complete and functional snippets.
- If modifying existing files, ensure context is preserved.
- Explain complex logic or architectural decisions.
