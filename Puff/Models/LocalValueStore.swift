import Foundation

class LocalValueStore {
    static private let deviceIDKey = "puff.deviceID"
    static private let userTokenKey = "puff.userToken"
    static private let userIdentKey = "puff.userIdent"
    static private let identStartKey = "puff.identStart"
    static private let generateDataKey = "puff.generateData"

    static func resetData() {
        userToken = ""
        didGenerateData = false
        objStartIdent = 0
    }
    
    static var deviceID: String {
        if let deviceID = KeychainManager.loadKeyChainValue(by: deviceIDKey) {
            return deviceID
        }

        //新建
        let deviceID = UUID().uuidString
        debugPrint("create new deviceID: \(deviceID)")
        KeychainManager.saveValueToKeyChain(by: deviceIDKey, value: deviceID)
        return deviceID
    }
    
    static var userToken: String {
        get {
            UserDefaults.standard.string(forKey: userTokenKey) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: userTokenKey)
        }
    }
    
    static var userIdent: String {
        get {
            UserDefaults.standard.string(forKey: userIdentKey) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: userIdentKey)
        }
    }
    
    static var objStartIdent: Int {
        get {
            UserDefaults.standard.integer(forKey: identStartKey)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: identStartKey)
        }
    }
    
    static var didGenerateData: Bool {
        get {
            UserDefaults.standard.bool(forKey: generateDataKey)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: generateDataKey)
        }
    }
}
