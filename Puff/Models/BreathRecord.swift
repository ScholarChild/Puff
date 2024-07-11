//

import UIKit

class BreathRecord: Codable {
    fileprivate var ident: String = ""
    fileprivate(set) var ownerID: String = ""
    var createTime = Date()

    var type: BreathType = .regular
    enum BreathType: String, Codable, CaseIterable {
        case regular
        case deStress
        case relax
        
        static var allCases: [BreathRecord.BreathType] = [.regular, .deStress, .relax]
    }
    
    var mode: LoopMode = .breathsCount
    enum LoopMode: String, Codable, CaseIterable {
        case breathsCount
        case minutes
    }
    var modeUnit: Int = 0
}

extension BreathRecord.BreathType {
    var displayName: String {
        switch self {
            case .regular:
                return "Regular";
            case .deStress:
                return "De-Stress"
            case .relax:
                return "Relax"
        }
    }
    
    var icon: UIImage {
        switch self {
            case .regular:
                return UIImage(named: "breathRecord_typeIcon_regular")!
            case .deStress:
                return UIImage(named: "breathRecord_typeIcon_deStress")!
            case .relax:
                return UIImage(named: "breathRecord_typeIcon_relax")!
        }
    }
}

struct BreathLoop {
    let breatheIn: Int
    let inHold: Int
    let breatheOut: Int
    let outHold: Int
    var loopTime: Int {
        breatheIn + inHold + breatheOut + outHold
    }
    
    init(breatheIn: Int, inHold: Int, breatheOut: Int, outHold: Int) {
        self.breatheIn = breatheIn
        self.inHold = inHold
        self.breatheOut = breatheOut
        self.outHold = outHold
    }
    
    init(type: BreathRecord.BreathType) {
        switch type {
            case .regular:
                self.init(breatheIn: 4, inHold: 2, breatheOut: 4, outHold: 2)
            case .deStress:
                self.init(breatheIn: 4, inHold: 2, breatheOut: 6, outHold: 3)
            case .relax:
                self.init(breatheIn: 4, inHold: 4, breatheOut: 4, outHold: 3)
        }
    }
}

class BreathRecordManager {
    static func setupStore() {
        CodableObjStoeHandler.addStoreToList(recordListStore)
    }
    
    static private let recordListStore = ListStore<BreathRecord>(storeName: "breathRecodList.data")
    
    static func addNewCurrentUserRecord(_ record: BreathRecord) {
        let offset = recordListStore.modelList.count
        record.ident = NewAccountDataFactory.newIdent(of: .breath, offset: offset)
        record.ownerID = UserManager.currentUser.ident
        recordListStore.modelList.append(record)
        try? recordListStore.save()
    }
    
    static func totalRecordCount(of type: BreathRecord.BreathType) -> Int {
        return recordListStore.modelList.filter({ $0.type == type }).count
    }
    
    static func todayRecordCount(of type: BreathRecord.BreathType) -> Int {
        return recordListStore.modelList
            .filter({ $0.type == type && Calendar.current.isDateInToday($0.createTime) })
            .count
    }
}
