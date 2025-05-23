import Foundation

class FileDeleter {
    static func moveFilesToTrash(_ files: [ScannedFile]) -> [(ScannedFile, String)] {
        let fileManager = FileManager.default
        var failed: [(ScannedFile, String)] = []
        for file in files {
            let url = URL(fileURLWithPath: file.path)
            do {
                try fileManager.trashItem(at: url, resultingItemURL: nil)
                Logger.log("Moved to Trash: \(file.path)")
            } catch {
                Logger.log("Failed to move to Trash: \(file.path) - \(error.localizedDescription)")
                failed.append((file, error.localizedDescription))
            }
        }
        return failed
    }
} 