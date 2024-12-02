//
//  CustomWebViewMessageHandler.swift
//  NetworkBuilder
//
//  Created by Mohit Dubey on 02/09/24.
//

import Foundation
import WebKit

class CustomWebViewMessageHandler: NSObject, WKScriptMessageHandler {
    weak var delegate: WKScriptMessageHandler?
    
    init(delegate: WKScriptMessageHandler? = nil) {
        self.delegate = delegate
        super.init()
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        delegate?.userContentController(userContentController, didReceive: message)
    }
}
