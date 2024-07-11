import UIKit

class RootControllerChangeRunner {
    static func jumpToMainTabbar() {
        guard let window = WindowLetValue.keyWindow else { return }
        showMainTabbar(on: window)
    }
    
    static func jumpToAccountLoginPage() {
        guard let window = WindowLetValue.keyWindow else { return }
        showSignInPage(on: window)
    }
    
    static func showMainTabbar(on window: UIWindow) {
        let tabPage = YHTabContainerController()
        let navi = UINavigationController(rootViewController: tabPage)
        navi.isNavigationBarHidden = true
        window.rootViewController = navi
    }
    
    static func showSignInPage(on window: UIWindow) {
        let signInPage = AccountSetupController()
        let navi = UINavigationController(rootViewController: signInPage)
        navi.isNavigationBarHidden = true
        window.rootViewController = navi
    }
}
