//: [Previous](@previous)

import Foundation

class DummyAsyncStreamOperation {
    private func getImage(name: String) async -> String {
        try? await Task.sleep(for: .milliseconds(Int.random(in: 300...1000)))
        return name
    }
    
    func getImages() -> AsyncStream<String> {
        return AsyncStream { continuation in
            let task = Task {
                await withTaskGroup(of: String.self) { taskGroup in
                    for i in 1...50 {
                        if !taskGroup.isCancelled {
                            taskGroup.addTask {[weak self] in
                                await self?.getImage(name: "image\(i).jpg") ?? ""
                            }
                        }
                    }
                    
                    for await item in taskGroup {
                        continuation.yield(item)
                        
//                        if item == "image6.jpg" {
//                            continuation.finish()
//                        }
                    }
                    
                    continuation.finish()
                }
            }
            
            continuation.onTermination = { _ in
                print("Task is cancelled")
                task.cancel()
            }
        }
    }
}

let daso = DummyAsyncStreamOperation()
Task {
    let stream = daso.getImages()
    for await image in stream {
        print("Image is \(image)")
    }
}
