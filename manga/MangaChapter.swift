//
//  MangaChapter.swift
//  manga
//
//  Created by Derek Kwong on 4/15/18.
//  Copyright © 2018 Derek Kwong. All rights reserved.
//

import Foundation
import UIKit
import os.log

public class MangaChapter: NSObject, NSCoding {
    struct PropertyKey {
        static let title = "title"
        static let chapterUrl = "chapterUrl"
        static let uploadDate = "uploadDate"
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        guard let title = aDecoder.decodeObject(forKey: PropertyKey.title) as? String
            else{
                os_log("Unable to decode the title for a MangaChapter object.", log: OSLog.default, type: .debug)
                return nil
        }
        guard let chapterUrl = aDecoder.decodeObject(forKey: PropertyKey.chapterUrl) as? String
            else{
                os_log("Unable to decode the chapterUrl for a MangaChapter object.", log: OSLog.default, type: .debug)
                return nil
        }
        let uploadDate = aDecoder.decodeObject(forKey: PropertyKey.uploadDate) as? Date
        self.init(title, chapterUrl, uploadDate)
    }
    
    var title:String, chapterUrl: String, uploadDate:Date?
    required public init(_ title:String, _ chapterUrl: String, _ date: Date?){
        self.title = title
        self.chapterUrl = chapterUrl
        self.uploadDate = date
    }
    
    public func getImages() -> [UIImage]{
        return []
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: PropertyKey.title)
        aCoder.encode(chapterUrl, forKey: PropertyKey.chapterUrl)
        aCoder.encode(uploadDate, forKey: PropertyKey.uploadDate)
    }
    
}
