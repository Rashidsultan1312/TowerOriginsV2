import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var index: JourneyIndex

    var body: some View {
        ChronicleLaunchScaffold {
            if index.onboardingDone {
                FacadeTabView()
            } else {
                OnboardingView()
            }
        }
    }
}
