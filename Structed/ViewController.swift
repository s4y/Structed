import Cocoa
import WebKit

let (webRoot, usingDevRoot): (URL, Bool) = {
  if let devRoot = UserDefaults.standard.url(forKey: "StructedWebRoot") {
    return (devRoot, true)
  }
  return (#fileLiteral(resourceName:"www"), false)
}()

class ViewController: NSViewController {
  
  var watcher: FSWatcher?

  @IBOutlet weak var webView: WebView! {
    
    didSet {
      guard let webView = webView else {
        watcher = nil
        return
      }
      
      if usingDevRoot {
        watcher = FSWatcher(paths: [webRoot.path], latency: 0.1, cb: { [unowned webView] _ in
          DispatchQueue.main.async {
            webView.mainFrame.reload()
          }
        }, flags: [.noDefer])
      }
      
      webView.mainFrame.load(URLRequest(url: webRoot.appendingPathComponent("index.html")))
    }
  }
}
