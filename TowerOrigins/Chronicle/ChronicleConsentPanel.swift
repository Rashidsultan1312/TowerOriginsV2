import SwiftUI

struct ChronicleConsentPanel: View {
    let leaf: URL
    let onAcknowledge: () -> Void
    @State private var ticked = false

    var body: some View {
        ZStack {
            Pigment.navy.ignoresSafeArea()

            VStack(spacing: 18) {
                VStack(spacing: 6) {
                    Text("gate.welcome.title")
                        .font(.system(size: 32, weight: .heavy, design: .serif))
                        .foregroundStyle(Pigment.textHi)
                    Text("gate.welcome.subtitle")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(Pigment.textHi.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 26)
                }
                .padding(.top, 30)

                ChronicleFrame(leaf: leaf, fresh: true)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(Pigment.gold.opacity(0.35), lineWidth: 1)
                    )
                    .padding(.horizontal, 18)

                Button(action: { ticked.toggle() }) {
                    HStack(spacing: 12) {
                        Image(systemName: ticked ? "checkmark.square.fill" : "square")
                            .font(.system(size: 22))
                            .foregroundStyle(ticked ? Pigment.gold : Pigment.textHi.opacity(0.55))
                        Text("gate.privacy.agree")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(Pigment.textHi)
                        Spacer()
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 14)
                    .background(Pigment.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 18)

                Button(action: onAcknowledge) {
                    Text("gate.privacy.continue")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Pigment.navy)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Pigment.gold)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .buttonStyle(.plain)
                .disabled(!ticked)
                .opacity(ticked ? 1 : 0.45)
                .padding(.horizontal, 18)
                .padding(.bottom, 22)
            }
        }
        .interactiveDismissDisabled(true)
    }
}
