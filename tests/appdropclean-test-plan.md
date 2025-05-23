# AppDropClean Test Plan

## Manual Test Cases

### 1. Drag-and-Drop
- Drag a valid `.app` bundle into the app window: Should highlight and accept.
- Drag a non-app file: Should reject.

### 2. File Scanning
- After dropping an app, related support files (Preferences, Caches, Application Support, Saved State, Logs, Containers, Group Containers, Recent Documents) should be listed if they exist.
- If no files found, show empty state.

### 3. File Selection
- User can select/deselect files with checkboxes.
- Selected files are tracked correctly.

### 4. Deletion
- Clicking Zap! moves selected files to Trash.
- Cancel does not delete files.
- Errors are logged and shown if deletion fails.

## Automated Tests (suggested)
- Unit test FileScanner for various bundle IDs and fuzzy matching (future)
- Unit test FileDeleter with mock files
- UI test drag-and-drop interaction

## Repository
[github.com/MLabX/AppDropClean](https://github.com/MLabX/AppDropClean) 