import SwiftUI

struct ResultsView: View {
    let appName: String
    let files: [ScannedFile]
    @Binding var selectedFileIDs: Set<UUID>
    var onCancel: () -> Void
    var onZap: () -> Void
    
    func formatSize(_ size: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useMB, .useKB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: size)
    }
    
    var totalSize: Int64 {
        files.filter { selectedFileIDs.contains($0.id) }.reduce(0) { $0 + $1.size }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("\(LocalizedStrings.itemsRelatedTo) \"\(appName)\"")
                .font(.title2).bold()
                .padding(.top, 12)
                .padding(.bottom, 2)
                .frame(maxWidth: .infinity, alignment: .center)
            Text(LocalizedStrings.warning)
                .foregroundColor(.red)
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 8)
            Divider()
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(files) { file in
                        HStack(spacing: 8) {
                            Toggle(isOn: Binding(
                                get: { selectedFileIDs.contains(file.id) },
                                set: { checked in
                                    if checked {
                                        selectedFileIDs.insert(file.id)
                                    } else {
                                        selectedFileIDs.remove(file.id)
                                    }
                                }
                            )) {
                                HStack(spacing: 8) {
                                    Image(systemName: file.type.symbol)
                                        .foregroundColor(TiffanyTheme.accent)
                                        .frame(width: 24)
                                    VStack(alignment: .leading) {
                                        Text(file.displayName)
                                            .font(.body)
                                        Text(file.type.rawValue)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            .toggleStyle(.checkbox)
                            .help(file.path)
                            Spacer()
                            Text(formatSize(file.size))
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .frame(width: 70, alignment: .trailing)
                        }
                        .padding(.vertical, 6)
                        Divider()
                    }
                }
                .padding(.horizontal, 8)
            }
            .frame(maxHeight: UIConstants.maxListHeight)
            HStack {
                Text("\(selectedFileIDs.count) items, \(formatSize(totalSize))")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Spacer()
                Button(LocalizedStrings.cancel, action: onCancel)
                    .buttonStyle(.bordered)
                Button(action: onZap) {
                    Label(LocalizedStrings.zap, systemImage: "bolt.fill")
                }
                .buttonStyle(.borderedProminent)
                .tint(TiffanyTheme.accent)
                .disabled(selectedFileIDs.isEmpty)
            }
            .controlSize(.large)
            .padding(.top, 8)
            .padding(.bottom, 12)
            .padding(.horizontal, 8)
        }
        .background(
            RoundedRectangle(cornerRadius: UIConstants.resultsCornerRadius)
                .fill(Color(.windowBackgroundColor).opacity(0.95))
        )
        .padding(UIConstants.resultsPadding)
    }
}

struct ResultsView_Previews: PreviewProvider {
    @State static var selected: Set<UUID> = [UUID()]
    static var previews: some View {
        ResultsView(
            appName: "VLC",
            files: [
                ScannedFile(id: UUID(), displayName: "VLC", path: "/Applications/VLC.app", type: .application, size: 134_000_000),
                ScannedFile(id: UUID(), displayName: "org.videolan.vlc", path: "~/Library/Preferences/org.videolan.vlc.plist", type: .preference, size: 88_000),
                ScannedFile(id: UUID(), displayName: "org.videolan.vlc", path: "~/Library/Caches/org.videolan.vlc", type: .cache, size: 0)
            ],
            selectedFileIDs: $selected,
            onCancel: {},
            onZap: {}
        )
        .frame(width: UIConstants.windowWidth, height: UIConstants.windowHeight)
    }
} 