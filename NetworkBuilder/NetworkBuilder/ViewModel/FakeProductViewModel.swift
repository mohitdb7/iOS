//
//  FakeProductViewModel.swift
//  NetworkBuilder
//
//  Created by Mohit Dubey on 31/08/24.
//

import Foundation
import UIKit

class FakeProductViewModel: ObservableObject {
    let taskDelegate: TaskDelegate = TaskDelegate()
    
    func getProducts() {
        //https://fakestoreapi.com/products
        //https://jsonplaceholder.typicode.com/posts
        //https://fakestoreapi.com/products?limit=5
        guard var requestBuilder = RequestBuilder("https://fakestoreapi.com/products") else {
            return
        }
        let request = requestBuilder
            .addParameters(["limit":2])
            .buildURLRequest()
        
        Task {
            do {
                let (products, _): ([ProductModel], URLResponse) = try await request.invoke()
                for product in products {
                    print(product.title)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func addProduct() {
        let product = ProductModel(price: 13.5, description: "Lorem Ipsum Description", category: "Electronic", title: "Lorem Ipsum Title", image: "Image1")
        do {
            let encodedProduct = try JSONEncoder().encode(product)
            guard let requestBuilder = RequestBuilder("https://fakestoreapi.com/products", requestType: .post(encodedProduct)) else {
                return
            }
            let request = requestBuilder.buildURLRequest()
            
            Task {
                do {
                    let (data, _): (Data, URLResponse) = try await request.invoke()
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    print(json)
                } catch let error {
                    print(error.localizedDescription)
                }
            }
            
        } catch let ex {
            print(ex.localizedDescription)
        }
    }
    
    func dummyFunction() {
        guard let requestBuilder = RequestBuilder("http://localhost:8080/dummy") else {
            return
        }
        let request = requestBuilder.buildURLRequest()
        
        Task {
            do {
                let (data, _): (Data, URLResponse) = try await request.invoke()
                
                if let str = String(data: data, encoding: .utf8) {
                    print("Successfully decoded: \(str)")
                } else {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    print(json)
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func uploadImage() {
        guard let imageData = UIImage(named: "IMG_1098")?.pngData(),
              let pngImage = UIImage(data: imageData),
              let media = ImageUploadMedia(image: pngImage, forKey: "form-id") else {
            return
        }
        
        
        guard let requestBuilder = RequestBuilder("http://localhost:8080/upload", requestType: .upload(["order_ext_id": "form-id"], [media])) else {
            return
        }
        
        let request = requestBuilder.buildURLRequest()
        Task {
            do {
                var session = URLSession(configuration: URLSessionConfiguration.default, delegate: taskDelegate, delegateQueue: OperationQueue.main)
                let (data, _): (Data, URLResponse) = try await request.invoke(urlSession: session)
                
                if let str = String(data: data, encoding: .utf8) {
                    print("Successfully decoded: \(str)")
                } else {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    print(json)
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func uploadVideo() {
//        IMG_1096.MOV
        guard let videoData = NSDataAsset(name: "IMG_1096")?.data,
              let media = VideoUploadMedia(data: videoData, forKey: "form-id")else {
            return
        }
        
        guard let requestBuilder = RequestBuilder("http://localhost:8080/upload", requestType: .upload(["order_ext_id": "form-id"], [media])) else {
            return
        }
        
        
        let request = requestBuilder.buildURLRequest()
        Task {
            do {
                var session = URLSession(configuration: URLSessionConfiguration.default, delegate: taskDelegate, delegateQueue: OperationQueue.main)
                let (data, _): (Data, URLResponse) = try await request.invoke(urlSession: session)
                
                if let str = String(data: data, encoding: .utf8) {
                    print("Successfully decoded: \(str)")
                } else {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    print(json)
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
    }
}


class TaskDelegate: NSObject {
    
}

extension TaskDelegate: URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let uploadProgress = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        print("Progress is \(uploadProgress)")
    }
}
