import Foundation

class FileScanner {
    static func scanSupportFiles(forAppBundle appURL: URL) -> [ScannedFile] {
        guard let bundle = Bundle(url: appURL),
              let bundleID = bundle.bundleIdentifier else {
            return []
        }
        let fileManager = FileManager.default
        let home = fileManager.homeDirectoryForCurrentUser
        var results: [ScannedFile] = []

        let supportPaths: [(String, String, FileType)] = [
            ("Application", appURL.path, .application),
            ("Preferences", home.appendingPathComponent("Library/Preferences/")
                .appendingPathComponent(bundleID + ".plist").path, .preference),
            ("Caches", home.appendingPathComponent("Library/Caches/")
                .appendingPathComponent(bundleID).path, .cache),
            ("Application Support", home.appendingPathComponent("Library/Application Support/")
                .appendingPathComponent(bundleID).path, .applicationSupport),
            ("Saved State", home.appendingPathComponent("Library/Saved Application State/")
                .appendingPathComponent(bundleID + ".savedState").path, .savedState),
            ("Logs", home.appendingPathComponent("Library/Logs/")
                .appendingPathComponent(bundleID).path, .logs),
            ("Containers", home.appendingPathComponent("Library/Containers/")
                .appendingPathComponent(bundleID).path, .container),
            ("Group Containers", home.appendingPathComponent("Library/Group Containers/")
                .appendingPathComponent(bundleID).path, .groupContainer)
        ]

        // Recent Documents (NSRecentDocuments)
        let recentDocsGlob = home.appendingPathComponent("Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.RecentDocuments/").path
        if let recentDocs = try? fileManager.contentsOfDirectory(atPath: recentDocsGlob) {
            for file in recentDocs where file.lowercased().contains(bundleID) {
                let path = (recentDocsGlob as NSString).appendingPathComponent(file)
                if fileManager.fileExists(atPath: path) {
                    let size = fileSize(atPath: path, fileManager: fileManager)
                    results.append(ScannedFile(id: UUID(), displayName: "Recent Document", path: path, type: .recentDocument, size: size))
                }
            }
        }

        for (name, path, type) in supportPaths {
            if fileManager.fileExists(atPath: path) {
                let size = fileSize(atPath: path, fileManager: fileManager)
                results.append(ScannedFile(id: UUID(), displayName: name, path: path, type: type, size: size))
            }
        }
        return results
    }
    
    private static func fileSize(atPath path: String, fileManager: FileManager) -> Int64 {
        var isDir: ObjCBool = false
        if fileManager.fileExists(atPath: path, isDirectory: &isDir) {
            if isDir.boolValue {
                // Directory: sum all contents
                let url = URL(fileURLWithPath: path)
                let enumerator = fileManager.enumerator(at: url, includingPropertiesForKeys: [.fileSizeKey], options: [], errorHandler: nil)
                var total: Int64 = 0
                while let file = enumerator?.nextObject() as? URL {
                    if let size = (try? file.resourceValues(forKeys: [.fileSizeKey]).fileSize) {
                        total += Int64(size)
                    }
                }
                return total
            } else {
                // File
                if let attr = try? fileManager.attributesOfItem(atPath: path), let size = attr[.size] as? NSNumber {
                    return size.int64Value
                }
            }
        }
        return 0
    }
} 