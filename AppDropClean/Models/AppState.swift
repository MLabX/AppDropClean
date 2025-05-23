import Foundation

enum AppState: Equatable {
    case idle
    case scanning(app: URL)
    case readyToDelete(app: URL, files: [ScannedFile])
} 