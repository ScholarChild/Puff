import UIKit
import Toast_Swift

class YHMockNetworkRunner {
    static func request(on page: UIViewController,
                        suc_msg: String = "", err_msg: String,
                        suc_complete: (() -> Void)? = nil) {
        let hasNetwork = ServerDataRequestor.testNetEnable()
        if !hasNetwork {
            toast(msg: err_msg, on: page)
            return
        }
        
        page.view.makeToastActivity(.center)
        let delaySecond = TimeInterval.random(in: 100 ..< 300) / 1000
        DispatchQueue.main.asyncAfter(deadline: .now() + delaySecond) {
            page.view.hideToastActivity()
            toast(msg: suc_msg, on: page)
            suc_complete?()
        }
    }
    
    static func toast(msg: String, on page: UIViewController) {
        guard msg.count > 0 else { return }
        DispatchQueue.main.async {
            page.view.makeToast(msg, duration: 2.5, position: .center)
        }
    }
}

