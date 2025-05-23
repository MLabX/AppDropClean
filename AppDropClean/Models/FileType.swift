import Foundation

enum FileType: String, CaseIterable, Codable {
    case application = "Application"
    case preference = "Preference"
    case cache = "Cache"
    case applicationSupport = "Application Support"
    case savedState = "Saved State"
    case logs = "Logs"
    case container = "Container"
    case groupContainer = "Group Container"
    case recentDocument = "Recent Document"

    var symbol: String {
        switch self {
        case .application: return "app.fill"
        case .preference: return "gearshape.fill"
        case .cache: return "internaldrive.fill"
        case .applicationSupport: return "folder.fill"
        case .savedState: return "clock.arrow.circlepath"
        case .logs: return "doc.text.fill"
        case .container: return "cube.box.fill"
        case .groupContainer: return "cube.fill"
        case .recentDocument: return "doc.fill"
        }
    }
} 