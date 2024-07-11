//

import UIKit

class KeychainManager: NSObject {
    static func loadKeyChainValue(by key: String) -> String? {
        let getquery = [kSecClass: kSecClassGenericPassword,
                  kSecAttrAccount: key,
                   kSecReturnData: true,
        ] as CFDictionary
        
        var result: CFTypeRef? = nil
        let getStatus = SecItemCopyMatching(getquery as CFDictionary, &result)
        if getStatus == errSecSuccess {
            if let resultData = result as? Data {
                let resultString = String(data: resultData, encoding: .utf8) ?? ""
                return resultString
            }
        }else {
            let msg = SecCopyErrorMessageString(getStatus, nil) as? String ?? "no msg"
            debugPrint(#function, "load keychain \(key) failure, status = \(getStatus), msg: \(msg)")
        }
        return nil
    }
    
    static func saveValueToKeyChain(by key: String, value: String) {
        let addquery = [kSecClass: kSecClassGenericPassword,
                  kSecAttrAccount: key,
                    kSecValueData: value.data(using: .utf8) as AnyObject
        ] as CFDictionary
        let addStatus = SecItemAdd(addquery as CFDictionary, nil)
        if addStatus == errSecSuccess {
            debugPrint("store keychain \(key) success")
        }else {
            let msg = SecCopyErrorMessageString(addStatus, nil) as? String ?? "no msg"
            debugPrint(#function, "store deviceID failure, status = \(addStatus), msg: \(msg)")
        }
    }
}
