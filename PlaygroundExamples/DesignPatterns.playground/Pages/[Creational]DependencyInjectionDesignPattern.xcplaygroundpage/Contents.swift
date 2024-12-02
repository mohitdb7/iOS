//: [Previous](@previous)

import Foundation

    //MARK: - Dependency Injection design pattern
    ///In this pattern all required resources are injected to the class via initialiser.
    ///Best practice is to have dependencies as protocols so that it can mocked for testing
    ///This provides a loose coupling and the class not tightly coupled with any class
protocol DependencyUtility {
    func processSomething()
}
class DependencyUtilityActual: DependencyUtility {
    func processSomething() {
    }
}

    ///Partial dependency - When the class does not hold the reference of dependency, but get it through function
    ///and then it gets deallocated as soon as the work is done
    ///Like here "DependencyService" is accepting "DependencyUtility" through function but does not hold reference of that.
protocol DependencyService {
    func processUtilty(utility: DependencyUtility)
}
class DependencyServiceActual: DependencyService {
    func processUtilty(utility: DependencyUtility) {
        utility.processSomething()
    }
}

    ///Direct Dependency - when the class holds the reference of the dependency. Like here "DependencyManager"
    ///is holding "service"
class DependencyManager {
    let service: DependencyService
    
    init(service: DependencyService) {
        self.service = service
    }
    
    func process(utility: DependencyUtility) {
        service.processUtilty(utility: utility)
    }
}

let dependencyManager: DependencyManager = DependencyManager(service: DependencyServiceActual())
dependencyManager.process(utility: DependencyUtilityActual())

