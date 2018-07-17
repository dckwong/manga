//
//  KissManga.swift
//  manga
//
//  Created by Derek Kwong on 4/15/18.
//  Copyright © 2018 Derek Kwong. All rights reserved.
//

import Foundation
import WebKit
import SwiftSoup
import os.log

extension String {
    func regex (pattern: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options(rawValue: 0))
            let nsstr = self as NSString
            let all = NSRange(location: 0, length: nsstr.length)
            var matches : [String] = [String]()
            regex.enumerateMatches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: all) {
                (result : NSTextCheckingResult?, _, _) in
                if let r = result {
                    let result = nsstr.substring(with: r.range) as String
                    matches.append(result)
                }
            }
            return matches
        } catch {
            return [String]()
        }
    }
}

public class KissManga: Manga {
    required public init(_ url:String, _ html:String) {
        let mangaInfo = KissManga.retrieveMangaFromSource(html)
        super.init(mangaInfo.0, URLRequest(url: URL(string: url)!), mangaInfo.1, mangaInfo.4, mangaInfo.3, mangaInfo.2, mangaInfo.5)
    }
    
    required public override init(_ title: String, _ url: URLRequest, _ author: String, _ genres: [String], _ summary: String, _ status: String, _ chapters: [MangaChapter]) {
        super.init(title, url, author, genres, summary, status, chapters)
    }
    
    required public init(_ title: String, _ url: String, _ author: String, _ genres: [String], _ summary: String, _ status: String, _ chapters: [MangaChapter]) {
        super.init(title, url, author, genres, summary, status, chapters)
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
    
    static func retrieveMangaFromSource(_ html:String) -> (title: String, author: String, status: String, summary: String, genres: [String] ,chapters: [MangaChapter]) {
        do{
            let doc: Document = try SwiftSoup.parse(html)
            let everythingButChapters: Elements = try doc.select("div.barContent").get(0).children().get(1).children()
            let chapterInfo: [Element] = try Array(doc.select("table.listing > tbody > tr").array()[2...])
            var title = ""
            var author = ""
            var status = ""
            var summary = ""
            var genres:[String] = []
            var foundChapters: [MangaChapter] = []
            for ele in chapterInfo.reversed(){
                for (index, td) in try ele.select("> td").enumerated(){
                    var chapterTitle = ""
                    var chapterUrl = ""
                    var chapterUploadDate:Date?
                    switch index{
                    case 0:
                        chapterTitle = try td.text()
                        chapterUrl = try td.select("> a").attr("href")
                    case 1:
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "M/d/yyyy"
                        chapterUploadDate = dateFormatter.date(from: try td.text())
                    default:
                        break
                    }
                    foundChapters.append(MangaChapter(chapterTitle, chapterUrl, chapterUploadDate))
                }

            }
            for (index, ele) in everythingButChapters.enumerated(){
                switch index{
                case 0:
                    title = try ele.text()
                case 1:
                    genres = []
                    let foundGenres = try ele.select("> a")
                    for ele in foundGenres{
                        genres.append(try ele.text())
                    }
                case 2:
                    author = try ele.select("> a").text()
                case 3:
                    let foundStatus = String(describing: ele)
                    let ongoing = foundStatus.regex(pattern: "Ongoing")
                    if ongoing.isEmpty{
                        status = "Completed"
                    }
                    else{
                        status = "Ongoing"
                    }
                case 5:
                    summary = try ele.text()
                default:
                    break
                }
            }
            return (title, author, status, summary, genres, foundChapters)
        } catch Exception.Error(_ , let message) {
            print(message)
        } catch {
            print("error")
        }
        return ("title", "author", "status", "summary", [], [])
    }
    
}
