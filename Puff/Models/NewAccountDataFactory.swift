import Foundation

class NewAccountDataFactory {
    static func generateNewAccountData() async throws {
        let userList = try await createUserList()
        let currentUser = try await createCurrentUser()
        
        UserManager.initUserList(userList)
        UserManager.initCurrentUser(currentUser)
    }
    
    static func createUserList() async throws -> [User] {
        //avatar
        var avatarRequestList = [NetMediaInfo]()
        for gender in ["male", "female"] {
            for idx in 1 ... 6 {
                let avatarPath = ProjGlobalInfo.sourcePathPrefix + "/headImage/\(gender)/\(idx).png"
                let requestItem = NetMediaInfo(mediaType: .photo, mediaPath: avatarPath)
                avatarRequestList.append(requestItem)
            }
        }
        let avatarList = try await ServerDataRequestor.requestImageList(itemList: avatarRequestList)
        let (maleAvatarList, femaleAvatarList) = avatarList.splitAndShuffle()!

        //name
        let maleNicknames = try dataList(of: "userName_comunity_male", type: String.self).shuffled()
        let femaleNicknames = try dataList(of: "userName_comunity_female", type: String.self).shuffled()
        
        var userList = [User]()
        for idx in 0 ..< 6 {
            let isLady = (idx % 2 == 0)
            let nameList = isLady ? femaleNicknames : maleNicknames
            let avatarList = isLady ? femaleAvatarList : maleAvatarList

            let user = User()
            user.ident = newIdent(of: .user, offset: idx)
            user.nickName = nameList[idx / 2 % nameList.count]
            user.avatar = avatarList[idx / 2 % avatarList.count]
            userList.append(user)
        }
        return userList.shuffled()
    }
    
    static func createCurrentUser() async throws -> User {
        let isLady = Bool.random()
        //avatar
        let gender = isLady ? "male": "female"
        let avatarIdx = Int.random(in: 1 ... 6)
        let avatarPath = ProjGlobalInfo.sourcePathPrefix + "/headImage/\(gender)/\(avatarIdx).png"
        let requestItem = NetMediaInfo(mediaType: .photo, mediaPath: avatarPath)
        let avatarItem = try await ServerDataRequestor.requestImageList(itemList: [requestItem]).first!

        //name
        let maleNicknames = try dataList(of: "userName_personal_male", type: String.self).shuffled()
        let femaleNicknames = try dataList(of: "userName_personal_female", type: String.self).shuffled()
        
        let idx = Int.random(in: 0 ..< 10)
        let nameList = isLady ? femaleNicknames : maleNicknames

        let user = User()
        user.nickName = nameList[idx]
        user.avatar = avatarItem
        return user
    }
    
    enum IdentPart: Int {
        case user = 10000
        case breath = 20000
    }
    
    static func newIdent(of part: IdentPart, offset: Int) -> String {
        if LocalValueStore.objStartIdent == 0 {
            LocalValueStore.objStartIdent = Int(Date().timeIntervalSince1970)
        }
        let ident = LocalValueStore.objStartIdent + part.rawValue + offset
        return String(ident)
    }

    static func dataList<T>(of name: String, type: T.Type) throws -> [T] {
        let url = Bundle.main.url(forResource: "UserData", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let dataDic = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        let dataList = dataDic[name] as! [T]
        return dataList
    }
}

extension Array {
    //平分并洗牌
    func splitAndShuffle() -> ([Element], [Element])? {
        guard count % 2 == 0 else { return nil } // 确保数组长度为偶数
        let middleIndex = count / 2
        let firstHalf = self[0 ..< middleIndex]
        let secondHalf = self[middleIndex ..< count]
        
        let shuffledFirstHalf = firstHalf.shuffled()
        let shuffledSecondHalf = secondHalf.shuffled()
        
        return (Array(shuffledFirstHalf), Array(shuffledSecondHalf))
    }
    
    //随机打乱顺序
    func shuffled() -> [Element] {
        var newArray = self
        let count = newArray.count
        guard count > 1 else { return newArray }
        
        for i in 0..<(count - 1) {
            let j = Int.random(in: i..<count)
            if i != j {
                newArray.swapAt(i, j)
            }
        }
        return newArray
    }
    
    func getRandomObj() -> Element {
        self[Int.random(in: 0 ..< self.count)]
    }
}

