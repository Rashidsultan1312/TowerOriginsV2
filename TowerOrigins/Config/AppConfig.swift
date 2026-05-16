import Foundation

enum AppConfig {
    static let originLink = URL(string: "https://obrintal.com/txZ7KR")!
    static let privacyPolicyURL = URL(string: "https://www.termsfeed.com/live/6a2469c1-5c57-41bb-b641-dbe34817d232")!
    static let supportEmail = "nov1kovva@icloud.com"

    static var versionLine: String {
        let mv = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
        let bn = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
        return "v\(mv) · \(bn)"
    }
}
