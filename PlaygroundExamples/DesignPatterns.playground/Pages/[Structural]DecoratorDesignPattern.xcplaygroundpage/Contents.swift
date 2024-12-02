//: [Previous](@previous)

import Foundation

protocol NotificationSystem {
    func notify()
    func subscribe()
    func unsusbscribe()
}

class BasicNotification: NotificationSystem {
    func notify() {
        print("Basic notification")
    }
    func subscribe() {
        print("Subscribe to basic")
    }
    func unsusbscribe() {
        print("Unsubscribe to basic")
    }
}

class NotoficationDecorator: NotificationSystem {
    var component: NotificationSystem
    
    init(component: NotificationSystem) {
        self.component = component
    }
    
    func notify() {
        component.notify()
    }
    func subscribe() {
        component.subscribe()
    }
    func unsusbscribe() {
        component.unsusbscribe()
    }
}

class FacebookNotificationDecorator: NotoficationDecorator {
    override init(component: NotificationSystem) {
        print("Facebook component called - \(component)")
        super.init(component: component)
    }
    
    override func notify() {
        super.notify()
        
        print("Facebook notification")
    }
    
    override func subscribe() {
        super.subscribe()
        
        print("Subscribe to facebook")
    }
    
    override func unsusbscribe() {
        super.unsusbscribe()
        
        print("Unsubscribe to facebook")
    }
}

class SlackNotificationDecorator: NotoficationDecorator {
    override init(component: NotificationSystem) {
        print("Slack component called - \(component)")
        super.init(component: component)
    }
    
    override func notify() {
        super.notify()
        
        print("Slack notification")
    }
    
    override func subscribe() {
        super.subscribe()
        
        print("Subscribe to Slack")
    }
    
    override func unsusbscribe() {
        super.unsusbscribe()
        
        print("Unsubscribe to Slack")
    }
}

let component = BasicNotification()

let facebookBasic = FacebookNotificationDecorator(component: component)
let slackBasic = SlackNotificationDecorator(component: component)
let facebookSlackBasic = FacebookNotificationDecorator(component: slackBasic)


print("----------------------")
print("----------------------")

facebookBasic.notify()
print("----------------------")
slackBasic.notify()
print("----------------------")
facebookSlackBasic.notify()
print("----------------------")
//: [Next](@next)
