//: [Previous](@previous)

import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true
//Heavy image
//https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg

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

//print(String(repeating: "-", count: 20), "Experiment #1", String(repeating: "-", count: 20))
//let imageDownloadQueue = DispatchQueue(label: "ImageDownloadQueue", qos: .utility,  attributes: [.concurrent])
//
//func imageDownload() {
//    for i in 0...5 {
//        print("<\(Thread.current.threadName)> Before thread start \(i)")
//        imageDownloadQueue.async {
//            do {
//                print("<\(Thread.current.threadName)> Starting to download image \(i)")
//                if let url = URL(string: "https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg") {
//                    let data = try Data(contentsOf: url)
//                }
//                print("<\(Thread.current.threadName)> Downloaded image \(i)")
//            } catch {
//                print("Exception in downloading image \(error)")
//            }
//        }
//    }
//}
//
//imageDownload()
//
////This will be called on main queue
//imageDownloadQueue.sync {
//    print("<\(Thread.current.threadName)> ImageDownloadQueue sync call")
//}
//
//imageDownloadQueue.async {
//    print("<\(Thread.current.threadName)> ImageDownloadQueue async call")
//}
//print(String(repeating: "-", count: 20), "<\(Thread.current.threadName)> End of Experiment #1", String(repeating: "-", count: 20))

//Expected Output
//Disclaimer -> Downloaded message may differ based on image downloading
/*
 "ImageDownloadQueue sync call" will be called on main thread
 - "ImageDownloadQueue" - Async will start when sync is called as it will follow FIFO
 */
//-------------------- Experiment #2 --------------------
//<OperationQueue: NSOperationQueue Main Queue> Before thread start 0
//<OperationQueue: NSOperationQueue Main Queue> Before thread start 1
//<OperationQueue: NSOperationQueue Main Queue> Before thread start 2
//<OperationQueue: NSOperationQueue Main Queue> Before thread start 3
//<OperationQueue: NSOperationQueue Main Queue> Before thread start 4
//<OperationQueue: NSOperationQueue Main Queue> Before thread start 5
//<OperationQueue: NSOperationQueue Main Queue> ImageDownloadQueue sync call
//<ImageDownloadQueue> Starting to download image 4
//<ImageDownloadQueue> Starting to download image 0
//<ImageDownloadQueue> Starting to download image 2
//<ImageDownloadQueue> Starting to download image 1
//<ImageDownloadQueue> Starting to download image 5
//<ImageDownloadQueue> Starting to download image 3
//<ImageDownloadQueue> ImageDownloadQueue async call
//<OperationQueue: NSOperationQueue Main Queue> End of playground
//<ImageDownloadQueue> Downloaded image 4
//<ImageDownloadQueue> Downloaded image 5
//<ImageDownloadQueue> Downloaded image 1
//<ImageDownloadQueue> Downloaded image 3
//<ImageDownloadQueue> Downloaded image 0
//<ImageDownloadQueue> Downloaded image 2


var starttime = Date.now
var iscompleted = 0 {
    didSet {
        if iscompleted >= 4 {
            var dateDelta = Date.now.timeIntervalSince(starttime)
            print("Time it took to execute - \(dateDelta)")
        }
    }
}
print(String(repeating: "-", count: 20), "Experiment #1a", String(repeating: "-", count: 20))
let imageDownloadQueue = DispatchQueue(label: "ImageDownloadQueue", qos: .utility, attributes: [.concurrent])

func imageDownload() {
    print("<\(Thread.current.threadName)> Before thread start")
    imageDownloadQueue.async {
        print("imageDownloadQueue.async 0...5 Before Loop")
        for i in 0...5 {
            do {
                print("<\(Thread.current.threadName)> Starting to download image \(i)")
                if let url = URL(string: "https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg") {
                    let data = try Data(contentsOf: url)
                }
                print("<\(Thread.current.threadName)> Downloaded image \(i)")
            } catch {
                print("Exception in downloading image \(error)")
            }
        }
        iscompleted += 1
    }
    
    imageDownloadQueue.async {
        print("imageDownloadQueue.async 6...10 Before Loop")
        for i in 6...10 {
            do {
                print("<\(Thread.current.threadName)> Starting to download image \(i)")
                if let url = URL(string: "https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg") {
                    let data = try Data(contentsOf: url)
                }
                print("<\(Thread.current.threadName)> Downloaded image \(i)")
            } catch {
                print("Exception in downloading image \(error)")
            }
        }
        iscompleted += 1
    }
}

