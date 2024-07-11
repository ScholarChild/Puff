import Foundation

class User: Codable {
    var ident: String = ""
    var nickName: String = ""
    var avatar = NetMediaInfo()
}

class NetMediaInfo: Codable {
    enum MediaType: String, Codable {
        case video
        case photo
    }
    private(set) var mediaType: MediaType = .photo
    
    enum CodingKeys: String, CodingKey {
        case thumbURL = "thumbUrl"
        case middleThumbURL = "middleThumbUrl"
        case mediaURL = "mediaUrl"
        case mediaPath = "mediaPath"
        case mediaType
    }
    
    fileprivate(set) var thumbURL: URL? = nil
    fileprivate(set) var middleThumbURL: URL? = nil
    fileprivate(set) var mediaURL: URL? = nil
    fileprivate(set) var mediaPath: String = ""
    
    required init() {}

    required init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.thumbURL = try url(for: .thumbURL, values: values)
        self.middleThumbURL = try url(for: .middleThumbURL, values: values)
        self.mediaURL = try url(for: .mediaURL, values: values)
        self.mediaPath = try values.decode(String.self, forKey: .mediaPath)
        
        let typeValue = try values.decode(String.self, forKey: .mediaType)
        self.mediaType = .init(rawValue: typeValue) ?? .photo
    }
    
    private func url(for key: CodingKeys, values: KeyedDecodingContainer<CodingKeys>) throws -> URL? {
        let urlString = try values.decode(String.self, forKey: key)
        return URL(string: urlString)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(thumbURL?.absoluteString ?? "", forKey: .thumbURL)
        try container.encode(middleThumbURL?.absoluteString ?? "", forKey: .middleThumbURL)
        try container.encode(mediaURL?.absoluteString ?? "", forKey: .mediaURL)
        try container.encode(mediaPath, forKey: .mediaPath)
        try container.encode(mediaType.rawValue, forKey: .mediaType)
    }
    
    init(mediaType: MediaType, mediaPath: String) {
        self.mediaType = mediaType
        self.mediaPath = mediaPath
    }
    
    init(localURL: URL, type: MediaType) {
        self.mediaType = type
        self.thumbURL = localURL
        self.middleThumbURL = localURL
        self.mediaURL = localURL
    }
}
