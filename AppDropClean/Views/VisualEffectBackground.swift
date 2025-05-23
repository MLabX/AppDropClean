//
//  VisualEffectBackground.swift
//  AppDropClean
//
//  Created by Michael Young on 23/5/2025.
//

import SwiftUI

struct VisualEffectBackground: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.blendingMode = .behindWindow
        view.material = .windowBackground
        view.state = .active
        return view
    }
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}
