//: [Previous](@previous)

import Foundation

enum HomeUtilityState {
    case on
    case off
}
protocol HomeUtilityReciever {
    var currentState: HomeUtilityState { get set }
    mutating func on()
    mutating func off()
}

struct Bulb: HomeUtilityReciever {
    var currentState: HomeUtilityState = .off
    mutating func on() {
        if currentState == .on {
            print("Bulb is already on")
            return
        }
        currentState = .on
        print("Bulb is turned on")
    }
    mutating func off() {
        if currentState == .off {
            print("Bulb is already off")
            return
        }
        currentState = .off
        print("Bulb is turned off")
    }
}

struct Fan: HomeUtilityReciever {
    var currentState: HomeUtilityState = .off
    mutating func on() {
        if currentState == .on {
            print("Fan is already on")
            return
        }
        currentState = .on
        print("Fan is turned on")
    }
    mutating func off() {
        if currentState == .off {
            print("Fan is already off")
            return
        }
        currentState = .off
        print("Fan is turned off")
    }
}

protocol HomeUtilityCommand {
    var canUndo: Bool { get set }
    func execute()
    func undo()
}

class TurnOnCommand: HomeUtilityCommand {
    var reciever: HomeUtilityReciever
    init(reciever: inout HomeUtilityReciever) {
        self.reciever = reciever
    }
    
    var canUndo: Bool = false
    func execute() {
        canUndo = true
        reciever.on()
    }
    
    func undo() {
        if !canUndo {
            print("No new state available, cannot undo...")
            return
        }
        canUndo = false
        print("Executing undo!!!")
        reciever.off()
    }
}

class TurnOffCommand: HomeUtilityCommand {
    var reciever: HomeUtilityReciever
    init(reciever: inout HomeUtilityReciever) {
        self.reciever = reciever
    }
    
    var canUndo: Bool = false
    func execute() {
        canUndo = true
        reciever.off()
    }
    
    func undo() {
        if !canUndo {
            print("No new state available, cannot undo...")
            return
        }
        canUndo = false
        print("Executing undo!!!")
        reciever.on()
    }
}

class HomeUtilityInoker {
    let command: HomeUtilityCommand
    init(command: HomeUtilityCommand) {
        self.command = command
    }
    
    func execute() {
        command.execute()
    }
    
    func undo() {
        command.undo()
    }
}

var receiver: HomeUtilityReciever = Fan()
let turnOnInvoker = HomeUtilityInoker(command: TurnOnCommand(reciever: &receiver))
let turnOffInvoker = HomeUtilityInoker(command: TurnOffCommand(reciever: &receiver))

print("----")
turnOnInvoker.execute()
print("----")
turnOnInvoker.undo()
print("----")
turnOnInvoker.execute()
print("----")
turnOnInvoker.execute()
print("----")
turnOffInvoker.execute()
print("----")
turnOffInvoker.execute()
print("----")
turnOffInvoker.undo()
print("----")

//: [Next](@next)
