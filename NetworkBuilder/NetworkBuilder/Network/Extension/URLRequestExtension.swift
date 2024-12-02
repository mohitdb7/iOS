//
//  RequestManager.swift
//  NetworkBuilder
//
//  Created by Mohit Dubey on 31/08/24.
//

import Foundation

enum NetworkError: Error {
    case noIdea
}

extension URLRequest {
    func invoke(urlSession: URLSession? = nil) async throws -> (Data, URLResponse) {
        do {
            let (data, response) = try await (urlSession ?? URLSession.shared).data(for: self)
            return (data, response)
        } catch let ex {
            throw ex
        }
    }
    
    func invoke<T: Codable>(urlSession: URLSession? = nil) async throws -> (T, URLResponse) {
        do {
            let (data, response) = try await (urlSession ?? URLSession.shared).data(for: self)
            let result = try JSONDecoder().decode(T.self, from: data)
            return (result, response)
        } catch let ex {
            throw ex
        }
    }
}
