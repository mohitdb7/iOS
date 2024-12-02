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

func serialOperations() {
    let startTime = Date.now
    var group = DispatchGroup()
    
    var count = 0 {
        didSet {
            if count >= 51 {
                let timeDiff = Date.now.timeIntervalSince(startTime)
                print("concurrentOperations took \(timeDiff) to complete image downloads")
            }
        }
    }
    
    let imageDownloadQueue = DispatchQueue(label: "ImageDownloadQueue", qos: .utility)
    for i in 0...50 {
        group.enter()
        imageDownloadQueue.async {
            do {
                if let url = URL(string: "https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=\(Date.now.timeIntervalSince1970)") {
                    let data = try Data(contentsOf: url)
                    if count < 10 {
                        print("\(String(format: "%p", Thread.current)) Downloaded image \(i) on Thread \(Thread.current.threadName) -> url \(url)")
                    }
                }
            } catch {
                print("Exception is \(error.localizedDescription)")
            }
            
            count += 1
            group.leave()
        }
    }
    
    group.notify(queue: DispatchQueue.main) {
        let timeDiff = Date.now.timeIntervalSince(startTime)
        print("[notify] concurrentOperations took \(timeDiff) to complete image downloads")
    }
}
//0x600001710940 Downloaded image 0 on Thread ImageDownloadQueue -> url https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=1717045807.015049
//0x600001710940 Downloaded image 1 on Thread ImageDownloadQueue -> url https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=1717045811.697754
//0x600001710940 Downloaded image 2 on Thread ImageDownloadQueue -> url https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=1717045816.270813
//0x600001710940 Downloaded image 3 on Thread ImageDownloadQueue -> url https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=1717045820.6546311
//0x600001710940 Downloaded image 4 on Thread ImageDownloadQueue -> url https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=1717045825.1198602
//0x600001710940 Downloaded image 5 on Thread ImageDownloadQueue -> url https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=1717045828.604558
//0x600001710940 Downloaded image 6 on Thread ImageDownloadQueue -> url https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=1717045833.28285
//0x600001710940 Downloaded image 7 on Thread ImageDownloadQueue -> url https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=1717045838.0027661
//0x600001710940 Downloaded image 8 on Thread ImageDownloadQueue -> url https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=1717045841.573038
//0x600001710940 Downloaded image 9 on Thread ImageDownloadQueue -> url https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=1717045846.1527019
//concurrentOperations took 217.69511997699738 to complete image downloads
//[notify] concurrentOperations took 217.69521594047546 to complete image downloads

func concurrentOperations() {
    let startTime = Date.now
    var group = DispatchGroup()
    
    var count = 0 {
        didSet {
            if count >= 51 {
                let timeDiff = Date.now.timeIntervalSince(startTime)
                print("concurrentOperations took \(timeDiff) to complete image downloads")
            }
        }
    }
    
    let imageDownloadQueue = DispatchQueue(label: "ImageDownloadQueue", qos: .utility, attributes: [.concurrent])
    for i in 0...50 {
        group.enter()
        imageDownloadQueue.async {
            do {
                if let url = URL(string: "https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=\(Date.now.timeIntervalSince1970)") {
                    let data = try Data(contentsOf: url)
                    if count < 10 {
                        print("\(String(format: "%p", Thread.current)) Downloaded image \(i) on Thread \(Thread.current.threadName) -> url \(url)")
                    }
                }
            } catch {
                print("Exception is \(error.localizedDescription)")
            }
            count += 1
            group.leave()
        }
    }
    
    group.notify(queue: DispatchQueue.main) {
        let timeDiff = Date.now.timeIntervalSince(startTime)
        print("[notify] concurrentOperations took \(timeDiff) to complete image downloads")
    }
}
//0x6000017255c0 Downloaded image 44 on Thread ImageDownloadQueue -> url https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=1717046254.029307
//0x6000017229c0 Downloaded image 8 on Thread ImageDownloadQueue -> url https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=1717046254.012363
//0x600001734100 Downloaded image 45 on Thread ImageDownloadQueue -> url https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=1717046254.0301929
//0x600001722440 Downloaded image 47 on Thread ImageDownloadQueue -> url https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=1717046254.030264
//0x600001700140 Downloaded image 18 on Thread ImageDownloadQueue -> url https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=1717046254.0133119
//0x600001723740 Downloaded image 24 on Thread ImageDownloadQueue -> url https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=1717046254.0205688
//0x600001723380 Downloaded image 26 on Thread ImageDownloadQueue -> url https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=1717046254.020804
//0x60000171db40 Downloaded image 25 on Thread ImageDownloadQueue -> url https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=1717046254.020715
//0x600001723b80 Downloaded image 34 on Thread ImageDownloadQueue -> url https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=1717046254.0214992
//0x6000017234c0 Downloaded image 3 on Thread ImageDownloadQueue -> url https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=1717046254.0119162
//concurrentOperations took 28.042147994041443 to complete image downloads
//[notify] concurrentOperations took 28.042453050613403 to complete image downloads


