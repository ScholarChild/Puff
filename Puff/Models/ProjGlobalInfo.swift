import Foundation

class ProjGlobalInfo {
    static let hostName = "http://test-app.puffs.work"
    //TODO: 替换映射路径
    enum RequestPath: String {
        case loginRoute = "/security/oauth"
        case getSourceListRoute = "/shortLink/media/search"
    }
    static let privacyPageURL = URL(string: "https://h5.puffs.work/privacyPolicy.html")!
    static let termPageURL = URL(string: "https://h5.puffs.work/termConditions.html")!
    static let sourcePathPrefix = "aface/jufeng/6/Yuho"
    
    static var currentVersion: String {
        if let appInfo = Bundle.main.infoDictionary,
           let version = appInfo["CFBundleShortVersionString"] as? String {
            return version
        }
        return "1.0.0"
    }
    
    static var bundleName: String {
        if let appInfo = Bundle.main.infoDictionary,
           let name = appInfo["CFBundleIdentifier"] as? String {
            return name
        }
        return ""
    }
}
