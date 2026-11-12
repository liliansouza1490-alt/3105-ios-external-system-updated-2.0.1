import SwiftUI

struct ExternalSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("external.licenseKey") private var storedKey = ""
    @State private var showClearConfirm = false

    private var iosVersionText: String {
        let v = UIDevice.current.systemVersion
        // Approximate build style from video
        return "Version \(v) (Build 23G82)"
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // Licencia section
                        VStack(alignment: .leading, spacing: 0) {
                            sectionHeader("Licencia")

                            VStack(spacing: 0) {
                                settingsRow(title: "Estado", value: "Permanente", valueColor: .green)
                                divider
                                settingsRow(title: "Dispositivos", value: "Ilimitados")
                                divider
                                settingsRow(title: "iOS", value: iosVersionText)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(Color(white: 0.12))
                            )
                        }

                        // Borrar key
                        Button {
                            showClearConfirm = true
                        } label: {
                            Text("Borrar key")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundStyle(Color.red.opacity(0.9))
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(Color(white: 0.12))
                                )
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Ajustes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Listo") {
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                }
            }
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .preferredColorScheme(.dark)
        .confirmationDialog("Borrar key?", isPresented: $showClearConfirm, titleVisibility: .visible) {
            Button("Borrar", role: .destructive) {
                storedKey = ""
                // Force re-login on next launch / by parent binding
                dismiss()
                NotificationCenter.default.post(name: .externalKeyCleared, object: nil)
            }
            Button("Cancelar", role: .cancel) {}
        }
    }

    private var divider: some View {
        Rectangle()
            .fill(Color.white.opacity(0.06))
            .frame(height: 0.5)
            .padding(.leading, 16)
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 13, weight: .medium))
            .foregroundStyle(Color.white.opacity(0.45))
            .padding(.bottom, 8)
            .padding(.leading, 4)
    }

    private func settingsRow(title: String, value: String, valueColor: Color = Color.white.opacity(0.7)) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(.white)
            Spacer()
            Text(value)
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(valueColor)
        }
        .padding(.horizontal, 16)
        .frame(height: 46)
    }
}

extension Notification.Name {
    static let externalKeyCleared = Notification.Name("externalKeyCleared")
}
