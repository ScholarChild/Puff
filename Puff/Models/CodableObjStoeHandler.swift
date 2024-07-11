import Foundation

protocol StoreRunner {
    func save() throws
    func load() throws
    func clear() throws
}

class ListStore<T: Codable>: StoreRunner {
    var modelList: [T] = []
    let storeName: String
    required init(storeName: String) {
        self.storeName = storeName
        CodableObjStoeHandler.storeList.append(self)
    }
    
    func save() throws {
        try CodableObjStoeHandler.saveModel(self.modelList, fileName: storeName)
    }
    
    func load() throws {
        modelList = try CodableObjStoeHandler.loadModel([T].self, fileName: storeName)
    }
    
    func clear() throws {
        modelList.removeAll()
        try save()
    }
}

class ModelStore<T: Codable>: StoreRunner {
    var model: T
    let storeName: String
    private var modelFactory: () -> T
    required init(storeName: String, modelFactory: @escaping () -> T) {
        self.storeName = storeName
        self.model = modelFactory()
        self.modelFactory = modelFactory
        CodableObjStoeHandler.storeList.append(self)
    }
    
    func save() throws {
        try CodableObjStoeHandler.saveModel(self.model, fileName: storeName)
    }
    
    func load() throws {
        model = try CodableObjStoeHandler.loadModel(T.self, fileName: storeName)
    }
    
    func clear() throws {
        self.model = modelFactory()
        try save()
    }
}

class CodableObjStoeHandler {
    static func addStoreToList(_ store: StoreRunner) {
        storeList.append(store)
    }
    
    static func loadAllData() throws {
        try storeList.forEach({ try $0.load() })
    }
    
    static func saveAllData() throws {
        try storeList.forEach({ try $0.save() })
    }
    
    static func clearAllData() throws {
        try storeList.forEach({ try $0.clear() })
    }
    
    static fileprivate var storeList: [StoreRunner] = []
    
    static private let encoder = JSONEncoder()
    static private let decoder = JSONDecoder()
    
    static func saveModel<T: Codable>(_ model: T, fileName: String) throws {
        let savePath = try getFileURL(fileName: fileName)
        let data = try encoder.encode(model)
        try data.write(to: savePath, options: [.atomic])
    }
    
    static func loadModel<T: Codable>(_ type: T.Type, fileName: String) throws -> T {
        let savePath = try getFileURL(fileName: fileName)
        let data = try Data(contentsOf: savePath, options: [])
        return try decoder.decode(type.self, from: data)
    }
    
    static func getFileURL(fileName: String) throws -> URL {
        let documentDirectory = try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        let savePath = documentDirectory.appendingPathComponent(fileName)
        return savePath
    }
}
