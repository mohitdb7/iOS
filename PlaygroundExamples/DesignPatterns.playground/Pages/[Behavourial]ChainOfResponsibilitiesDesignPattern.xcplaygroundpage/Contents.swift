//: [Previous](@previous)

import Foundation

//MARK: Chain of Responsibility design pattern
///In this pattern a chain of responsibility is passed and the each handler can either handle the request or pass
///it to next handler to handle.
///The chain of handler can be dynamic and user can decide any sequence of handling


enum Commands: String {
    case monkey
    case squirrel
    case bear
    
}
protocol ChainOfResponsibility {
    var handler: ChainOfResponsibility? { get set }
    func handle(command: String) -> ChainOfResponsibility?
}
class MonkeyHandler: ChainOfResponsibility {
    var handler: ChainOfResponsibility?
    init(handler: ChainOfResponsibility?) {
        self.handler = handler
    }
    func handle(command: String) -> ChainOfResponsibility? {
        print("[Start] Monkey handler will try to handle the command \(command)")
        if command == Commands.monkey.rawValue {
            print("[Success] Monkey handler handles the command \(command)")
            return nil
        }
        
        print("[Failure] Monkey handler cannot handle the command \(command)")
        
        return handler?.handle(command: command)
    }
}
class SquirrelHandler: ChainOfResponsibility {
    var handler: ChainOfResponsibility?
    init(handler: ChainOfResponsibility?) {
        self.handler = handler
    }
    func handle(command: String) -> ChainOfResponsibility? {
        print("[Start] Squirrel handler will try to handle the command \(command)")
        if command == Commands.squirrel.rawValue {
            print("[Success] Squirrel handler handles the command \(command)")
            return nil
        }
        
        print("[Failure] Squirrel handler cannot handle the command \(command)")
        
        return handler?.handle(command: command)
    }
}
class BearHandler: ChainOfResponsibility {
    var handler: ChainOfResponsibility?
    init(handler: ChainOfResponsibility?) {
        self.handler = handler
    }
    func handle(command: String) -> ChainOfResponsibility? {
        print("[Start] Bear handler will try to handle the command \(command)")
        if command == Commands.bear.rawValue {
            print("[Success] Bear handler handles the command \(command)")
            return nil
        }
        
        print("[Failure] Bear handler cannot handle the command \(command)")
        
        return handler?.handle(command: command)
    }
}

let command = "bear"
let commandHandler = MonkeyHandler(handler: SquirrelHandler(handler: BearHandler(handler: nil)))
commandHandler.handle(command: command)

//: [Next](@next)
