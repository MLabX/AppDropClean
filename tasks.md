# AppDropClean Task Tracker

## AppZapper-like Refactor Plan (SwiftUI Native)

### 1. Model
- [x] Add `type: FileType` and `size: Int64` to `ScannedFile`.
- [x] Add `FileType` enum for all file types and icons.

### 2. FileScanner
- [x] Calculate file size for each found file.
- [x] Assign a FileType for each file.
- [x] Scan for all standard support files (Preferences, Caches, Application Support, etc.)
- [ ] Add fuzzy matching for related files (future improvement)

### 3. UI
- [x] Show file type icon (using SF Symbols).
- [x] Show file name, type/description, and size (formatted).
- [x] Tooltip for file path (using `.help()` modifier).
- [x] Use native-style checkbox.
- [x] All UI strings and metrics centralized in LocalizedStrings and UIConstants.

### 4. App Structure
- [x] Remove redundant views, unify UI logic.
- [x] Add VisualEffectBackground for native look.
- [x] Ready for first commit to [github.com/MLabX/AppDropClean](https://github.com/MLabX/AppDropClean)

### 5. ConfirmDeleteView
- [ ] Show list of files with name, type, and size.
- [ ] Show summary: "X items, Y MB".
- [ ] "Cancel" and "Zap!" buttons (with SF Symbol for zap).
- [ ] Play zap sound on confirm.

### 6. App Structure
- [ ] Add a toolbar with app name and actions.
- [ ] Use `.alert` for error or confirmation.
- [ ] Ensure dark mode adapts all custom colors.

### 7. Sound
- [ ] Integrate AVFoundation to play a zap sound on deletion.
- [x] Show user-friendly alert if files cannot be deleted (e.g., due to permissions), listing failed files and suggesting manual deletion. 