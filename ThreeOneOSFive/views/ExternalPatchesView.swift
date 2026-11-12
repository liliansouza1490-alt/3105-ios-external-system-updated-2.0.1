import SwiftUI

struct ExternalPatchesView: View {
    @EnvironmentObject private var patchStore: ExternalPatchStore
    @State private var showSettings = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("VEEX EXTERNAL")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundStyle(.white)

                        HStack(spacing: 5) {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 6, height: 6)
                            Text("soportado")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundStyle(Color.white.opacity(0.55))
                        }
                    }

                    Spacer()

                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(Color.white.opacity(0.7))
                            .frame(width: 36, height: 36)
                            .background(Color.white.opacity(0.08), in: Circle())
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 18)
                .padding(.top, 12)
                .padding(.bottom, 16)

                // Category segmented control
                HStack(spacing: 0) {
                    ForEach(ExternalCategory.allCases) { cat in
                        Button {
                            withAnimation(.easeInOut(duration: 0.18)) {
                                patchStore.selectedCategory = cat
                            }
                        } label: {
                            Text(cat.rawValue)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(
                                    patchStore.selectedCategory == cat
                                    ? .black
                                    : Color.white.opacity(0.55)
                                )
                                .frame(maxWidth: .infinity)
                                .frame(height: 34)
                                .background(
                                    Group {
                                        if patchStore.selectedCategory == cat {
                                            Capsule().fill(Color.white)
                                        } else {
                                            Capsule().fill(Color.clear)
                                        }
                                    }
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(3)
                .background(
                    Capsule().fill(Color(white: 0.14))
                )
                .padding(.horizontal, 18)
                .padding(.bottom, 20)

                // Toggles list — only shows items that exist for the selected category
                ScrollView {
                    LazyVStack(spacing: 10) {
                        if patchStore.visibleItems.isEmpty {
                            VStack(spacing: 10) {
                                Image(systemName: "square.stack.3d.up.slash")
                                    .font(.system(size: 28, weight: .light))
                                    .foregroundStyle(Color.white.opacity(0.25))
                                Text("Nenhum patch nesta categoria")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(Color.white.opacity(0.35))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 60)
                        } else {
                            ForEach(patchStore.visibleItems) { item in
                                toggleRow(item)
                            }
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.bottom, 100)
                }

                Spacer(minLength: 0)
            }

            // Bottom button
            VStack {
                Spacer()
                Button {
                    openFreeFire()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "gamecontroller.fill")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Abrir Free Fire")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color.white)
                            .shadow(color: .white.opacity(0.25), radius: 14, x: 0, y: 0)
                    )
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 20)
                .padding(.bottom, 28)
            }
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showSettings) {
            ExternalSettingsView()
        }
        .onAppear {
            // seedDemoIfEmpty() → keep for visual match. Comment out later if you want empty until real patches.
            patchStore.seedDemoIfEmpty()
        }
    }

    @ViewBuilder
    private func toggleRow(_ item: ExternalToggleItem) -> some View {
        HStack {
            Text(item.title)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.white)
                .lineLimit(1)

            Spacer()

            Toggle("", isOn: Binding(
                get: { item.isOn },
                set: { patchStore.setToggle(id: item.id, isOn: $0) }
            ))
            .labelsHidden()
            .tint(Color.white)
        }
        .padding(.horizontal, 16)
        .frame(height: 52)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(white: 0.11))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(Color.white.opacity(0.06), lineWidth: 1)
        )
    }

    private func openFreeFire() {
        // Try common Free Fire URL schemes / App Store
        let schemes = [
            "freefire://",
            "ff://",
            "https://apps.apple.com/app/id1300146617"
        ]
        for s in schemes {
            if let url = URL(string: s), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                return
            }
        }
    }
}
