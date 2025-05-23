# AppDropClean

A minimal, elegant macOS SwiftUI app inspired by AppZapper, designed to help you clean up all support files left behind by uninstalled apps. Drag in a `.app` bundle, see all related support files (Preferences, Caches, Application Support, etc.), and delete selected ones safely (move to Trash).

## Features
- Drag-and-drop `.app` bundle
- Auto-detects bundle ID and app name
- Scans for Preferences, Caches, Application Support, Saved State, Logs, Containers, Group Containers, and Recent Documents
- Fuzzy matching for related files (coming soon)
- Displays files in a list with checkboxes, file type icons, tooltips, and sizes
- Delete (move to Trash) selected files
- Minimal, Tiffany Blue-accented UI
- Native macOS look and feel (VisualEffectBackground, system icons, dark mode)
- All UI strings and metrics are centralized for easy localization and customization
- User-friendly error handling: If files cannot be deleted (e.g., due to permissions), a clear alert is shown listing failed files and suggesting manual deletion.

## Folder Structure
```
AppDropClean/
  Views/
  Services/
  Models/
  Resources/
  Assets.xcassets/
```

## Usage
1. Launch AppDropClean.
2. Drag a `.app` bundle into the window.
3. Review the found support files.
4. Select files to delete and confirm.

## Requirements
- macOS 12.0+
- SwiftUI

## Repository
[github.com/MLabX/AppDropClean](https://github.com/MLabX/AppDropClean)

---
MIT License 