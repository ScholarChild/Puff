import UIKit

class YHUserReportManager {
    static func showUserEditSheet(on page: UIViewController, user: User,
                                  blockComplete: @escaping () -> Void, reportComplete: @escaping () -> Void) {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        sheet.addAction(.init(title: "Block", style: .default, handler: { action in
            addBlock(user: user,on: page, blockComplete: blockComplete)
        }))
        sheet.addAction(.init(title: "Report", style: .default, handler: { action in
            showReportSheet(on: page, complete: reportComplete)
        }))
        sheet.addAction(.init(title: "Cancel", style: .cancel))
        page.present(sheet, animated: true)
    }
    
    static func showReportSheet(on page: UIViewController, complete: (() -> Void)? = nil) {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let reasonList = [
            "Invasion of privacy",
            "False advertising",
            "Fraud",
            "Slander",
        ]
        for reason in reasonList {
            sheet.addAction(.init(title: reason, style: .default, handler: { action in
                uploadReport(on: page, complete: complete)
            }))
        }
        sheet.addAction(.init(title: "Cancel", style: .cancel))
        page.present(sheet, animated: true)
    }
    
    static func addBlock(user: User, on page: UIViewController, blockComplete: @escaping () -> Void) {
        let suc_msg = "Blocked successfully"
        let err_msg = "No network, block failed, try again later."
        YHMockNetworkRunner.request(on: page, suc_msg: suc_msg, err_msg: err_msg) {
            UserManager.addBlockList(user: user)
            blockComplete()
        }
    }
    
    static func removeBlock(user: User, on page: UIViewController, blockComplete: @escaping () -> Void) {
        let suc_msg = "Unblocked successfully"
        let err_msg = "No network, unblock failed, try again later."
        YHMockNetworkRunner.request(on: page, suc_msg: suc_msg, err_msg: err_msg) {
            UserManager.removeBlockList(user: user)
            blockComplete()
        }
    }
    
    static func uploadReport(on page: UIViewController, complete: (() -> Void)? = nil) {
        let suc_msg = "Report successfully, we will check and handle it within 24 hours"
        let err_msg = "No network, report failed, try again later."
        YHMockNetworkRunner.request(on: page, suc_msg: suc_msg, err_msg: err_msg, suc_complete: complete)
    }
}

