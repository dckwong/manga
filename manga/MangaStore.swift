//
//  MangaStore.swift
//  manga
//
//  Created by Derek Kwong on 5/20/18.
//  Copyright © 2018 Derek Kwong. All rights reserved.
//

import Foundation
import os

class MangaStore {
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("mangastorepath")
    
    static func loadMangaStore() -> [String: Manga]{
        let store = NSKeyedUnarchiver.unarchiveObject(withFile: MangaStore.ArchiveURL.path) as? [String: Manga]
        return store != nil ? store! : [:]
    }
    
    static func saveMangaStore(_ mangaStore: [String: Manga]){
        print("Saving store: ")
        print(mangaStore)
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(mangaStore, toFile: MangaStore.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Manga successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save mangas...", log: OSLog.default, type: .error)
        }
    }
    
    static func addToStore(_ title:String, _ manga: Manga){
        var store = loadMangaStore()
        store[title] = manga
        MangaStore.saveMangaStore(store)
    }
    
    static func deleteFromStore(_ title:String){
        var store = loadMangaStore()
        store.removeValue(forKey: title)
        MangaStore.saveMangaStore(store)
    }
    
    
}
