//
//  UploadMedia.swift
//  NetworkBuilder
//
//  Created by Mohit Dubey on 07/09/24.
//

import Foundation
import UIKit

class UploadMedia {
    let key: String
    let fileName: String
    let data: Data
    let mimeType: String

    init(data: Data, forKey key: String, fileName: String, mimeType: String) {
        self.key = key
        self.mimeType = mimeType
        self.fileName = fileName
        self.data = data
    }
}

class ImageUploadMedia: UploadMedia {
    init?(image: UIImage, forKey key: String, mimeType mime: String? = nil) {
        let mimeType = mime ?? "image/jpg"
        let fileName = "\(arc4random()).jpg"
        guard let data = image.jpegData(compressionQuality: 0.5) else { return nil }
        super.init(data: data, forKey: key, fileName: fileName, mimeType: mimeType)
    }
}

class VideoUploadMedia: UploadMedia {
    init?(data: Data, forKey key: String, mimeType mime: String? = nil) {
        let mimeType = mime ?? "video/mp4"
        let fileName = "\(arc4random()).mp4"
        super.init(data: data, forKey: key, fileName: fileName, mimeType: mimeType)
    }
}

class DocUploadMedia: UploadMedia {
    init?(data: Data, forKey key: String, mimeType mime: String? = nil) {
        let mimeType = mime ?? "application/doc"
        let fileName = "\(arc4random()).doc"
        super.init(data: data, forKey: key, fileName: fileName, mimeType: mimeType)
    }
}

class PDFUploadMedia: UploadMedia {
    init?(data: Data, forKey key: String, mimeType mime: String? = nil) {
        let mimeType = mime ?? "application/pdf"
        let fileName = "\(arc4random()).pdf"
        super.init(data: data, forKey: key, fileName: fileName, mimeType: mimeType)
    }
}

