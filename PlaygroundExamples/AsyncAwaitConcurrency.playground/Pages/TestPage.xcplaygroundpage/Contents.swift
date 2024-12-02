import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let concurrent = DispatchQueue(label: "Concurrent", attributes: [.concurrent])

let lock = NSLock()
var _atomic_int_list: [Int] = []
var atomic_int_list: [Int] {
    get {
        lock.lock()
        defer { lock.unlock() }
        return _atomic_int_list
    }
    set {
        lock.lock()
        defer {lock.unlock()}
        _atomic_int_list = newValue
    }
}

var _synced_int_list: [Int] = []
var synced_int_list: [Int] {
    get {
        concurrent.sync {
            return _synced_int_list
        }
    }
    
    set {
        concurrent.async(flags: .barrier) {
            _synced_int_list = newValue
        }
    }
}


func withAtomic() {
    concurrent.async {
        for i in 0...3 {
            synced_int_list.append(i)
            print("For Synced \(i) -> \(synced_int_list)")
            
            atomic_int_list.append(i)
            print("For Atomic \(i) -> \(atomic_int_list)")
            
        }
    }
    
//    concurrent.async {
        for i in 4...6 {
            synced_int_list.append(i)
            print("For Synced \(i) -> \(synced_int_list)")
            
            atomic_int_list.append(i)
            print("For Atomic \(i) -> \(atomic_int_list)")
        }
//    }
    
//    concurrent.async {
        for i in 7...10 {
            synced_int_list.append(i)
            print("For Synced \(i) -> \(synced_int_list)")
            
            atomic_int_list.append(i)
            print("For Atomic \(i) -> \(atomic_int_list)")
        }
//    }
}

DispatchQueue.global(qos: .default).async {
    print("Inside this function")
    withAtomic()
    print("Inside this function2")
}

DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + 5) {
    print("Inside this function3")
    print("FINAL ATOMIC: \(synced_int_list)")
    
    print("FINAL SYNCED: \(atomic_int_list)")
    print("Inside this function4")
}

