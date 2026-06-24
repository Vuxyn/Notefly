# Contributing to Notefly

Thank you for your interest in contributing to Notefly. Please follow the guidelines below to maintain high code quality and smooth collaboration.

## Git Branching Strategy

All development work should be done in feature branches branched off `develop`. Do not commit directly to the `main` branch.

- Feature branches: `feature/your-feature-name`
- Integration branch: `develop`
- Production branch: `main`

## Commit Messages

We enforce the Conventional Commits specification. Ensure your commit messages use the following format:

- `feat: add floating bubble drag behavior`
- `fix: resolve note not persisting after app restart`
- `chore: add hive dependency`
- `docs: update README with install steps`
- `test: add note repository unit tests`
- `refactor: extract note item into separate widget`

## Coding Conventions

### Dart & Flutter

- Class Names: PascalCase (e.g., `NoteRepository`, `FloatingBubble`)
- Variable Names: camelCase (e.g., `noteList`, `isDone`)
- Constant Names: camelCase prefixed with const (e.g., `const maxNoteLength = 500`)
- Private Members: _camelCase (e.g., `_notes`, `_loadNotes()`)
- File Names: snake_case (e.g., `note_repository.dart`)
- Folder Names: snake_case (e.g., `data/`, `widgets/`)
- Enums: PascalCase for type, camelCase for values (e.g., `enum NoteFilter { all, active, done }`)
- Hive Box Names: snake_case (e.g., `'note_box'`)
- Providers: Suffix with Provider (e.g., `NoteProvider`)

### Code Style Rules

- Maximum Line Length: 80 characters
- Always use `const` where possible
- Prefer `final` over `var`
- No magic numbers: extract them to named constants
- No commented-out code in commits
- One widget per file
- Prefer `StatelessWidget` unless state is strictly required locally
- Always `await` futures: do not use fire-and-forget unless explicitly intended
- Handle errors with `try/catch` and do not swallow exceptions silently

## Verification and Testing

Before submitting a Pull Request, please run local static analysis and testing:
```bash
flutter analyze
flutter test
```
Ensure all analysis checks pass and all unit tests succeed.
