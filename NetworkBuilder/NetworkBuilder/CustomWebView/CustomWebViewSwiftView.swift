//
//  CustomWebViewSwiftView.swift
//  NetworkBuilder
//
//  Created by Mohit Dubey on 02/09/24.
//

import Foundation
import SwiftUI
import WebKit

struct CustomWebViewSwiftView: UIViewControllerRepresentable {
    private let configuration: WKWebViewConfiguration
    private let showProgress: Bool
    private let externalLinks: [String]
    private let showNavigation: Bool
    private var navigateURL: URL
    
    init(navigateTo url: URL, configuration: WKWebViewConfiguration = CustomWebViewConfiguration().getConfiguration(),
         showProgress: Bool = true, externalLinks: [String] = ["tel://"], showNavigation: Bool = true) {
        self.configuration = configuration
        self.showProgress = showProgress
        self.externalLinks = externalLinks
        self.showNavigation = showNavigation
        self.navigateURL = url
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let customWebView = CustomWebViewController(navigateTo: navigateURL,
                                                    configuration: configuration, showProgress: showProgress,
                                                    externalLinks: externalLinks, showNavigation: showNavigation)
        
        return customWebView
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
