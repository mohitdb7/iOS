//: [Previous](@previous)

import Foundation

protocol CarPart {
    var type: String { get set }
    var price: Double { get }
}

class SingleCarPart: CarPart {
    var type: String
    private let _price: Double
    var price: Double {
        get {
            _price
        }
    }
    init(type: String, price: Double) {
        self.type = type
        self._price = price
    }
}

class MultipleCarParts: CarPart {
    var type: String
    var price: Double {
        get {
            parts.reduce(0) { $0 + $1.price }
        }
    }
    var parts: [CarPart]
    init(type: String, parts: [CarPart]) {
        self.type = type
        self.parts = parts
    }
}

let singleParts = SingleCarPart(type: "Stearing", price: 2000)
let multipleParts = MultipleCarParts(type: "Windows", parts: [SingleCarPart(type: "Left Front Window", price: 1000),
                                                              SingleCarPart(type: "Right Front Window", price: 1000),
                                                              SingleCarPart(type: "Left Back Window", price: 1000),
                                                              SingleCarPart(type: "Right Back Window", price: 1000)])

