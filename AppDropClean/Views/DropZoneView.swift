import SwiftUI

struct DropZoneView: View {
    @Binding var dragOver: Bool
    var onAppDropped: (URL) -> Void
    
    var body: some View {
        VStack(spacing: UIConstants.dropZoneSpacing) {
            ZStack {
                RoundedRectangle(cornerRadius: UIConstants.dropZoneCornerRadius)
                    .strokeBorder(style: StrokeStyle(lineWidth: 3, dash: UIConstants.dropZoneDash))
                    .foregroundColor(dragOver ? .white : TiffanyTheme.accent)
                    .background(
                        RoundedRectangle(cornerRadius: UIConstants.dropZoneCornerRadius)
                            .fill(dragOver ? TiffanyTheme.accent : Color(NSColor.windowBackgroundColor))
                    )
                    .frame(width: UIConstants.dropZoneSize, height: UIConstants.dropZoneSize)
                Image(systemName: "arrow.down")
                    .font(.system(size: UIConstants.dropZoneIconSize, weight: .bold))
                    .foregroundColor(dragOver ? .white : TiffanyTheme.accent)
            }
            HStack(spacing: 0) {
                Text(LocalizedStrings.drag)
                    .font(.title2)
                    .foregroundColor(dragOver ? .white : .primary)
                Text(LocalizedStrings.apps)
                    .font(.title2).bold()
                    .foregroundColor(dragOver ? .white : TiffanyTheme.accent)
                Text(LocalizedStrings.here)
                    .font(.title2)
                    .foregroundColor(dragOver ? .white : .primary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .onDrop(of: ["public.file-url"], isTargeted: $dragOver) { providers in
            if let provider = providers.first {
                _ = provider.loadObject(ofClass: URL.self) { url, _ in
                    if let url = url, url.pathExtension == "app" {
                        DispatchQueue.main.async {
                            onAppDropped(url)
                        }
                    }
                }
                return true
            }
            return false
        }
        .animation(.easeInOut(duration: UIConstants.animationDuration), value: dragOver)
    }
}

struct DropZoneView_Previews: PreviewProvider {
    @State static var dragOver = false
    static var previews: some View {
        DropZoneView(dragOver: $dragOver, onAppDropped: { _ in })
            .frame(width: UIConstants.windowWidth, height: UIConstants.windowHeight)
            .preferredColorScheme(.light)
        DropZoneView(dragOver: .constant(true), onAppDropped: { _ in })
            .frame(width: UIConstants.windowWidth, height: UIConstants.windowHeight)
            .preferredColorScheme(.dark)
    }
} 