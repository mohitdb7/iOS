//
//  URLExtension.swift
//  NetworkBuilder
//
//  Created by Mohit Dubey on 31/08/24.
//

import Foundation

extension URL {
    func appendOrUpdateURLParameters(queryParameters: [String:Any], updateExistingParameters: Bool = false, sortQueryParameters: Bool = false) -> URL {
        guard var urlComponents = URLComponents(string: self.absoluteString) else {
            return self
        }
        
        for (key, param) in queryParameters {
            if let _ = urlComponents.queryItems?.filter( { $0.name == key }), !updateExistingParameters {
                continue
            }
            
            let queryItem = URLQueryItem(name: key, value: "\(param)")
            urlComponents.queryItems == nil ? urlComponents.queryItems = [queryItem] : urlComponents.queryItems?.append(queryItem)
        }
        
        if sortQueryParameters {
            urlComponents.queryItems?.sort(by: { $0.name < $1.name })
        }
        
        if let url =  urlComponents.url {
            return url
        }
        
        return self
    }
}
