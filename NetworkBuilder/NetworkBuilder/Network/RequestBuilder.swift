//
//  RequestBuilder.swift
//  NetworkBuilder
//
//  Created by Mohit Dubey on 31/08/24.
//

import Foundation

enum HTTPRequestType {
    case get
    case post(Data)
    case put(Data)
    case delete(Data)
    case upload([String:String]?, [UploadMedia])
    case download
    
    var methodType: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .delete:
            return "DELETE"
        case .upload:
            return "POST"
        case .download:
            return "DOWNLOAD"
        }
    }
}

struct RequestBuilder {
    private var httpMethodType: HTTPRequestType
    private var urlRequest: URLRequest
    
    init?(_ urlString: String, requestType: HTTPRequestType = .get) {
        if let url = URL(string: urlString) {
            self.urlRequest = URLRequest(url: url)
            self.httpMethodType = requestType
            
            switch requestType {
            case .post(let httpBody):
                self.urlRequest.httpBody = httpBody
            case .put(let httpBody):
                self.urlRequest.httpBody = httpBody
            case .delete(let httpBody):
                self.urlRequest.httpBody = httpBody
            case .upload(let params, let media):
                self = setupRequest(params: params, media: media)
            default:
                break
            }
            
            self.defaultHeaders()
            self.setup(httpMethodType: requestType)
        } else {
            return nil
        }
    }
    
    private mutating func setupRequest(params: [String:String]?, media: [UploadMedia]) -> RequestBuilder {
        let boundary = generateBoundary()
        
        self = addHeaders([
            "X-User-Agent": "ios",
            "Accept-Language": "en",
            "Accept": "application/json",
            "Content-Type": "multipart/form-data; boundary=\(boundary)"
        ], replaceExisting: true)
        
        self.urlRequest.httpBody = createRequestBody(params: params, media: media, boundary: boundary)
        setup(httpMethodType: .upload(params, media))
        return self
    }
    
    private mutating func createRequestBody(params: [String:String]?, media: [UploadMedia], boundary: String) -> Data {
        let lineBreak = "\r\n"
        var body = Data()
        
        
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
        }
        
        for photo in media {
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.fileName)\"\(lineBreak)")
            body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
            body.append(photo.data)
            body.append(lineBreak)
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
    
    private func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    private mutating func setup(httpMethodType: HTTPRequestType) {
        urlRequest.httpMethod = httpMethodType.methodType
    }
    
    mutating func setHttpBody(_ httpBody: Data) -> RequestBuilder {
        urlRequest.httpBody = httpBody
        return self
    }
    
    mutating func addHeaders(_ headers: [String:String], replaceExisting: Bool = false) -> RequestBuilder {
        if urlRequest.allHTTPHeaderFields == nil || urlRequest.allHTTPHeaderFields!.isEmpty {
            urlRequest.allHTTPHeaderFields = headers
        } else {
            urlRequest.allHTTPHeaderFields?.merge(headers, replaceExisting: replaceExisting)
        }
        
        return self
    }
    
    @discardableResult private mutating func defaultHeaders() -> RequestBuilder {
        let headers: [String:String] = ["content-type":"application/json"]
        let result = addHeaders(headers)
        return result
    }
    
    mutating func setDefault(for urlRequest: URLRequest) {
        httpMethodType = .get
        self.defaultHeaders()
        self.setup(httpMethodType: httpMethodType)
    }
    
    mutating func addParameters(_ queryParameters: [String : Any], overwriteExisting: Bool = true, sortParameters: Bool = false) -> RequestBuilder  {
        guard let url = urlRequest.url else {
            return self
        }
        
        urlRequest.url = url.appendOrUpdateURLParameters(queryParameters: queryParameters, updateExistingParameters: overwriteExisting, sortQueryParameters: sortParameters)
        
        return self
    }
    
    func buildURLRequest() -> URLRequest {
        return urlRequest
    }
}
