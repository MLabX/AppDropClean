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
        var seenPaths = Set<String>()
        let appName = appURL.deletingPathExtension().lastPathComponent
        let appNameLower = appName.lowercased()
        let bundleIDLower = bundleID.lowercased()

        let searchDirs: [(FileType, URL)] = [
            (.preference, home.appendingPathComponent("Library/Preferences")),
            (.cache, home.appendingPathComponent("Library/Caches")),
            (.applicationSupport, home.appendingPathComponent("Library/Application Support")),
            (.logs, home.appendingPathComponent("Library/Logs")),
            (.savedState, home.appendingPathComponent("Library/Saved Application State")),
            (.container, home.appendingPathComponent("Library/Containers")),
            (.groupContainer, home.appendingPathComponent("Library/Group Containers"))
        ]

        for (type, dir) in searchDirs {
            if let files = try? fileManager.contentsOfDirectory(atPath: dir.path) {
                for file in files {
                    let lower = file.lowercased()
                    if lower.contains(bundleIDLower) || lower.contains(appNameLower) {
                        let path = dir.appendingPathComponent(file).path
                        if !seenPaths.contains(path) && fileManager.fileExists(atPath: path) {
                            let size = fileSize(atPath: path, fileManager: fileManager)
                            results.append(ScannedFile(id: UUID(), displayName: file, path: path, type: type, size: size))
                            seenPaths.insert(path)
                        }
                    }
                }
            }
        }

        // Recent Documents (NSRecentDocuments)
        let recentDocsGlob = home.appendingPathComponent("Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.RecentDocuments/").path
        if let recentDocs = try? fileManager.contentsOfDirectory(atPath: recentDocsGlob) {
            for file in recentDocs where file.lowercased().contains(bundleIDLower) || file.lowercased().contains(appNameLower) {
                let path = (recentDocsGlob as NSString).appendingPathComponent(file)
                if !seenPaths.contains(path) && fileManager.fileExists(atPath: path) {
                    let size = fileSize(atPath: path, fileManager: fileManager)
                    results.append(ScannedFile(id: UUID(), displayName: file, path: path, type: .recentDocument, size: size))
                    seenPaths.insert(path)
                }
            }
        }

        // Add the app bundle itself
        let appSize = fileSize(atPath: appURL.path, fileManager: fileManager)
        if !seenPaths.contains(appURL.path) {
            results.append(ScannedFile(id: UUID(), displayName: appName, path: appURL.path, type: .application, size: appSize))
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