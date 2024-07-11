//

import UIKit

class UserManager: NSObject {
    static func setupStore() {
        CodableObjStoeHandler.addStoreToList(currentUserStore)
        CodableObjStoeHandler.addStoreToList(userListStore)
        CodableObjStoeHandler.addStoreToList(blockListStore)
    }
    
    //MARK: - Current User
    static private let currentUserStore = ModelStore(storeName: "currentUser.data") { User() }
    static func initCurrentUser(_ currentUser: User) {
        currentUserStore.model = currentUser
    }
    
    static var currentUser: User {
        currentUserStore.model
    }
    
    static func isCurrentUser(_ user: User) -> Bool {
        return user.ident == currentUser.ident
    }
    
    static func saveCurrentUser() {
        try? currentUserStore.save()
    }
    
    //MARK: - User List
    static private let userListStore = ListStore<User>(storeName: "userList.data")
    static func initUserList(_ userList: [User]) {
        userListStore.modelList = userList
    }
    
    static func allUserList() -> [User] {
        return userListStore.modelList + [currentUser]
    }
    
    //MARK: - Block List
    static private let blockListStore = ListStore<String>(storeName: "blockList.data")
    
    static func getBlockUserList() -> [User] {
        let blockList = blockListStore.modelList
        return allUserList().filter({ blockList.contains($0.ident) })
    }
    
    static func getBlockIdentList() -> [String] {
        return blockListStore.modelList
    }
    
    static func addBlockList(user: User) {
        blockListStore.modelList.append(user.ident)
        try? blockListStore.save()
    }
    
    static func removeBlockList(user: User) {
        guard let idx = blockListStore.modelList.firstIndex(where: { $0 == user.ident }) else { return }
        blockListStore.modelList.remove(at: idx)
        try? blockListStore.save()
    }
}