imageDownload()

//This will be called on main queue
imageDownloadQueue.sync {
    print("<\(Thread.current.threadName)> ImageDownloadQueue sync call")
    iscompleted += 1
}

imageDownloadQueue.async {
    print("<\(Thread.current.threadName)> ImageDownloadQueue async call")
    iscompleted += 1
}
print(String(repeating: "-", count: 20), "<\(Thread.current.threadName)> End of Experiment #1a", String(repeating: "-", count: 20))

//Expected output (Without Concurrent)
//-------------------- Experiment #1a --------------------
//<OperationQueue: NSOperationQueue Main Queue> Before thread start
//imageDownloadQueue.async 0...5 Before Loop
//<ImageDownloadQueue> Starting to download image 0
//<ImageDownloadQueue> Downloaded image 0
//<ImageDownloadQueue> Starting to download image 1
//<ImageDownloadQueue> Downloaded image 1
//<ImageDownloadQueue> Starting to download image 2
//<ImageDownloadQueue> Downloaded image 2
//<ImageDownloadQueue> Starting to download image 3
//<ImageDownloadQueue> Downloaded image 3
//<ImageDownloadQueue> Starting to download image 4
//<ImageDownloadQueue> Downloaded image 4
//<ImageDownloadQueue> Starting to download image 5
//<ImageDownloadQueue> Downloaded image 5
//imageDownloadQueue.async 6...10 Before Loop
//<ImageDownloadQueue> Starting to download image 6
//<ImageDownloadQueue> Downloaded image 6
//<ImageDownloadQueue> Starting to download image 7
//<ImageDownloadQueue> Downloaded image 7
//<ImageDownloadQueue> Starting to download image 8
//<ImageDownloadQueue> Downloaded image 8
//<ImageDownloadQueue> Starting to download image 9
//<ImageDownloadQueue> Downloaded image 9
//<ImageDownloadQueue> Starting to download image 10
//<ImageDownloadQueue> Downloaded image 10
//<OperationQueue: NSOperationQueue Main Queue> ImageDownloadQueue sync call
//-------------------- <OperationQueue: NSOperationQueue Main Queue> End of Experiment #1a --------------------
//<ImageDownloadQueue> ImageDownloadQueue async call


//Expected output: (With Concurrent)
//-------------------- Experiment #1a --------------------
//<OperationQueue: NSOperationQueue Main Queue> Before thread start
//imageDownloadQueue.async 0...5 Before Loop
//imageDownloadQueue.async 6...10 Before Loop
//<OperationQueue: NSOperationQueue Main Queue> ImageDownloadQueue sync call
//<ImageDownloadQueue> Starting to download image 0
//<ImageDownloadQueue> Starting to download image 6
//<ImageDownloadQueue> ImageDownloadQueue async call
//-------------------- <OperationQueue: NSOperationQueue Main Queue> End of Experiment #1a --------------------
//<ImageDownloadQueue> Downloaded image 6
//<ImageDownloadQueue> Starting to download image 7
//<ImageDownloadQueue> Downloaded image 0
//<ImageDownloadQueue> Starting to download image 1
//<ImageDownloadQueue> Downloaded image 7
//<ImageDownloadQueue> Starting to download image 8
//<ImageDownloadQueue> Downloaded image 1
//<ImageDownloadQueue> Starting to download image 2
//<ImageDownloadQueue> Downloaded image 8
//<ImageDownloadQueue> Starting to download image 9
//<ImageDownloadQueue> Downloaded image 9
//<ImageDownloadQueue> Starting to download image 10
//<ImageDownloadQueue> Downloaded image 2
//<ImageDownloadQueue> Starting to download image 3
//<ImageDownloadQueue> Downloaded image 10
//<ImageDownloadQueue> Downloaded image 3
//<ImageDownloadQueue> Starting to download image 4
//<ImageDownloadQueue> Downloaded image 4
//<ImageDownloadQueue> Starting to download image 5
//<ImageDownloadQueue> Downloaded image 5

