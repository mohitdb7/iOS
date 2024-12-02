//: [Previous](@previous)

import Foundation

//MARK: - Abstract Factory design pattern
///In this design pattern, even the factory get instances from sub-factories based on the condition
///The object creation is abstract and the caller does not know about how the object is created and provided
///It is mainly used when the properties of the class are also classes and instance depends on condition
struct Computer {
    let cpu: CPU
    let gpu: GPU
    let display: Display
    
    init(cpu: CPU, gpu: GPU, display: Display) {
        self.cpu = cpu
        self.gpu = gpu
        self.display = display
    }
}

protocol CPU {
    var cores: Int { get }
}
struct BasicCPU: CPU {
    var cores: Int = 2
}
struct AverageCPU: CPU {
    var cores: Int = 4
}
struct AdvanceCPU: CPU {
    var cores: Int = 8
}

protocol GPU {
    var speed: Int { get }
}
struct BasicGPU: GPU {
    var speed: Int = 200
}
struct AverageGPU: GPU {
    var speed: Int = 400
}
struct AdvanceGPU: GPU {
    var speed: Int = 800
}

protocol Display {
    var resolution: Int { get }
}
struct BasicDisplay: Display {
    var resolution: Int = 600
}
struct AverageDisplay: Display {
    var resolution: Int = 800
}
struct AdvanceDisplay: Display {
    var resolution: Int = 1000
}

enum Specification {
    case basic, average, advance
}

class ComputerFactory {
    func makeCPU() -> CPU {
        fatalError("Implement the function")
    }
    func makeGPU() -> GPU {
        fatalError("Implement the function")
    }
    func makeDisplay() -> Display {
        fatalError("Implement the function")
    }
    func makeComputer(type: Specification) -> Computer {
        var factory: ComputerFactory!
        switch type {
            case .basic:
                factory = BasicComputerFactory()
            case .average:
                factory = AverageComputerFactory()
            case .advance:
                factory = AdvancedComputerFactory()
        }
        return Computer(cpu: factory.makeCPU(), gpu: factory.makeGPU(), display: factory.makeDisplay())
    }
}
class BasicComputerFactory: ComputerFactory {
    override func makeCPU() -> CPU {
        return BasicCPU()
    }
    override func makeGPU() -> GPU {
        return BasicGPU()
    }
    override func makeDisplay() -> Display {
        return BasicDisplay()
    }
}
class AverageComputerFactory: ComputerFactory {
    override func makeCPU() -> CPU {
        return AverageCPU()
    }
    override func makeGPU() -> GPU {
        return AverageGPU()
    }
    override func makeDisplay() -> Display {
        return AverageDisplay()
    }
}
class AdvancedComputerFactory: ComputerFactory {
    override func makeCPU() -> CPU {
        return AdvanceCPU()
    }
    override func makeGPU() -> GPU {
        return AdvanceGPU()
    }
    override func makeDisplay() -> Display {
        return AdvanceDisplay()
    }
}

let computer = ComputerFactory().makeComputer(type: .advance)
print("Core \(computer.cpu.cores), GPU \(computer.gpu.speed), Display \(computer.display.resolution)")

//: [Next](@next)
