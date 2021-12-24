//
//  ViewReportVC.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 13/09/21.
//

import UIKit
import WebKit

class ViewReportVC: UIViewController, WKUIDelegate {

    @IBOutlet weak var reportView: UIView!
    
    var webView: WKWebView!
    var urlStr: String = String()
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
//        webView = WKWebView(frame: .init(x: 20, y: 70, width: 335, height: 577), configuration: webConfiguration)
        webView = WKWebView(frame: .init(x: 20, y: 70, width: 335, height: 577), configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.dsa()
    }
    
    public func dsa() {
        
        let url : NSString = self.urlStr as NSString
        let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
        let searchURL : NSURL = NSURL(string: urlStr as String)!
        
//        let url = URL (string:"http://34.220.107.44/LukeLearning/File/1602595211598PbkQyAte.jpeg")
//        //  let url = URL (string:"http://155.138.205.250:8081/app/account#/login")
        let requestObj = URLRequest(url: searchURL as URL)
        webView.load(requestObj)

        
//        webView.navigationDelegate = self
    }

    func webViewDidStartLoad(_ : WKWebView) {
        showProgressOnView(appDelegateInstance.window!)
    }

    func webViewDidFinishLoad(_ : WKWebView) {
        hideAllProgressOnView(appDelegateInstance.window!)
    }
}
