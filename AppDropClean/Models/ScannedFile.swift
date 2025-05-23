import Foundation

struct ScannedFile: Identifiable, Codable, Equatable {
    let id: UUID
    let displayName: String
    let path: String
    let type: FileType
    let size: Int64
} 