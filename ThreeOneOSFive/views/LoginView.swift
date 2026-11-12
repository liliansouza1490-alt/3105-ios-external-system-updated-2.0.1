import SwiftUI

struct LoginView: View {
    @Binding var isAuthenticated: Bool
    @AppStorage("external.licenseKey") private var storedKey = ""
    @State private var keyInput = ""
    @State private var isChecking = false
    @State private var statusText = "iOS 26.6.1 soportado"
    @State private var statusOK = true
    @FocusState private var keyFocused: Bool

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer(minLength: 60)

                // Logo
                VStack(spacing: 6) {
                    Text("EXTERNAL")
                        .font(.system(size: 42, weight: .bold, design: .default))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    Color(white: 0.95),
                                    Color(white: 0.75),
                                    Color(white: 0.95)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: .white.opacity(0.25), radius: 12, x: 0, y: 0)

                    Text("SYSTEM")
                        .font(.system(size: 42, weight: .bold, design: .default))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    Color(white: 0.95),
                                    Color(white: 0.75),
                                    Color(white: 0.95)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: .white.opacity(0.25), radius: 12, x: 0, y: 0)

                    Text("BY LEVI")
                        .font(.system(size: 11, weight: .medium))
                        .tracking(4)
                        .foregroundStyle(Color.white.opacity(0.45))
                        .padding(.top, 2)
                }
                .padding(.bottom, 48)

                // Key field
                HStack(spacing: 10) {
                    Image(systemName: "key.fill")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.white.opacity(0.45))

                    TextField("", text: $keyInput, prompt: Text("VEEX–XXXX–XXX").foregroundColor(Color.white.opacity(0.35)))
                        .font(.system(size: 15, weight: .medium, design: .monospaced))
                        .foregroundStyle(.white)
                        .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled()
                        .focused($keyFocused)
                        .submitLabel(.go)
                        .onSubmit { attemptLogin() }
                }
                .padding(.horizontal, 16)
                .frame(height: 48)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color(white: 0.12))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.08), lineWidth: 1)
                )
                .padding(.horizontal, 28)

                // Status
                HStack(spacing: 6) {
                    Circle()
                        .fill(statusOK ? Color.green : Color.red)
                        .frame(width: 7, height: 7)
                    Text(statusText)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color.white.opacity(0.55))
                }
                .padding(.top, 14)

                // Continuar button
                Button {
                    attemptLogin()
                } label: {
                    Text("Continuar")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color.white)
                                .shadow(color: .white.opacity(0.35), radius: 16, x: 0, y: 0)
                        )
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 28)
                .padding(.top, 22)
                .disabled(isChecking)

                Spacer()

                // Footer
                VStack(spacing: 6) {
                    Text("SOPORTADO")
                        .font(.system(size: 10, weight: .semibold))
                        .tracking(2)
                        .foregroundStyle(Color.white.opacity(0.35))

                    Text("iOS 17.0–17.7 · 18.0–18.7.1 · 26.0–26.6.1 · 27 betas 1–4")
                        .font(.system(size: 11, weight: .regular))
                        .foregroundStyle(Color.white.opacity(0.4))
                        .multilineTextAlignment(.center)
                }
                .padding(.bottom, 36)
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            if !storedKey.isEmpty {
                keyInput = storedKey
            }
            updateStatusForCurrentDevice()
        }
    }

    private func updateStatusForCurrentDevice() {
        let v = UIDevice.current.systemVersion
        statusText = "iOS \(v) soportado"
        statusOK = true
    }

    private func attemptLogin() {
        let trimmed = keyInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        isChecking = true
        // Placeholder: accept any non-empty key for now.
        // Later plug real API endpoint + key validation here.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            storedKey = trimmed
            isAuthenticated = true
            isChecking = false
        }
    }
}
