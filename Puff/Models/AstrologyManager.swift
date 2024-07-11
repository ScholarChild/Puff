//

import Foundation
import SnapKit

class SentenceBackground: Codable {
    var imageName = ""
    var isSelected = false
    var isLock = false
}


class AstrologyManager {
    static private let backgroundListStore = ListStore<SentenceBackground>(storeName: "sentenseBackgroundList.data")
    
    static func setupStore() {
        CodableObjStoeHandler.addStoreToList(backgroundListStore)
    }
    
    static func generateNewBackgroudList() {
        backgroundListStore.modelList = (0 ..< 5).map({ idx in
            let model = SentenceBackground()
            //TODO: 替换图片资源
            model.imageName = "astrologyMainPage_sentenseBackground_\(idx)"
            return model
        })
        backgroundListStore.modelList.first?.isSelected = true
        try? backgroundListStore.save()
    }
    
    static var selectedBackground:  SentenceBackground {
        get {
            backgroundListStore.modelList.first(where: { $0.isSelected })!
        }
        set {
            backgroundListStore.modelList.forEach({ $0.isSelected = ($0.imageName == newValue.imageName) })
            try? backgroundListStore.save()
        }
    }
    
    static func backgroundList() -> [SentenceBackground] {
        backgroundListStore.modelList
    }
    
    static func getTodaySentence() -> (quote: String, author: String) {
        do {
            if let dic = try dataList(of: "daily_sentence", type: [String: String].self).shuffled().first,
               let quote = dic["quote"],
               let author = dic["author"] {
                return (quote, author)
            }
            return ("", "")
        } catch let error {
            print(#function, error)
            return ("", "")
        }
    }
    
    static func getAnswerByBook() -> String {
        do {
            if let answer = try dataList(of: "answer_book", type: String.self).shuffled().first {
                return answer
            }
            return ""
        } catch let error {
            print(#function, error)
            return ""
        }
    }
    
    static func dataList<T>(of name: String, type: T.Type) throws -> [T] {
        let url = Bundle.main.url(forResource: "Astrology", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let dataDic = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        let dataList = dataDic[name] as! [T]
        return dataList
    }
}
