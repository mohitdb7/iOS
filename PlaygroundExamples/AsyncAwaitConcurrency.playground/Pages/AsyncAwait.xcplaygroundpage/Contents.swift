import UIKit

class DummyUserOperations {
    @available(*, deprecated, renamed: "getUserData()", message: "Use the async function")
    func getUserDetails(completion: @escaping (Result<String, Error>)->Void) {
        do {
            Thread.sleep(forTimeInterval: 3)
            completion(.success("User:Mohit Kumar Dubey,Age:31,Job:Software Engineer"))
        } catch {
            print("Error in getting user details \(error)")
            completion(.failure(error))
        }
    }
    
    @available(*, deprecated, renamed: "getCompanyDetails()", message: "Use the async function")
    func getCompanyDetails(completion: @escaping (Result<String, Error>)->Void) {
        do {
            Thread.sleep(forTimeInterval: 3)
            completion(.success("Company:Verse,Location:Bangalore,Category:Startup"))
        } catch {
            print("Error in getting company details \(error)")
            completion(.failure(error))
        }
    }
    
    func getUserData() async throws -> String {
        do {
            try await Task.sleep(for: .seconds(3))
            return "User:Mohit Kumar Dubey,Age:31,Job:Software Engineer"
        } catch {
            print("Error in getting user details \(error.localizedDescription)")
            throw error
        }
    }
    
    func getCompanyDetails() async throws -> String {
        do {
            try await Task.sleep(for: .seconds(3))
            return "Company:Verse,Location:Bangalore,Category:Startup"
        } catch {
            print("Error in getting company details \(error.localizedDescription)")
            throw error
        }
    }
}

let duo = DummyUserOperations()
func getDetails() {
    let startTime = Date()
    duo.getCompanyDetails { result in
        switch result {
        case.success(let companyValue):
            duo.getUserDetails { result in
                switch result {
                case.success(let userValue):
                    print("\(String(repeating: "-", count: 20)) Callback \(String(repeating: "-", count: 20))\nResult: \nCompany is \(companyValue)\nUser is \(userValue)")
                    let endTime = Date()
                    print("Time Taken \(endTime.timeIntervalSince(startTime))")
                case.failure(let error):
                    break
                }
            }
        case.failure(let error):
            break
        }
    }
}
//getDetails()

//Task {
//    do {
//        let startTime = Date()
//        let user = try await duo.getUserData()
//        let company = try await duo.getCompanyDetails()
//        print("\(String(repeating: "-", count: 20)) Async \(String(repeating: "-", count: 20))\nResult: \nCompany is \(company)\nUser is \(user)")
//        let endTime = Date()
//        print("Time Taken \(endTime.timeIntervalSince(startTime))")
//    } catch let error {
//        print("Error is \(error.localizedDescription)")
//    }
//}

//Task {
//    do {
//        let startTime = Date()
//        async let userAsync = duo.getUserData()
//        async let companyAsync = duo.getCompanyDetails()
//        
//        let (user, company) = try await (userAsync, companyAsync)
//        
//        print("\(String(repeating: "-", count: 20)) Async Let \(String(repeating: "-", count: 20))\nResult: \nCompany is \(company)\nUser is \(user)")
//        let endTime = Date()
//        print("Time Taken \(endTime.timeIntervalSince(startTime))")
//    } catch let error {
//        print("Error is \(error.localizedDescription)")
//    }
//}
