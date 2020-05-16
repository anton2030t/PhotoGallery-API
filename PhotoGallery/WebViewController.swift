//
//  WebViewController.swift
//  PhotoGallery
//
//  Created by Антон Ларченко on 10.05.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    var publicUrl: String?
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: publicUrl!)
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    
}
