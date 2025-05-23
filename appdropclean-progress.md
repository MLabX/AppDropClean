# AppDropClean Progress Log

## 2024-06-10
- Project initialized in Xcode as SwiftUI macOS app
- Folder structure created: Views, Services, Models, Resources, Assets.xcassets
- Initial code files generated for drag-and-drop, file scanning, deletion, and UI
- README and test plan stub created

## 2024-06-11
- Refactored all hardcoded UI strings and metrics into LocalizedStrings and UIConstants
- Introduced FileType enum for file type logic and icons
- FileScanner now scans for all standard support files and is ready for fuzzy matching
- Removed redundant views, unified UI logic
- Ready for first commit to [github.com/MLabX/AppDropClean](https://github.com/MLabX/AppDropClean) 

## 2024-06-12
- Improved error handling: If any files cannot be deleted (e.g., due to permissions), a user-friendly alert is shown listing the failed files and suggesting manual deletion or checking permissions. 