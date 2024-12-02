    //: [Previous](@previous)

import Foundation
import UIKit

    //MARK: - Prototype Design Pattern
    ///creates an object from an existing object. But both should have different memory address
    ///It has two types
    ///1. Shallow copy
    ///2. Deep copy
    ///This methodology is used when object creation is a costly process
    ///This also abstarts the object creation logic
class PrototypeUser: NSCopying {
    var name: String
    var age: Double
    
    init(name: String, age: Double) {
        self.name = name
        self.age = age
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        return PrototypeUser(name: "Dummy Name", age: 0)
    }
}

    //Here Object 2 is pointing to the reference of Obj1, so any change in Obj2 will reflect in obj1 and vice versa
let obj1: PrototypeUser = PrototypeUser(name: "Mohit Dubey", age: 34)
let obj2: PrototypeUser = obj1

    //Here Obj3 is pointing to a new memory copy of obj1. So changes done in Obj2, Obj1 will not reflect in Obj3 and vice versa
let obj3: PrototypeUser = obj1.copy() as! PrototypeUser

obj2.age = 33
print("Obj1: Name-\(obj1.name), Age-\(obj1.age)")
print("Obj2: Name-\(obj2.name), Age-\(obj2.age)")
print("Obj3: Name-\(obj3.name), Age-\(obj3.age)")


    //MARK: Shallow copy
    //Shallow Copying: In this method copy of parent is send to the caller but any reference property is not copied again and the existing reference is send
class PrototypeStudent: NSCopying {
    var name: String
    var score: Double
    var standard: PrototypeStandard
    
    init(name: String, score: Double, standard: PrototypeStandard) {
        self.name = name
        self.score = score
        self.standard = standard
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
            //New copy of Student is provided but standard is not created again
        return PrototypeStudent(name: "Dummy student", score: 0.0, standard: standard)
    }
}

    //MARK: Deep copy
    //Deep copy: In this method copy of parent is send to the caller and also any reference property is copied again and the new reference is send
class PrototypeStudent2: NSCopying {
    var name: String
    var score: Double
    var standard: PrototypeStandard
    
    init(name: String, score: Double, standard: PrototypeStandard) {
        self.name = name
        self.score = score
        self.standard = standard
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
            //New copy of Student is provided but standard is not created again
        return PrototypeStudent2(name: "Dummy student", score: 0.0, standard: standard.copy() as! PrototypeStandard)
    }
}

class PrototypeStandard: NSCopying {
    var classTeacher: String
    var standard: Int
    
    init(classTeacher: String, standard: Int) {
        self.classTeacher = classTeacher
        self.standard = standard
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        return PrototypeStandard(classTeacher: "Dummy teacher", standard: 0)
    }
}
