//
//  KissMangaWebView.swift
//  manga
//
//  Created by Derek Kwong on 4/15/18.
//  Copyright © 2018 Derek Kwong. All rights reserved.
//

import Foundation
import WebKit

public class KissMangaWebView: WKWebView{
    func retryUntilNotChecking(){
        self.evaluateJavaScript("document.URL", completionHandler:{ (html: Any?, error: Error?) in
            if(html == nil){
                self.retryUntilNotChecking()
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in
//                    self.retryUntilNotChecking()
//                }
            }
        })
        
        self.evaluateJavaScript("document.documentElement.innerHTML.toString()", completionHandler:{ (html: Any?, error: Error?) in
            let htm = String(describing: html)
            print(htm)
            if(htm.isEmpty || htm.lowercased().range(of: "please wait 5 seconds") != nil){
                print("waiting")
                self.retryUntilNotChecking()
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in
//                    self.retryUntilNotChecking()
//                }
            }
            else{
                print("done waiting")
            }
                        })
        
    }
}