func parallelOperations() {
    let startTime = Date.now
    var count = 0 {
        didSet {
            if count >= 51 {
                let timeDiff = Date.now.timeIntervalSince(startTime)
                print("concurrentOperations took \(timeDiff) to complete image downloads")
            }
        }
    }
    
    DispatchQueue.global().async {
        DispatchQueue.concurrentPerform(iterations: 51) { index in
            do {
                if let url = URL(string: "https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=\(Date.now.timeIntervalSince1970)") {
                    let data = try Data(contentsOf: url)
                    
                    if count < 10 {
                        print("\(String(format: "%p", Thread.current)) Downloaded image \(index) on Thread \(Thread.current.threadName) -> url \(url)")
                    }
                }
            } catch {
                print("Exception is \(error.localizedDescription)")
            }
            count += 1
        }
    }
}
//0x600001724cc0 Downloaded image 7 on Thread com.apple.root.user-initiated-qos -> url https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=1717046394.926115
//0x600001708f80 Downloaded image 4 on Thread com.apple.root.user-initiated-qos -> url https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=1717046394.925819
//0x60000172c8c0 Downloaded image 9 on Thread com.apple.root.user-initiated-qos -> url https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=1717046394.926217
//0x600001700ec0 Downloaded image 2 on Thread com.apple.root.user-initiated-qos -> url https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=1717046394.925819
//0x60000170fec0 Downloaded image 10 on Thread com.apple.root.user-initiated-qos -> url https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=1717046394.926244
//0x600001725e40 Downloaded image 5 on Thread com.apple.root.user-initiated-qos -> url https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=1717046394.926074
//0x600001716b00 Downloaded image 6 on Thread com.apple.root.user-initiated-qos -> url https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=1717046394.926097
//0x6000017211c0 Downloaded image 3 on Thread com.apple.root.user-initiated-qos -> url https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=1717046394.925825
//0x60000172c200 Downloaded image 8 on Thread com.apple.root.user-initiated-qos -> url https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=1717046394.926162
//0x6000017164c0 Downloaded image 0 on Thread com.apple.root.user-initiated-qos -> url https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=1717046394.925822
//concurrentOperations took 31.73502504825592 to complete image downloads

func parallelAwaitOperations() async {
    var group = DispatchGroup()
    var startTime = Date.now

    await withTaskGroup(of: Void.self) { group in
        startTime = Date.now
        
        for i in 0...50 {
            group.addTask {
                do {
                    if let url = URL(string: "https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=\(Date.now.timeIntervalSince1970)") {
                        let data = try Data(contentsOf: url)
                        if i < 10 {
                            print("\(String(format: "%p", Thread.current)) Downloaded image \(i) on Thread \(Thread.current.threadName) \(#function) -> url \(url)")
                        }
                    }
                } catch {
                    print("Exception is \(error.localizedDescription)")
                }
            }
        }
        
        await group.waitForAll()
    }
    
    let timeDiff = Date.now.timeIntervalSince(startTime)
    print("[notify] parallelAwaitOperations took \(timeDiff) to complete image downloads")
    
}
//0x6000017040c0 Downloaded image 3 on Thread com.apple.root.user-initiated-qos.cooperative parallelAwaitOperations() -> url https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=1717046795.611553
//0x600001725280 Downloaded image 5 on Thread com.apple.root.user-initiated-qos.cooperative parallelAwaitOperations() -> url https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=1717046795.611671
//0x600001708e00 Downloaded image 0 on Thread com.apple.root.user-initiated-qos.cooperative parallelAwaitOperations() -> url https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=1717046795.60834
//0x600001718bc0 Downloaded image 1 on Thread com.apple.root.user-initiated-qos.cooperative parallelAwaitOperations() -> url https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=1717046795.611459
//0x600001725d80 Downloaded image 2 on Thread com.apple.root.user-initiated-qos.cooperative parallelAwaitOperations() -> url https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=1717046795.6115131
//0x600001725b40 Downloaded image 8 on Thread com.apple.root.user-initiated-qos.cooperative parallelAwaitOperations() -> url https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=1717046795.619343
//0x600001725a00 Downloaded image 7 on Thread com.apple.root.user-initiated-qos.cooperative parallelAwaitOperations() -> url https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=1717046795.619159
//0x600001724cc0 Downloaded image 9 on Thread com.apple.root.user-initiated-qos.cooperative parallelAwaitOperations() -> url https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=1717046795.619452
//0x60000171dd80 Downloaded image 4 on Thread com.apple.root.user-initiated-qos.cooperative parallelAwaitOperations() -> url https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=1717046795.611604
//0x60000172c580 Downloaded image 6 on Thread com.apple.root.user-initiated-qos.cooperative parallelAwaitOperations() -> url https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?t=1717046795.611724
//[notify] parallelAwaitOperations took 27.78715205192566 to complete image downloads

//Task {
//    await parallelAwaitOperations()
//}

//serialOperations()

//parallelOperations()

//concurrentOperations()
