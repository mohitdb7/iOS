//: [Previous](@previous)

import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

extension Thread {
    var threadName: String {
        if let currentOperationQueue = OperationQueue.current?.name {
            return "OperationQueue: \(currentOperationQueue)"
        } else if let underlyingDispatchQueue = OperationQueue.current?.underlyingQueue?.label {
            return "DispatchQueue: \(underlyingDispatchQueue)"
        } else {
            let name = __dispatch_queue_get_label(nil)
            return String(cString: name, encoding: .utf8) ?? Thread.current.description
        }
    }
}


//let imageDownloadQueue = DispatchQueue(label: "ImageDownloadQueue", qos: .utility,  attributes: [.concurrent])
//
//print(String(repeating: "-", count: 20), "Experiment #1 - Semaphore (2)", String(repeating: "-", count: 20))
//// This will allow to execute two threads at a time
//let semaphore = DispatchSemaphore(value: 2)
//func downloadImage() {
//    for i in 0...10 {
//        imageDownloadQueue.async {
//            semaphore.wait()
//            print("Signal wait \(i)")
//            do {
//                print("<\(Thread.current.threadName)> Starting to download image \(i)")
//                if let url = URL(string: "https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg") {
//                    let data = try Data(contentsOf: url)
//                }
//                print("<\(Thread.current.threadName)> Downloaded image \(i)")
//            } catch {
//                print("Exception in downloading image \(error)")
//            }
//            
//            semaphore.signal()
//        }
//    }
//}
//
//DispatchQueue.global().async {
//    downloadImage()
//}

//Expected output:
//-------------------- Experiment #1 - Semaphore (2) --------------------
//Signal wait 0
//Signal wait 1
//<ImageDownloadQueue> Starting to download image 0
//<ImageDownloadQueue> Starting to download image 1
//<ImageDownloadQueue> Downloaded image 1
//Signal wait 2
//<ImageDownloadQueue> Starting to download image 2
//<ImageDownloadQueue> Downloaded image 0
//Signal wait 3
//<ImageDownloadQueue> Starting to download image 3
//<ImageDownloadQueue> Downloaded image 2
//Signal wait 4
//<ImageDownloadQueue> Starting to download image 4
//<ImageDownloadQueue> Downloaded image 3
//Signal wait 5
//<ImageDownloadQueue> Starting to download image 5
//<ImageDownloadQueue> Downloaded image 4
//Signal wait 6
//<ImageDownloadQueue> Starting to download image 6
//<ImageDownloadQueue> Downloaded image 5
//Signal wait 7
//<ImageDownloadQueue> Starting to download image 7
//<ImageDownloadQueue> Downloaded image 7
//Signal wait 8
//<ImageDownloadQueue> Starting to download image 8
//<ImageDownloadQueue> Downloaded image 6
//Signal wait 9
//<ImageDownloadQueue> Starting to download image 9
//<ImageDownloadQueue> Downloaded image 8
//Signal wait 10
//<ImageDownloadQueue> Starting to download image 10
//<ImageDownloadQueue> Downloaded image 9
//<ImageDownloadQueue> Downloaded image 10

/*
 Explaination:
 We declared a semaphore with limit 2
 It will allow only two thread execution at a time. Nwxt thread execution will start only when current number of threads < 2
 */


print(String(repeating: "-", count: 20), "Experiment #2 - NSLock Atomic", String(repeating: "-", count: 20))

let concurrent = DispatchQueue(label: "Concurrent", attributes: [.concurrent])


let atomic = DispatchQueue(label: "Atomic", attributes: [.concurrent])
let lock: NSLock = NSLock()
var _int_list: [Int] = []
let semaphore = DispatchSemaphore(value: 1)

var int_list: [Int] {
    get {
//        lock.lock()
//        
//        defer {
//            lock.unlock()
//        }
//        return _int_list
        atomic.sync {
            return _int_list
        }
    }
    
    set {
//        lock.lock()
//        _int_list = newValue
//        lock.unlock()
        
        atomic.async(flags: .barrier) {
            _int_list = newValue
        }
    }
}


func withAtomic() {
    concurrent.async {
        for i in 0...3 {
            int_list.append(i)
            
            print("For \(i) -> \(int_list)")
        }
    }
    
    concurrent.async {
        for i in 4...6 {
            int_list.append(i)
            
            print("For \(i) -> \(int_list)")
        }
    }
    
    concurrent.async {
        for i in 7...10 {
            int_list.append(i)
            
            print("For \(i) -> \(int_list)")
        }
    }
}

DispatchQueue.global().async {
    withAtomic()
}

concurrent.asyncAfter(deadline: .now() + 3) {
    print("\(int_list)")
}

//-------------------- Experiment #2 - NSLock Atomic --------------------
//For 0 -> [0, 7]
//For 7 -> [0, 4]
//For 4 -> [0, 4, 1]
//For 1 -> [0, 4, 1, 8]
//For 8 -> [0, 4, 1, 8]
//For 2 -> [0, 4, 1, 8, 5]
//For 5 -> [0, 4, 1, 8, 5]
//For 9 -> [0, 4, 1, 8, 5, 9, 6]
//For 6 -> [0, 4, 1, 8, 5, 9, 6]
//For 3 -> [0, 4, 1, 8, 5, 9, 6]
//For 10 -> [0, 4, 1, 8, 5, 9, 6, 10]
//[0, 4, 1, 8, 5, 9, 6, 10]
