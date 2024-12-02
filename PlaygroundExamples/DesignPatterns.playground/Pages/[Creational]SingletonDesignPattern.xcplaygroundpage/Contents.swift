import UIKit

    //MARK: - Singleton design pattern
    ///This pattern is used when we want to use a shared resource. Any changes done by any of the reference holder will reflect everyone.
    ///This also abstarts the object creation logic
class Singleton {
    static let shared = Singleton(property1: "Property 1 dummy value", property2: "Property 2 dummy value")
    private init(property1: String, property2: String) {
        self.property1 = property1
        self.property2 = property2
    }
    
    var property1: String
    var property2: String
}
