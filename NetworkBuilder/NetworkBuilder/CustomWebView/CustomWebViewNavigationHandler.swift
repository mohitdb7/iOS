//
//  CustomWebViewNavigationHandler.swift
//  NetworkBuilder
//
//  Created by Mohit Dubey on 02/09/24.
//

import Foundation
import WebKit

protocol WebViewNavigationHandler: AnyObject {
    func navigationCancelled()
    func navigationCompleted()
    func aboutBlankNavigationRequested()
    func navigatingTo(page currentPage: String)
    func pageLoad(percentage: Double)
}

class CustomWebViewNavigationHandler: NSObject, WKNavigationDelegate {
    weak var delegate: WebViewNavigationHandler?
    weak var webView: WKWebView?
    let externalHostLinks: [String]
    init(externalHostLinks: [String]) {
        self.externalHostLinks = externalHostLinks
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if (navigationAction.request.url?.absoluteString ?? "").elementsEqual("about:blank") {
            decisionHandler(.cancel)
            delegate?.aboutBlankNavigationRequested()
            return
        }
        
        if externalHostLinks.first(where: {
                (navigationAction.request.url?.absoluteString ?? "").lowercased().contains($0.lowercased())
        }) != nil {
            decisionHandler(.cancel)
            if let url = navigationAction.request.url,
                UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                
                delegate?.navigationCancelled()
            }
            return
        }
        
        decisionHandler(.allow)
        var hostString = ""
        if let host = navigationAction.request.url?.host {
            hostString = host + " ➜ "
        }
        delegate?.navigatingTo(page: "\(hostString)\(navigationAction.request.url?.absoluteString ?? "")")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        if  //error.localizedDescription == "Redirection to URL with a scheme that is not HTTP(S)",
            let urlString = (error as NSError).userInfo[NSURLErrorFailingURLStringErrorKey] as? String,
            let url = URL(string: urlString),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:],
                                      completionHandler: nil)
            delegate?.navigationCancelled()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            let percentage = webView?.estimatedProgress ?? 0
            delegate?.pageLoad(percentage: percentage)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        delegate?.navigationCompleted()
    }
}

