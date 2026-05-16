import Foundation
import UIKit
@preconcurrency import WebKit

enum ScrollReading: Equatable {
    case unfurled(URL)
    case folded
    case torn
}

enum CodexLedger {
    @MainActor
    static func read() async -> ScrollReading {
        await CodexCourier().begin()
    }

    static func collapse(_ url: URL) -> String {
        guard var bits = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return url.absoluteString.lowercased()
        }
        bits.fragment = nil
        bits.scheme = (bits.scheme ?? "https").lowercased()
        bits.host = bits.host?.lowercased()
        var trail = bits.path
        while trail.count > 1 && trail.hasSuffix("/") { trail.removeLast() }
        bits.path = trail
        return bits.url?.absoluteString ?? url.absoluteString.lowercased()
    }
}

@MainActor
final class CodexCourier: NSObject, WKNavigationDelegate {
    private var awaiting: CheckedContinuation<ScrollReading, Never>?
    private var glass: WKWebView?
    private var done = false
    private var sandClock: Task<Void, Never>?

    func begin() async -> ScrollReading {
        await withCheckedContinuation { handle in
            awaiting = handle
            let opt = WKWebViewConfiguration()
            opt.websiteDataStore = .nonPersistent()
            let view = WKWebView(frame: CGRect(x: 0, y: 0, width: 8, height: 8), configuration: opt)
            view.alpha = 0.04
            view.navigationDelegate = self
            view.load(URLRequest(url: AppConfig.originLink))
            glass = view
            sandClock = Task { [weak self] in
                try? await Task.sleep(nanoseconds: 9_000_000_000)
                await MainActor.run { self?.seal(.torn) }
            }
        }
    }

    private func seal(_ reading: ScrollReading) {
        if done { return }
        done = true
        sandClock?.cancel()
        glass?.navigationDelegate = nil
        glass?.stopLoading()
        glass = nil
        awaiting?.resume(returning: reading)
        awaiting = nil
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let target = navigationAction.request.url else {
            decisionHandler(.allow); return
        }
        let origin = AppConfig.originLink
        if CodexLedger.collapse(target) != CodexLedger.collapse(origin) {
            decisionHandler(.cancel)
            seal(.unfurled(target))
            return
        }
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Task { @MainActor [weak self] in
            try? await Task.sleep(nanoseconds: 2_500_000_000)
            guard let self = self, !self.done else { return }
            self.seal(.folded)
        }
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        _ = error
        seal(.torn)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        _ = error
        seal(.torn)
    }
}
