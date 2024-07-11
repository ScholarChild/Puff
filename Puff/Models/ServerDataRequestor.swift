import Foundation
import Alamofire
import Deviice

class ServerDataRequestor {
    static func requestLogin() async throws -> (token: String, userID: String) {
        let url = url(of: .loginRoute)
        let param: [String: Any] = [
            "oauthType": 4,
            "token": LocalValueStore.deviceID
        ]
        
        let resultData = try await AF.request(url, method: .post, parameters: param, headers: self.requestHeader())
            .serializingData().value
        let resultJson = try JSONSerialization.jsonObject(with: resultData, options: []) as! [String: Any]
        netLog(method: "POST", apiName: url,
               header: self.requestHeader().dictionary, params: param,
               responce: resultJson)
        //response data map
        let dataDic = try takeData(from: resultJson) as! [String: Any]
        guard let userToken = dataDic["token"] as? String,
              userToken.count > 0 else {
            throw CustomResponceError(code: -1, msg: "user token is empty")
        }
        guard let userInfo = dataDic["userInfo"] as? [String: Any],
              let userId = userInfo["userId"] as? String
        else {
            throw CustomResponceError(code: -1, msg: "user info not found")
        }
        return (userToken, userId)
    }
    
    static func requestImageList(itemList: [NetMediaInfo]) async throws -> [NetMediaInfo] {
        let url = url(of: .getSourceListRoute)
        let param: [[String: Any]] = itemList.map { item in
            return ["mediaPath":item.mediaPath,
                    "mediaType":item.mediaType.rawValue]
        }
        
        //request
        let urlRequest = try JSONEncoding.default.encode(try URLRequest(url: url, method: .post, headers: self.requestHeader()),
                                                         withJSONObject: param)
        
        let resultData = try await AF.request(urlRequest).serializingData().value
        let resultJson = try JSONSerialization.jsonObject(with: resultData, options: []) as! [String: Any]
        netLog(method: "POST", apiName: url,
               header: urlRequest.headers.dictionary, params: param,
               responce: resultJson)
        //response data map
        let jsonList = try takeData(from: resultJson) as! [[String: Any]]
        return try convertJsonObj(jsonList, to: [NetMediaInfo].self)
    }
    
    static func convertJsonObj<T: Codable>(_ jsonObj: Any, to modelType: T.Type) throws -> T {
        let jsonData = try JSONSerialization.data(withJSONObject: jsonObj)
        return try JSONDecoder().decode(modelType.self, from: jsonData)
    }
    
    static private func takeData(from jsonDic: [String: Any]) throws -> Any {
        if let code = jsonDic["code"] as? Int,
           let msg = jsonDic["msg"] as? String,
           let data = jsonDic["data"] {
            if code == 0 {
                return data
            }else {
                throw CustomResponceError(code: code, msg: msg)
            }
        }
        throw CustomResponceError(code: -1, msg: "json format error")
    }
    
    static private func url(of requestPath: ProjGlobalInfo.RequestPath) -> URL {
        return URL(string: requestPath.rawValue, relativeTo: URL(string: ProjGlobalInfo.hostName))!
    }
    
    static private func requestHeader() -> HTTPHeaders {
        let bundle_name = ProjGlobalInfo.bundleName
        let bundle_version = ProjGlobalInfo.currentVersion
        let lang = Locale.preferredLanguages.first ?? "en"
        let device_type = Device().model.marketingName
        let device_id = LocalValueStore.deviceID
        let headerDic: [String: String] = [
            "ver": bundle_version, // app版本
            "device-id": device_id,// 设备id
            "model": device_type, // 手机型号，如苹果,用组件获取，不要写死
            "lang": lang, // 系统语言
            "sys_lan": lang,
            "is_anchor": "false",
            "pkg": bundle_name, // 包名
            "platform": "iOS",
        ]
        
        var header = HTTPHeaders(headerDic)
        let userToken = LocalValueStore.userToken
        if userToken.count > 0 {
            // 登录成功获取到token后，后续接口需传该请求头
            header.add(name: "Authorization", value: "Bearer \(userToken)")
        }
        
        return header
    }
    
    private static func netLog(method: String, apiName: URL, header: [String : Any], params: Any, responce: [String: Any], error: Error? = nil) {
        let responceStr: String = error?.localizedDescription ?? jsonStr(obj: responce)

        let logStr = """
        Network Log Begin ---->
        METHOD: (\(method)), API: \(apiName.absoluteString)
        HEADER:
        \(jsonStr(obj: header))
        PARAMS:
        \(jsonStr(obj: params))
        RESPONSE:
        \(responceStr)
        Network Log Ending --->
        """
        print("\(logStr)")
    }
    
    static func jsonStr(obj: Any) -> String {
        let errorJson = "[JSON Format error]"
        do {
            let option: JSONSerialization.WritingOptions = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
            let jsonData = try JSONSerialization.data(withJSONObject: obj, options: option)
            return String(bytes: jsonData, encoding: .utf8) ?? errorJson + "json parser failure"
        } catch let error {
            return errorJson + error.localizedDescription
        }
    }
    
    static func testNetEnable() -> Bool {
        return NetworkReachabilityManager.default?.isReachable ?? false
    }
}

struct CustomResponceError: Error {
    let code: Int
    let msg: String
}