//print(String(repeating: "-", count: 20), "Experiment #2", String(repeating: "-", count: 20))
//let serialQueue = DispatchQueue(label: "SerialQueue")
//let concurrentQueue = DispatchQueue(label: "ConcurrentQueue", attributes: [.concurrent, .initiallyInactive])
//concurrentQueue.setTarget(queue: serialQueue)
//concurrentQueue.activate()
//
//func setTarget_ImageDownload() {
//    for i in 0...5 {
//        print("<\(Thread.current.threadName)> Before thread start \(i)")
//        concurrentQueue.async {
//            do {
//                print("<\(Thread.current.threadName)> Starting to download image \(i)")
//                if let url = URL(string: "https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg") {
//                    let data = try Data(contentsOf: url)
//                }
//                print("<\(Thread.current.threadName)> Downloaded image \(i)")
//            } catch {
//                print("Exception in downloading image \(error)")
//            }
//        }
//    }
//}
//
//setTarget_ImageDownload()
//
//concurrentQueue.async {
//    print("<\(Thread.current.threadName)> ImageDownloadQueue async call")
//}
//
////This will be called on main queue.
//// Try with `serialQueue.async` and observe the difference in execution
//serialQueue.async {
//    print("<\(Thread.current.threadName)> ImageDownloadQueue sync call")
//}
//
//concurrentQueue.async {
//    print("<\(Thread.current.threadName)> ImageDownloadQueue async call #2")
//}
//print(String(repeating: "-", count: 20), "<\(Thread.current.threadName)> End of Experiment #2", String(repeating: "-", count: 20))
//print("<\(Thread.current.threadName)> End of playground")
//
////Expected Result #1 when we use `serialQueue.sync`
////-------------------- Experiment #2 --------------------
////<OperationQueue: NSOperationQueue Main Queue> Before thread start 0
////<OperationQueue: NSOperationQueue Main Queue> Before thread start 1
////<OperationQueue: NSOperationQueue Main Queue> Before thread start 2
////<OperationQueue: NSOperationQueue Main Queue> Before thread start 3
////<OperationQueue: NSOperationQueue Main Queue> Before thread start 4
////<OperationQueue: NSOperationQueue Main Queue> Before thread start 5
////<ConcurrentQueue> Starting to download image 0
////<ConcurrentQueue> Downloaded image 0
////<ConcurrentQueue> Starting to download image 1
////<ConcurrentQueue> Downloaded image 1
////<ConcurrentQueue> Starting to download image 2
////<ConcurrentQueue> Downloaded image 2
////<ConcurrentQueue> Starting to download image 3
////<ConcurrentQueue> Downloaded image 3
////<ConcurrentQueue> Starting to download image 4
////<ConcurrentQueue> Downloaded image 4
////<ConcurrentQueue> Starting to download image 5
////<ConcurrentQueue> Downloaded image 5
////<ConcurrentQueue> ImageDownloadQueue async call
////<OperationQueue: NSOperationQueue Main Queue> ImageDownloadQueue sync call
////<ConcurrentQueue> ImageDownloadQueue async call #2
////-------------------- <OperationQueue: NSOperationQueue Main Queue> End of Experiment #2 --------------------
////<OperationQueue: NSOperationQueue Main Queue> End of playground
//
///*
// Explaination:
// As the target queue is serial so event the concurrent queue will work serially only. The events downgrade their capability as per the target queue.
// - You cannot activate the thread before setting the target. So for a setTarget thread it should be initialised with ".initiallyInactive"
// - The sync thread will be called on parent thread only
// - Async of ConcurrentQueue will start immediatly as serialQueue sync is called because of FIFO
// */
//
//
////Expected Result #1 when we use `serialQueue.async`
////-------------------- Experiment #2 --------------------
////<OperationQueue: NSOperationQueue Main Queue> Before thread start 0
////<OperationQueue: NSOperationQueue Main Queue> Before thread start 1
////<OperationQueue: NSOperationQueue Main Queue> Before thread start 2
////<OperationQueue: NSOperationQueue Main Queue> Before thread start 3
////<OperationQueue: NSOperationQueue Main Queue> Before thread start 4
////<OperationQueue: NSOperationQueue Main Queue> Before thread start 5
////-------------------- <OperationQueue: NSOperationQueue Main Queue> End of Experiment #2 --------------------
////<ConcurrentQueue> Starting to download image 0
////<OperationQueue: NSOperationQueue Main Queue> End of playground
////<ConcurrentQueue> Downloaded image 0
////<ConcurrentQueue> Starting to download image 1
////<ConcurrentQueue> Downloaded image 1
////<ConcurrentQueue> Starting to download image 2
////<ConcurrentQueue> Downloaded image 2
////<ConcurrentQueue> Starting to download image 3
////<ConcurrentQueue> Downloaded image 3
////<ConcurrentQueue> Starting to download image 4
////<ConcurrentQueue> Downloaded image 4
////<ConcurrentQueue> Starting to download image 5
////<ConcurrentQueue> Downloaded image 5
////<ConcurrentQueue> ImageDownloadQueue async call
////<ConcurrentQueue> ImageDownloadQueue async call #2
////<SerialQueue> ImageDownloadQueue sync call
//
///*
// Explaination:
// As the target queue is serial so event the concurrent queue will work serially only. The events downgrade their capability as per the target queue.
// - You cannot activate the thread before setting the target. So for a setTarget thread it should be initialised with ".initiallyInactive"
// - As the serialQueue call is now async so it will not immediatly push the thread to execute and hence all the main thread prints are executed first and the only serial queue and concurrent queue will execute
// - SerialQueue will not execute on main thread as it is not sync anymore
// */
//
//
//print(String(repeating: "-", count: 20), "Experiment #3 - Barrier", String(repeating: "-", count: 20))
//var concurrent_barrier = DispatchQueue(label: "ConcurrentBarrier", attributes: [.concurrent])
//func withoutBarrier() {
//    concurrent_barrier.async {
//        for i in 0...3 {
//            print("Current value is \(i) 🥰")
//        }
//    }
//
//    concurrent_barrier.async {
//        for i in 4...6 {
//            print("Current value is \(i) 🤩")
//        }
//    }
//
//    concurrent_barrier.async {
//        for i in 7...10 {
//            print("Current value is \(i) 🥱")
//        }
//    }
//}
//
//func withBarrier() {
//    concurrent_barrier.async(flags: .barrier) {
//        for i in 0...3 {
//            print("Current value is \(i) 🥰")
//        }
//    }
//
//    concurrent_barrier.async(flags: .barrier) {
//        for i in 4...6 {
//            print("Current value is \(i) 🤩")
//        }
//    }
//
//    concurrent_barrier.async(flags: .barrier) {
//        for i in 7...10 {
//            print("Current value is \(i) 🥱")
//        }
//    }
//}
//
//
//withoutBarrier()
//Thread.sleep(forTimeInterval: 2)
//print(String(repeating: "-", count: 20), "Barrier", String(repeating: "-", count: 20))
//withBarrier()
//
////Expected Output
////-------------------- Experiment #3 - Barrier --------------------
////Current value is 0 🥰
////Current value is 4 🤩
////Current value is 1 🥰
////Current value is 5 🤩
////Current value is 2 🥰
////Current value is 7 🥱
////Current value is 3 🥰
////Current value is 6 🤩
////Current value is 8 🥱
////Current value is 9 🥱
////Current value is 10 🥱
////-------------------- Barrier --------------------
////Current value is 0 🥰
////Current value is 1 🥰
////Current value is 2 🥰
////Current value is 3 🥰
////Current value is 4 🤩
////Current value is 5 🤩
////Current value is 6 🤩
////Current value is 7 🥱
////Current value is 8 🥱
////Current value is 9 🥱
////Current value is 10 🥱
//
///*
// Without Barrier the sequence may change, but with Barrier it became almost synchronous
// */
