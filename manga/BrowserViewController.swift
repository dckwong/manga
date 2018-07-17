//
//  BrowserViewController.swift
//  manga
//
//  Created by Derek Kwong on 4/8/18.
//  Copyright © 2018 Derek Kwong. All rights reserved.
//

import UIKit
import WebKit
class BrowserViewController: UIViewController, UITextFieldDelegate, WKNavigationDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var uiSearchBar: UISearchBar!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var BackToFirstSceneButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var addTitleButton: UIBarButtonItem!
    
//    let webView2: WKWebView! = WKWebView()
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        webView2.load(URLRequest(url:URL(string:"http://kissmanga.com/Manga/Hunter-x-Hunter/379---Collaboration?id=410809")!))
//        DispatchQueue.main.asyncAfter(deadline: .now()+10.0) {[unowned self] in
//            self.webView2.evaluateJavaScript("document.cookie = \"vns_readType1=1\" + \";path=/\"; window.location.reload();", completionHandler:{ (html: Any?, error: Error?) in
//            })
//            DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) { [unowned self] in
//                self.webView2.evaluateJavaScript("document.documentElement.innerHTML.toString()", completionHandler:{ (html: Any?, error: Error?) in
//                    print(html!)
//                })
//            }
//        }
        uiSearchBar.autocapitalizationType = UITextAutocapitalizationType.none
        webView.navigationDelegate = self
        activityIndicator.hidesWhenStopped = true
        uiSearchBar.text = "http://kissmanga.com/manga/hunter-x-hunter"
        search()
    }
    
    func checkValidKissMangaUrl(){
        if let url = webView.url{
            let urlString = url.absoluteString
            if urlString.range(of: "(http://)?kissmanga.com/manga/(.)*", options: [.caseInsensitive, .regularExpression]) != nil {
                addTitleButton.isEnabled = true
            }
        }
    }
    
    func checkBackForwardEnabled(){
        backButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward
    }
    func search(){
        if let urlString = uiSearchBar.text {
            if let myURL = URL(string:urlString) {
                let myRequest = URLRequest(url:myURL)
                webView.load(myRequest)
                activityIndicator.startAnimating()
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        uiSearchBar.resignFirstResponder()
        search()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        uiSearchBar.resignFirstResponder()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
        uiSearchBar.text = webView.url!.absoluteString
        checkBackForwardEnabled()
        checkValidKissMangaUrl()
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
        checkBackForwardEnabled()
    }
    
    @IBAction func goBackToFirstScene(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addTitle(_ sender: Any) {
        webView.evaluateJavaScript("document.documentElement.innerHTML.toString()",completionHandler: { (html: Any?,error: Error?) in
            let m = KissManga(self.webView.url!.absoluteString, String(describing: html))
            MangaStore.addToStore(m.title, m)
//            MangaStore.saveManga(m)
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    @IBAction func goForward(_ sender: Any) {
        webView.goForward()
    }
    @IBAction func goBack(_ sender: Any) {
        webView.goBack()
    }
}



