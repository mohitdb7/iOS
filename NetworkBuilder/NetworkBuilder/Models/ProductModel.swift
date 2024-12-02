//
//  ProductModel.swift
//  NetworkBuilder
//
//  Created by Mohit Dubey on 31/08/24.
//

import Foundation

struct ProductModel: Codable {
    var id: Int?
    var price: Double?
    var description, category, title, image: String?
    var rating: RatingModel?
}

// MARK: - Rating
struct RatingModel: Codable {
    var rate: Double?
    var count: Int?
}
