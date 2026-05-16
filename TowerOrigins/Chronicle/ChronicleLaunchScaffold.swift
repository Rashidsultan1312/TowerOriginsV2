import SwiftUI

struct ChronicleLaunchScaffold<Tale: View>: View {
    @AppStorage("to.chronicle.acknowledged") private var acknowledged = false
    @State private var beat: Beat = .resting
    @State private var promptUp = false
    @ViewBuilder var tale: () -> Tale

    var body: some View {
        Group {
            if acknowledged {
                tale()
            } else {
                switch beat {
                case .resting:
                    ZStack {
                        Pigment.navy.ignoresSafeArea()
                        ProgressView()
                            .tint(Pigment.gold)
                            .scaleEffect(1.3)
                    }
                    .task { await unfurl() }
                case .sailoff(let url):
                    ChronicleFrame(leaf: url, fresh: false)
                        .ignoresSafeArea()
                case .scroll:
                    ZStack { Pigment.navy.ignoresSafeArea() }
                        .fullScreenCover(isPresented: $promptUp) {
                            ChronicleConsentPanel(leaf: AppConfig.privacyPolicyURL) {
                                acknowledged = true
                                promptUp = false
                                beat = .awake
                            }
                        }
                case .awake:
                    tale()
                }
            }
        }
    }

    @MainActor
    private func unfurl() async {
        async let pause: Void = { try? await Task.sleep(nanoseconds: 1_200_000_000) }()
        async let reading = CodexLedger.read()
        let outcome = await reading
        _ = await pause
        switch outcome {
        case .unfurled(let url):
            beat = .sailoff(url)
        case .folded:
            beat = .scroll
            Task { @MainActor in promptUp = true }
        case .torn:
            beat = .awake
        }
    }

    private enum Beat: Equatable {
        case resting
        case sailoff(URL)
        case scroll
        case awake
    }
}
