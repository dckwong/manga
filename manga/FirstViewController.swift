//
//  FirstViewController.swift
//  manga
//
//  Created by Derek Kwong on 4/8/18.
//  Copyright © 2018 Derek Kwong. All rights reserved.
//

import UIKit
import WebKit
import Foundation

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tView: UITableView!
    let webView = WKWebView()
    var mangaStore : [String:Manga] = [:]
    var mangaStoreKeys : [String] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mangaStore.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aManga", for: indexPath)
        cell.textLabel?.text = mangaStoreKeys[indexPath.row]
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mangaStore = MangaStore.loadMangaStore()
        mangaStoreKeys = Array(mangaStore.keys)
        tView.dataSource = self
        tView.delegate = self
        tView.register(UITableViewCell.self, forCellReuseIdentifier: "aManga")
        webView.load(URLRequest(url: URL(string:"http://kissmanga.com/manga/hunter-x-hunter")!))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.mangaStore = MangaStore.loadMangaStore()
        self.mangaStoreKeys = Array(self.mangaStore.keys)
        self.tView.reloadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openBrowser(_ sender: UIButton) {

    }
}

