import SwiftUI

struct PrivacyView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ChronicleFrame(leaf: AppConfig.privacyPolicyURL, fresh: true)
                .background(Pigment.navy.ignoresSafeArea())
                .navigationTitle("info.privacy")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(Pigment.navy, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("sheet.close") { dismiss() }
                            .foregroundStyle(Pigment.gold)
                    }
                }
        }
    }
}
