//: [Previous](@previous)

import Foundation

//MARK: Facade Design pattern
///In this design pattern multiple external libraries are exposed via single Facade class.
///The Facade class takes away the extra responsibility of managing the complete system and expose only
///the required subsystem to the client.
///For client the implementation remains abstract and only the facade function is exposed
///Eg could be like imageEditor, where multiple libraries are involved for image editing and client just have to
///call the facade function to complete the complete editing operation.
class System1 {
    func operation1() {
        print("System1-Operation1")
    }
    func operation2() {
        print("System1-Operation2")
    }
    //...
    func operationX() {
        print("System1-OperationX")
    }
}

class System2 {
    func operation1() {
        print("System2-Operation1")
    }
    func operation2() {
        print("System2-Operation2")
    }
        //...
    func operationX() {
        print("System2-OperationX")
    }
}


class Facade {
    private var system1: System1
    private var system2: System2
    
    init(system1: System1, system2: System2) {
        self.system1 = system1
        self.system2 = system2
    }
    
    func operation() {
        print("Performing operations from all the sytems")
        print("Initiating operations from System1")
        system1.operation1()
        system1.operation2()
        system1.operationX()
        print("Initiating operations from System2")
        system2.operation1()
        system2.operation2()
        system2.operationX()
        print("All operations completed")
    }
}

let facade = Facade(system1: System1(), system2: System2())
facade.operation()
//: [Next](@next)
