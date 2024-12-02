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
let imageDownloadQueue = DispatchQueue(label: "ImageDownloadQueue", qos: .utility,  attributes: [.concurrent])

//print(String(repeating: "-", count: 20), "Experiment #1", String(repeating: "-", count: 20))
//let lock = NSLock()
//var _dispatchWorkItems: [DispatchWorkItem?] = []
//var dispatchWorkItems: [DispatchWorkItem?] {
//    get {
//        lock.lock()
//        defer {
//            lock.unlock()
//        }
//        
//        return _dispatchWorkItems
//    }
//    set {
//        lock.lock()
//        defer {
//            lock.unlock()
//        }
//        
//        _dispatchWorkItems = newValue
//    }
//}
//
//func downloadImages() {
//    let group = DispatchGroup()
//    for i in 0...10 {
//        group.enter()
//        var workItem: DispatchWorkItem?
//        
//        workItem = DispatchWorkItem {
//            if workItem == nil || workItem!.isCancelled {
//                print("Task is cancelled so returning back \(i)")
//                return
//            }
//            
//            do {
//                print("<\(Thread.current.threadName)> Starting to download image \(i)")
//                if let url = URL(string: "https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg") {
//                    let data = try Data(contentsOf: url)
//                }
//                
//                if workItem == nil || workItem!.isCancelled {
//                    print("Task is cancelled so returning back \(i)")
//                    return
//                }
//                
//                print("<\(Thread.current.threadName)> Downloaded image \(i)")
//                group.leave()
//            } catch {
//                print("Exception in downloading image \(error)")
//                group.leave()
//            }
//            
//            workItem = nil
//        }
//        
//        dispatchWorkItems.append(workItem)
//        imageDownloadQueue.async {
//            workItem?.perform()
//        }
//    }
//    
//    let result = group.wait(wallTimeout: .now() + 0.75)
//    DispatchQueue.main.async {
//        switch result {
//        case .success:
//            print("All tasks finished")
//        case .timedOut:
//            print("Task cancel called")
//            dispatchWorkItems.map({
//                if $0 != nil {
//                    $0?.cancel()
//                }
//            })
//        }
//    }
//}
//
//print("Starting the experiment")
//downloadImages()
//print("Ending the experiment")


//Expected Output:
//Starting the experiment
//<ImageDownloadQueue> Starting to download image 2
//<ImageDownloadQueue> Starting to download image 0
//<ImageDownloadQueue> Starting to download image 1
//<ImageDownloadQueue> Starting to download image 3
//<ImageDownloadQueue> Starting to download image 4
//<ImageDownloadQueue> Starting to download image 5
//<ImageDownloadQueue> Starting to download image 6
//<ImageDownloadQueue> Starting to download image 7
//<ImageDownloadQueue> Starting to download image 8
//<ImageDownloadQueue> Starting to download image 9
//<ImageDownloadQueue> Starting to download image 10
//<ImageDownloadQueue> Downloaded image 4
//<ImageDownloadQueue> Downloaded image 8
//Ending the experiment
//Task cancel called
//Task is cancelled so returning back 0
//Task is cancelled so returning back 9
//Task is cancelled so returning back 1
//Task is cancelled so returning back 3
//Task is cancelled so returning back 5
//Task is cancelled so returning back 6
//Task is cancelled so returning back 7
//Task is cancelled so returning back 2
//Task is cancelled so returning back 10

/*
 Explaination:
 - The task will start only after we call task.perform()
 - The task can be checked if cancelled and the operation can be returned accordingly as per the task validity
 */


print(String(repeating: "-", count: 20), "Experiment #2", String(repeating: "-", count: 20))
var task: DispatchWorkItem?

func downloadImage_task() {
    task = DispatchWorkItem {
        for i in 0...10 {
            if task == nil || task?.isCancelled == true {
                print("Task is cancelled, so returning back from the task")
                return
            }
            
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
        
        task = nil
        print("All tasks finished")
    }
    
    task?.perform()
}

imageDownloadQueue.async {
    downloadImage_task()
}

imageDownloadQueue.asyncAfter(deadline: .now() + 0.75) {
    task?.cancel()
    print("All tasks cancelled")
}


//Expected output
//-------------------- Experiment #2 --------------------
//<ImageDownloadQueue> Starting to download image 0
//<ImageDownloadQueue> Downloaded image 0
//<ImageDownloadQueue> Starting to download image 1
//<ImageDownloadQueue> Downloaded image 1
//<ImageDownloadQueue> Starting to download image 2
//<ImageDownloadQueue> Downloaded image 2
//<ImageDownloadQueue> Starting to download image 3
//All tasks cancelled
//<ImageDownloadQueue> Downloaded image 3
//Task is cancelled, so returning back from the task
