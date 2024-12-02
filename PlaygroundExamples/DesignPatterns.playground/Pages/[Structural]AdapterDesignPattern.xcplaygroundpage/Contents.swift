//: [Previous](@previous)

import Foundation
//MARK: - Adapter design pattern
///This pattern is used to convert one class to another which has no connection with each other.
///The adapter will keep an object of source class and derive from the destination class. Now with the help of adapter,
///we can create a distantionObject that will do the source functionalities
class BasicPhone {
    func call() {
        print("BasicPhone call")
    }
    func sms() {
        print("BasicPhone sms")
    }
}

class SmartPhone {
    func call() {
        print("SmartPhone call")
    }
    func sms() {
        print("SmartPhone sms")
    }
    func internet() {
        print("SmartPhone internet")
    }
}

class BasicPhoneAdapter: SmartPhone {
    let basicPhone: BasicPhone
    
    init(_ phone: BasicPhone) {
        self.basicPhone = phone
    }
    
    override func call() {
        basicPhone.call()
    }
    
    override func sms() {
        basicPhone.sms()
    }
    
    override func internet() {
        print("SmartPhone internet not supported")
    }
}

let basicPhone = BasicPhone()
let smartPhone: SmartPhone = BasicPhoneAdapter(basicPhone)
smartPhone.call()
smartPhone.sms()
smartPhone.internet()

//: [Next](@next)
