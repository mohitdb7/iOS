//: [Previous](@previous)

import Foundation

//MARK: - Flyweight design pattern
///This pattern consist of objects with intrinsic property and extrinsic property
///The intrinsic property is local to object, however the extrinsic property is common and passed via function
///and does not hold in memory for each individual but common. This way we save a lot of memory when dealing
///with large objects with repeated properties
enum BrushType: String {
    case thin
    case medium
    case thick
}

enum BrushColor: String {
    case red
    case blue
    case green
    case yellow
    case pink
    case purple
}

///Here Brush is an intrinsic property and color is an extrinsic property
protocol Pen {
    var brush: BrushType { get set }
    var color: BrushColor { get set }
}
class ThickPen: Pen {
    var brush: BrushType = .thick
    var color: BrushColor
    
    init(color: BrushColor) {
        self.color = color
    }
}
class MediumPen: Pen {
    var brush: BrushType = .medium
    var color: BrushColor
    
    init(color: BrushColor) {
        self.color = color
    }
}
class ThinPen: Pen {
    var brush: BrushType = .thin
    var color: BrushColor
    
    init(color: BrushColor) {
        self.color = color
    }
}


class PenFactory {
    private static var cache: [String : Pen] = [:]
    
    ///We cache the objects based on intrinsic and extrinsic properties, and if the user asks for same combination
    ///then we give the object from cache instead of creating it again
    static func getPen(ofThickness thickness: BrushType, ofColor color: BrushColor) -> Pen {
        let key = "\(thickness.rawValue)-\(color.rawValue)"
        if let cachedPen = cache[key] {
            print("Returning existing \(key) pen from cache")
            return cachedPen
        } else {
            var pen: Pen!
            switch thickness {
                case .thin:
                    pen = ThinPen(color: color)
                case .medium:
                    pen = MediumPen(color: color)
                case .thick:
                    pen = ThickPen(color: color)
            }
            print("Creating new \(key) pen")
            cache[key] = pen
            return pen
        }
    }
}

let thinGreenPen = PenFactory.getPen(ofThickness: .thin, ofColor: .green)
let thinBluePen = PenFactory.getPen(ofThickness: .thin, ofColor: .blue)
let thickGreenPen = PenFactory.getPen(ofThickness: .thick, ofColor: .green)
let thinGreenPen2 = PenFactory.getPen(ofThickness: .thin, ofColor: .green)
//: [Next](@next)
