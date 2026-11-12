import SwiftUI
import Combine

struct ExternalToggleItem: Identifiable, Equatable {
    let id: String
    var title: String
    var isOn: Bool
    var category: ExternalCategory
}

enum ExternalCategory: String, CaseIterable, Identifiable {
    case aimbot = "Aimbots"
    case hologramas = "Hologramas"
    case borrar = "Borrar Invitado"

    var id: String { rawValue }
}

final class ExternalPatchStore: ObservableObject {
    @Published var items: [ExternalToggleItem] = []
    @Published var selectedCategory: ExternalCategory = .aimbot

    /// Only items that belong to the current category (and only if they exist)
    var visibleItems: [ExternalToggleItem] {
        items.filter { $0.category == selectedCategory }
    }

    /// Call this when a real patch is installed / registered.
    /// Title becomes the toggle label.
    func registerPatch(id: String, title: String, category: ExternalCategory, defaultOn: Bool = false) {
        if let idx = items.firstIndex(where: { $0.id == id }) {
            items[idx].title = title
            items[idx].category = category
        } else {
            items.append(ExternalToggleItem(id: id, title: title, isOn: defaultOn, category: category))
        }
    }

    func removePatch(id: String) {
        items.removeAll { $0.id == id }
    }

    func setToggle(id: String, isOn: Bool) {
        guard let idx = items.firstIndex(where: { $0.id == id }) else { return }
        items[idx].isOn = isOn
        // Later: call real apply / restore original here based on isOn
    }

    func clearAll() {
        items.removeAll()
    }

    // Demo seed so the UI matches the video when you first open.
    // Remove or comment this if you want completely empty until real patches arrive.
    func seedDemoIfEmpty() {
        guard items.isEmpty else { return }
        registerPatch(id: "aim_drag_antena", title: "Aim Drag Antena", category: .aimbot)
        registerPatch(id: "aim_drag", title: "Aim Drag", category: .aimbot)
        registerPatch(id: "aim_pecho", title: "Aim Pecho", category: .aimbot)
        registerPatch(id: "balas_magicas", title: "Balas Mágicas", category: .aimbot)
        registerPatch(id: "holo_armas", title: "Hologramas Armas", category: .hologramas)
        registerPatch(id: "holo_personajes", title: "Hologramas Personajes", category: .hologramas)
        registerPatch(id: "reset_guest", title: "Reset Guest", category: .borrar)
    }
}
