import Foundation

class AcountLaunchRunner {
    static func login() async throws {
        if isLogined == false {
            try await requestLogin()
        }
        try await getData()
    }
    
    static func getData() async throws {
        setupStore()
        if LocalValueStore.didGenerateData {
            try CodableObjStoeHandler.loadAllData()
        }else {
            try await NewAccountDataFactory.generateNewAccountData()
            AstrologyManager.generateNewBackgroudList()
            try CodableObjStoeHandler.saveAllData()
            LocalValueStore.didGenerateData = true
        }
        didPrepareData = true
        NotificationCenter.default.post(name: didFinishLoadDataNotification, object: nil)
    }
    static let didFinishLoadDataNotification: Notification.Name = .init("DataManager.didFinishLoadDataNotification")
    static private(set) var didPrepareData = false
    
    static func setupStore() {
        UserManager.setupStore()
        BreathRecordManager.setupStore()
        AstrologyManager.setupStore()
    }
    
    static var isLogined: Bool {
        return LocalValueStore.userToken.count > 0 && LocalValueStore.didGenerateData
    }
    
    static func requestLogin() async throws {
        let (token, userID) = try await ServerDataRequestor.requestLogin()
        LocalValueStore.userToken = token
        LocalValueStore.userIdent = userID
    }
    
    static func logoutCurrentUser() {
        LocalValueStore.userToken = ""
    }
    
    static func deleteCurrentUser() {
        LocalValueStore.resetData()
        try? CodableObjStoeHandler.clearAllData()
    }
}
