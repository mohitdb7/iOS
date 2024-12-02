//: [Previous](@previous)

import Foundation

enum Permission {
    case read
    case write
    case update
    case delete
}

class User {
    var permissions: [Permission]
    var name: String
    
    init(name: String, permissions: [Permission]) {
        self.name = name
        self.permissions = permissions
    }
}

class Operations {
    func read() {
        print("Reading from here")
    }
    func write() {
        print("Writing here")
    }
    func update() {
        print("Updating here")
    }
    func delete() {
        print("Deleting here")
    }
}

class Proxy {
    let operations: Operations = Operations()
    func read(user: User) {
        if user.permissions.contains(.read) {
            operations.read()
        } else {
            print("\(user.name) does not have read permission")
        }
    }
    func write(user: User) {
        print("Writing here")
    }
    func update(user: User) {
        print("Updating here")
    }
    func delete(user: User) {
        print("Deleting here")
    }
}

let user = User(name: "Mohit", permissions: [.write, .delete])
let proxy = Proxy()
proxy.read(user: user)
user.permissions.append(.read)
proxy.read(user: user)
//: [Next](@next)
