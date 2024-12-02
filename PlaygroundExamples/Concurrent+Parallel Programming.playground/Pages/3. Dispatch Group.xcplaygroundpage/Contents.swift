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
//func downloadImage() {
//    print("Called downloadImage function")
//    var group = DispatchGroup()
//    for i in 0...5 {
//        imageDownloadQueue.async {
//            group.enter()
//            do {
//                print("<\(Thread.current.threadName)> Starting to download image \(i)")
//                if let url = URL(string: "https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg") {
//                    let data = try Data(contentsOf: url)
//                }
//                print("<\(Thread.current.threadName)> Downloaded image \(i)")
//                group.leave()
//            } catch {
//                print("Exception in downloading image \(error)")
//                group.leave()
//            }
//        }
//    }
//    
//    group.notify(queue: .main, execute: allDownlodCompleted)
//    
//    print("End of downloadImage function")
//}
//
//
//func allDownlodCompleted() {
//    print(String(repeating: "-", count: 20), "End of all the downloads", String(repeating: "-", count: 20))
//}
//
//print("Playground execution started")
//downloadImage()
//print("Playground execution Completed")

//-------------------- Experiment #1 --------------------
//Playground execution started
//Called downloadImage function
//End of downloadImage function
//Playground execution Completed
//<ImageDownloadQueue> Starting to download image 3
//<ImageDownloadQueue> Starting to download image 1
//<ImageDownloadQueue> Starting to download image 0
//<ImageDownloadQueue> Starting to download image 2
//<ImageDownloadQueue> Starting to download image 4
//<ImageDownloadQueue> Starting to download image 5
//<ImageDownloadQueue> Downloaded image 3
//<ImageDownloadQueue> Downloaded image 0
//<ImageDownloadQueue> Downloaded image 5
//<ImageDownloadQueue> Downloaded image 2
//<ImageDownloadQueue> Downloaded image 1
//<ImageDownloadQueue> Downloaded image 4
//-------------------- End of all the downloads --------------------

/*
 The group will notify when all tasks attached to it will comeplete. In this example, we will send the notify when all image download tasks will complete
 */

print(String(repeating: "-", count: 20), "Experiment #2", String(repeating: "-", count: 20))
func downloadImage_wait() {
    print("Called downloadImage function")
    var group = DispatchGroup()
    for i in 0...5 {
        imageDownloadQueue.async {
            group.enter()
            do {
                print("<\(Thread.current.threadName)> Starting to download image \(i)")
                if let url = URL(string: "https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg") {
                    let data = try Data(contentsOf: url)
                }
                print("<\(Thread.current.threadName)> Downloaded image \(i)")
                group.leave()
            } catch {
                print("Exception in downloading image \(error)")
                group.leave()
            }
        }
    }
    
    print("End of downloadImage function")
    let result = group.wait(wallTimeout: .now() + 0.75)
    
    DispatchQueue.main.async {
        switch result {
        case .success:
            allDownlodCompleted_wait()
        case .timedOut:
            allDownlodTimeout_wait()
        }
        
    }
}


func allDownlodCompleted_wait() {
    print(String(repeating: "-", count: 20), "End of all the downloads", String(repeating: "-", count: 20))
}

func allDownlodTimeout_wait() {
    print(String(repeating: "-", count: 20), "Downloads timeout", String(repeating: "-", count: 20))
}

print("Playground execution started")
downloadImage_wait()
print("Playground execution Completed")


//-------------------- Experiment #2 --------------------
//Playground execution started
//Called downloadImage function
//End of downloadImage function
//<ImageDownloadQueue> Starting to download image 2
//<ImageDownloadQueue> Starting to download image 3
//<ImageDownloadQueue> Starting to download image 4
//<ImageDownloadQueue> Starting to download image 0
//<ImageDownloadQueue> Starting to download image 5
//<ImageDownloadQueue> Starting to download image 1
//<ImageDownloadQueue> Downloaded image 3
//<ImageDownloadQueue> Downloaded image 5
//<ImageDownloadQueue> Downloaded image 2
//Playground execution Completed
//-------------------- Downloads timeout --------------------
//<ImageDownloadQueue> Downloaded image 4
//<ImageDownloadQueue> Downloaded image 0
//<ImageDownloadQueue> Downloaded image 1

/*
 This will wait until the wait timestamp, and then will notify regardless of all tasks are completed or not. In DispatchGroup, the tasks are not cancelled after timeout exceeds. It will just notify.
 
 - DispatchTime is basically the time according to device clock and if the device goes to sleep, the clock sleeps too. A perfect couple.
 - DispatchWallTime is the time according to wall clock, who doesn’t sleep at all, A Night Watch.
 */
