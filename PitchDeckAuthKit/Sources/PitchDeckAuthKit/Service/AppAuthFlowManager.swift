import Foundation
import AppAuth

@MainActor
public enum AppAuthFlowManager {

    public static var currentAuthorizationFlow: OIDExternalUserAgentSession?

    public static func setCurrentAuthorizationFlow(_ flow: OIDExternalUserAgentSession?) {
        currentAuthorizationFlow = flow
    }

    @discardableResult
    public static func resumeAuthorizationFlow(with url: URL) -> Bool {
        guard let flow = currentAuthorizationFlow else { return false }
        let handled = flow.resumeExternalUserAgentFlow(with: url)
        if handled {
            currentAuthorizationFlow = nil
        }
        return handled
    }
}
