//
//  ViewController.swift
//  Structed
//
//  Created by Sidney San Martin on 11/15/16.
//  Copyright © 2016 Google. All rights reserved.
//

import Cocoa
import WebKit

let webRoot = URL(fileURLWithPath: "/Users/sdy/Google Drive/Code/Structed/www")//#fileLiteral(resourceName:"www")

class ViewController: NSViewController {
  
  var watcher: FSWatcher?

  @IBOutlet weak var webView: WebView! {
    didSet {
      guard let webView = webView else {
        watcher = nil
        return
      }
      
      watcher = FSWatcher(paths: [webRoot.path], latency: 0.1, cb: { [unowned webView] _ in
        DispatchQueue.main.async {
          webView.mainFrame.reload()
        }
      }, flags: [.noDefer])
      
      webView.mainFrame.load(URLRequest(url: webRoot.appendingPathComponent("index.html")))
    }
  }
}

