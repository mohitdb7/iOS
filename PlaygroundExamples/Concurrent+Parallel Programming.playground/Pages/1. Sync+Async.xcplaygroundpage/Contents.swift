//: [Previous](@previous)

import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

//Emoji -> Cmd + Ctrl + Space

let newQueue = DispatchQueue(label: "MyNewQueue")
var value = 0

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

print(String(repeating: "-", count: 20), "Experiment #1", String(repeating: "-", count: 20))


//This will run on MyNewQueue
newQueue.async {
    for i in 0...3 {
        value = i
        
        print("Inside first <\(Thread.current.threadName)> \(value) 😜")
    }
}

print("I am here on main thread - after first async")

newQueue.async {
    for i in 4...6 {
        value = i
        
        print("Inside second <\(Thread.current.threadName)> \(value) 😜")
    }
}

print("I am here on main thread - after second async")

//This will execute on main thread as it is happening synchronously on main thread
newQueue.sync {
    for i in 7...9 {
        value = i
        
        print("Inside third <\(Thread.current.threadName)> \(value) 😍")
    }
}

print("I am here on main thread - after third sync")

//This will run on MyNewQueue
newQueue.async {
    value = 10
    print("Inside forth <\(Thread.current.threadName)> \(value) 🤣")
}

print("I am here on main thread - after forth async")

DispatchQueue.main.async {
    print("Async Dispatch main <\(Thread.current.threadName)>")
}

//Explaination
/*
 - As there is no heavy operation on main, the async MyNewQueue execution will not start until we call sync MyNewQueue. As sync MyNewQueue will force the async also to start because threads in iOS are always FIFO and the async operations were lined before sync. Again after the sync operation is completed, the async will again called after main thread as no heavy operations on main. The Async main operation will be called after the async MyNewQueue operation.
 - When you run sync on another dispatch Queue, it will run on the current queue
 - Main is an operation Queue
 - If you call `DispatchQueue.Main.Sync` on main then it will result in deadlock
 */

//Expected output (Most common):
//-------------------- Experiment #1 --------------------
//I am here on main thread - after first async
//I am here on main thread - after second async
//Inside first <MyNewQueue> 0 😜
//Inside first <MyNewQueue> 1 😜
//Inside first <MyNewQueue> 2 😜
//Inside first <MyNewQueue> 3 😜
//Inside second <MyNewQueue> 4 😜
//Inside second <MyNewQueue> 5 😜
//Inside second <MyNewQueue> 6 😜
//Inside third <OperationQueue: NSOperationQueue Main Queue> 7 😍
//Inside third <OperationQueue: NSOperationQueue Main Queue> 8 😍
//Inside third <OperationQueue: NSOperationQueue Main Queue> 9 😍
//I am here on main thread - after third sync
//I am here on main thread - after forth async
//Inside forth <MyNewQueue> 10 🤣
//Async Dispatch main <OperationQueue: NSOperationQueue Main Queue>
