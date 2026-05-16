import Foundation

enum AppConfig {
    static let originLink = URL(string: "https://keitaro-zaglushka.com")!
    static let privacyPolicyURL = URL(string: "https://hallowtommy.github.io/towerorigins-privacy")!
    static let supportEmail = "support@towerorigins.app"

    static var versionLine: String {
        let mv = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
        let bn = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
        return "v\(mv) · \(bn)"
    }
}
