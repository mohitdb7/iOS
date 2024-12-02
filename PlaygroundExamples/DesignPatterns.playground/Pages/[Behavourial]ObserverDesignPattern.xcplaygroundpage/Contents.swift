//: [Previous](@previous)

import Foundation

protocol Publisher {
     func subscribe(_ subscribe: Subscriber)
     func unsubscribe(_ subscribe: Subscriber)
     func broadcastNotification()
}

class ConcretePublisher: Publisher {
    private lazy var state = {
        Int(arc4random_uniform(10))
    }() {
        didSet {
            broadcastNotification()
        }
    }
    private var subscribers: [Subscriber] = []
    
    func subscribe(_ subscriber: Subscriber) {
        subscribers.append(subscriber)
        print("New subscriber added -> \(subscriber.id). New subscribers count is \(subscribers.count)")
    }
    
    func unsubscribe(_ subscriber: Subscriber) {
        if let index = subscribers.firstIndex(where: { $0.id == subscriber.id }) {
            subscribers.remove(at: index)
            print("Subscriber removed -> \(subscriber.id). New subscribers count is \(subscribers.count)")
            return
        }
        print("Subscriber does not exist in current list -> \(subscriber.id)")
    }
    
    func broadcastNotification() {
        subscribers.forEach({ $0.notify(message: "New state value is \(state)") })
    }
    
    func someBusinessLogic() {
        print("Running some complex work that will change the state")
        state = Int(arc4random_uniform(10))
        print("notifications broadcasted")
    }
}

protocol Subscriber {
    var id: String { get }
    func notify(message: String)
}

class ConcreateSubscriber: Subscriber {
    private(set) var id: String = UUID().uuidString
    
    func notify(message: String) {
        print("This is Subscriber \(id), received notification from publisher: \(message)")
    }
}


var publisher: Publisher = ConcretePublisher()

let subscriber1: Subscriber = ConcreateSubscriber()
let subscriber2: Subscriber = ConcreateSubscriber()
let subscriber3: Subscriber = ConcreateSubscriber()

publisher.subscribe(subscriber1)
publisher.subscribe(subscriber2)
publisher.subscribe(subscriber3)

(publisher as! ConcretePublisher).someBusinessLogic()

publisher.unsubscribe(subscriber2)

(publisher as! ConcretePublisher).someBusinessLogic()
//: [Next](@next)
