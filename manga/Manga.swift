//
//  Manga.swift
//  manga
//
//  Created by Derek Kwong on 4/12/18.
//  Copyright © 2018 Derek Kwong. All rights reserved.
//

import Foundation
import os

public class Manga: NSObject, NSCoding{
    var title:String
    var url:URLRequest
    var author:String
    var genres:[String]
    var status:String
    var summary:String
    var chapters:[MangaChapter]
    
    struct PropertyKey {
        static let title = "title"
        static let url = "url"
        static let author = "author"
        static let genres = "genres"
        static let summary = "summary"
        static let status = "status"
        static let chapters = "chapters"
    }
    
    init(_ title:String, _ url:URLRequest, _ author:String, _ genres: [String], _ summary:String, _ status:String, _ chapters:[MangaChapter]){
        self.title = title
        self.url = url
        self.author = author
        self.genres = genres
        self.summary = summary
        self.status = status
        self.chapters = chapters
    }
    
    required public init(_ title:String, _ url:String, _ author:String, _ genres: [String], _ summary:String, _ status:String, _ chapters:[MangaChapter]){
        self.title = title
        self.url = URLRequest(url: URL(string: url)!)
        self.author = author
        self.genres = genres
        self.summary = summary
        self.status = status
        self.chapters = chapters
    }
    
    required convenience public init?(coder aDecoder: NSCoder) {
        guard let title = aDecoder.decodeObject(forKey: PropertyKey.title) as? String
            else{
                os_log("Unable to decode the title for a KissManga object.", log: OSLog.default, type: .debug)
                return nil
        }
        guard let url = aDecoder.decodeObject(forKey: PropertyKey.url) as? URLRequest
            else{
                os_log("Unable to decode the url for a KissManga object.", log: OSLog.default, type: .debug)
                return nil
        }
        guard let author = aDecoder.decodeObject(forKey: PropertyKey.author) as? String
            else{
                os_log("Unable to decode the author for a KissManga object.", log: OSLog.default, type: .debug)
                return nil
        }
        guard let genres = aDecoder.decodeObject(forKey: PropertyKey.genres) as? [String]
            else{
                os_log("Unable to decode the genres for a KissManga object.", log: OSLog.default, type: .debug)
                return nil
        }
        guard let summary = aDecoder.decodeObject(forKey: PropertyKey.summary) as? String
            else{
                os_log("Unable to decode the summary for a KissManga object.", log: OSLog.default, type: .debug)
                return nil
        }
        guard let status = aDecoder.decodeObject(forKey: PropertyKey.status) as? String
            else{
                os_log("Unable to decode the status for a KissManga object.", log: OSLog.default, type: .debug)
                return nil
        }
        guard let chapters = aDecoder.decodeObject(forKey: PropertyKey.chapters) as? [MangaChapter]
            else{
                os_log("Unable to decode the chapters for a KissManga object.", log: OSLog.default, type: .debug)
                return nil
        }
        self.init(title, url, author, genres, summary, status, chapters)
    }
    
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: PropertyKey.title)
        aCoder.encode(author, forKey: PropertyKey.author)
        aCoder.encode(url, forKey: PropertyKey.url)
        aCoder.encode(genres, forKey: PropertyKey.genres)
        aCoder.encode(summary, forKey: PropertyKey.summary)
        aCoder.encode(status, forKey: PropertyKey.status)
        aCoder.encode(chapters, forKey: PropertyKey.chapters)
    }
}
