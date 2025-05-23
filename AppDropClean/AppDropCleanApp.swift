//
//  AppDropCleanApp.swift
//  AppDropClean
//
//  Created by Michael Young on 21/5/2025.
//

import SwiftUI

struct AppDropCleanRootView: View {
    @State private var appState: AppState = .idle
    @State private var scannedFiles: [ScannedFile] = []
    @State private var selectedFileIDs: Set<UUID> = []
    @State private var dragOver = false
    @State private var appName: String = ""
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        ZStack {
            VisualEffectBackground()
            switch appState {
            case .idle:
                VStack {
                    Spacer()
                    DropZoneView(
                        dragOver: $dragOver,
                        onAppDropped: { url in
                            appName = url.deletingPathExtension().lastPathComponent
                            appState = .scanning(app: url)
                            DispatchQueue.main.asyncAfter(deadline: .now() + UIConstants.scanDelay) {
                                let files = FileScanner.scanSupportFiles(forAppBundle: url)
                                scannedFiles = files
                                selectedFileIDs = Set(files.map { $0.id })
                                appState = .readyToDelete(app: url, files: files)
                            }
                        }
                    )
                    Spacer()
                }
                .transition(.opacity)
            case .scanning:
                VStack {
                    Spacer()
                    ProgressView(LocalizedStrings.scanning)
                        .progressViewStyle(CircularProgressViewStyle(tint: TiffanyTheme.accent))
                        .foregroundColor(TiffanyTheme.accent)
                    Spacer()
                }
                .transition(.opacity)
            case .readyToDelete(let app, let files):
                ResultsView(
                    appName: app.deletingPathExtension().lastPathComponent,
                    files: files,
                    selectedFileIDs: $selectedFileIDs,
                    onCancel: {
                        appState = .idle
                    },
                    onZap: {
                        let toDelete = files.filter { selectedFileIDs.contains($0.id) }
                        FileDeleter.moveFilesToTrash(toDelete)
                        appState = .idle
                    }
                )
                .transition(.opacity)
            }
        }
        .frame(width: UIConstants.windowWidth, height: UIConstants.windowHeight)
        .accentColor(TiffanyTheme.accent)
        .animation(.easeInOut(duration: UIConstants.animationDuration), value: appState)
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text(LocalizedStrings.error), message: Text(errorMessage), dismissButton: .default(Text(LocalizedStrings.ok)))
        }
    }
}

@main
struct AppDropCleanApp: App {
    var body: some Scene {
        WindowGroup {
            AppDropCleanRootView()
        }
    }
}
