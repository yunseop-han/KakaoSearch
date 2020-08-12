//
//  Responses.swift
//  KakaoSerch
//
//

import Foundation

enum DocumentType: String {
    case blog, cafe
}

extension Document {
    var shortDate:String {
        let aDayInterval:Double = 86400
        let yesterday = Date(timeIntervalSinceNow: -aDayInterval)
        let beforYesterday = Date(timeInterval: -aDayInterval, since: yesterday)
        if self.datetime.timeIntervalSince1970 > yesterday.timeIntervalSince1970 {
            return "오늘"
        } else if self.datetime.timeIntervalSince1970 > beforYesterday.timeIntervalSince1970 {
            return "어제"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy년 MM월 dd일"
            return formatter.string(from: self.datetime)
        }
    }
    
    var lognDate:String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko-KR")
        formatter.dateFormat = "yyyy년 MM월 dd일 a hh시 mm분"
        return formatter.string(from: self.datetime)
    }
    
    mutating func view() {
        self.isView = true
    }
}




struct Document: Codable, Identifiable, Equatable, Hashable {
    var id: String
    
    var isView: Bool?
    
    var category: DocumentType?
    
    var title: String
    
    var contents: String
    
    var url: String
    
    var name: String?
    
    var thumbnail: String
    
    var datetime: Date
    
    enum CodingKeys: String, CodingKey {
        case title, contents, url, thumbnail, datetime
    }
    enum BlogKey: String, CodingKey {
        case name = "blogname"
    }
    
    enum CafeKey: String, CodingKey {
        case name = "cafename"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let title = try values.decode(String.self, forKey: .title)
        self.title = title.removeHTML()
        
        let contents = try values.decode(String.self, forKey: .contents)
        self.contents = contents.removeHTML()
        
        thumbnail = try values.decode(String.self, forKey: .thumbnail)
        url = try values.decode(String.self, forKey: .url)
        id = url
        
        let dateString = try values.decode(String.self, forKey: .datetime)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000zzzzz"
        datetime = dateFormatter.date(from: dateString)!
        
        do {
            let values = try decoder.container(keyedBy: BlogKey.self)
            name = try values.decode(String.self, forKey: .name)
            category = .blog
            return
        } catch {
        }
        
        do {
            let values = try decoder.container(keyedBy: CafeKey.self)
            name = try values.decode(String.self, forKey: .name)
            category = .cafe
            return
        } catch {
        }
    }
}

struct KakaoSearchResponse: Codable {
    let meta: Meta
    struct Meta: Codable {
        let totalCount: Int
        let pageableCount: Int
        let isEnd: Bool
        
        enum CodingKeys: String, CodingKey {
            case totalCount = "total_count"
            case pageableCount = "pageable_count"
            case isEnd = "is_end"
        }
    }
    
    let documents: [Document]
}
