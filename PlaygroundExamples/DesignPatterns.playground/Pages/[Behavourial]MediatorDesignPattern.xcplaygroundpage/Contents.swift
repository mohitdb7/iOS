//: [Previous](@previous)

import Foundation
class Weak<T: Collegue> {
    weak var value : T?
    init (value: T) {
        self.value = value
    }
}

protocol Mediator {
    var collegues: [Collegue] { get }
    func notify(message: String, from id: String)
    func addCollegue(collegue: Collegue)
    func addCollegues(collegues: [Collegue])
}
class AirControlTower: Mediator {
    private(set) var collegues: [Collegue]
    
    init(collegues: [Collegue]) {
        self.collegues = collegues
    }
    
    convenience init() {
        self.init(collegues: [])
    }
    
    func notify(message: String, from id: String) {
        collegues.forEach({
            if $0.id != id {
                $0.receiveMessage(message: message)
            }
        })
    }
    
    func addCollegue(collegue: Collegue) {
        if collegues.first(where: { $0.id == collegue.id }) == nil {
            collegues.append(collegue)
        }
    }
    
    func addCollegues(collegues: [Collegue]) {
        self.collegues.append(contentsOf: collegues)
    }
}


protocol Collegue: AnyObject {
    var mediator: Mediator { get set }
    var id: String { get set }
    func sendMessage(message: String)
    func receiveMessage(message: String)
}
extension Collegue {
    func sendMessage(message: String) {
        mediator.notify(message: message, from: id)
    }
    func receiveMessage(message: String) {
        print("Message received from Control tower to \(type(of: self)): \(message)")
    }
}
class ConcreteCollegue: Collegue {
    var mediator: Mediator
    var id: String
    init(mediator: Mediator, id: String) {
        self.mediator = mediator
        self.id = id
    }
}
class Aeroplane: ConcreteCollegue {
    init(mediator: Mediator) {
        super.init(mediator: mediator, id: "Aeroplane")
    }
}
class Chopper: ConcreteCollegue {
    init(mediator: Mediator) {
        super.init(mediator: mediator, id: "Chopper")
    }
}
class PrivateJet: ConcreteCollegue {
    init(mediator: Mediator) {
        super.init(mediator: mediator, id: "PrivateJet")
    }
}

let mediator = AirControlTower()
let aeroplane = Aeroplane(mediator: mediator)
let chopper = Chopper(mediator: mediator)
let privateJet = PrivateJet(mediator: mediator)

mediator.addCollegues(collegues: [aeroplane, chopper, privateJet])
aeroplane.sendMessage(message: "Aeroplane Landing...")
//: [Next](@next)
