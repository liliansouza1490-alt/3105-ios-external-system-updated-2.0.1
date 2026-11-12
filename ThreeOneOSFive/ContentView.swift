import SwiftUI
import UIKit

struct ContentView: View {
    @EnvironmentObject private var externalStore: ExternalPatchStore
    @AppStorage("external.licenseKey") private var storedKey = ""
    @State private var isAuthenticated = false

    var body: some View {
        Group {
            if isAuthenticated || !storedKey.isEmpty {
                ExternalPatchesView()
                    .environmentObject(externalStore)
            } else {
                LoginView(isAuthenticated: $isAuthenticated)
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            if !storedKey.isEmpty {
                isAuthenticated = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .externalKeyCleared)) { _ in
            isAuthenticated = false
        }
    }
}
