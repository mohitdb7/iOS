//: [Previous](@previous)

import Foundation

class DummyGroupOperation {
    private func getUserData() async throws -> String {
        do {
            try await Task.sleep(for: .seconds(3))
            print("User Details finished")
            return "User:Mohit Kumar Dubey,Age:31,Job:Software Engineer"
        } catch {
            print("Error in getting user details \(error.localizedDescription)")
            throw error
        }
    }
    
    private func getCompanyDetails() async throws -> String {
        do {
            try await Task.sleep(for: .seconds(3))
            print("Company Details finished")
            return "Company:Verse,Location:Bangalore,Category:Startup"
        } catch {
            print("Error in getting company details \(error.localizedDescription)")
            throw error
        }
    }
    
    private func getOtherDetails() async throws -> String {
        do {
            try await Task.sleep(for: .seconds(3))
            print("Other Details finished")
            return "Married:Yes,HasKids:Yes"
        } catch {
            print("Error in getting user details \(error.localizedDescription)")
            throw error
        }
    }
    
    func getDetailsWithIteration() async throws -> (user: String, company: String, other: String) {
        do {
            let groupTaskResult: (String, String, String) = try await withThrowingTaskGroup(of: (String, String, String).self, returning: (String, String, String).self) { groupTask in
                groupTask.addTask {[weak self] in
                    do {
                        return (user: "", company: "", other: (try await self?.getOtherDetails()) ?? "")
                    } catch {
                        throw error
                    }
                }
                
                groupTask.addTask {[weak self] in
                    do {
                        return (user: "", company: (try await self?.getCompanyDetails()) ?? "", other: "")
                    } catch {
                        throw error
                    }
                }
                
                groupTask.addTask {[weak self] in
                    do {
                        return (user: (try await self?.getUserData()) ?? "", company: "", other: "")
                    } catch {
                        throw error
                    }
                }
                do {
                    var user = "", company = "", other = ""
                    for try await item in groupTask {
                        let (user_i, company_i, other_i) = item
                        
                        if !user_i.isEmpty {
                            user = user_i
                        }
                        if !company_i.isEmpty {
                            company = company_i
                        }
                        if !other_i.isEmpty {
                            other = other_i
                        }
                    }
                    
                    return (user, company, other)
                } catch let error {
                    throw error
                }
            }
            
            return groupTaskResult
        } catch let error {
            throw error
        }
    }
    
    func getDetailsUsingWait() async throws {
        try await withThrowingTaskGroup(of: Void.self) { groupTask in
            groupTask.addTask {[weak self] in
                do {
                    try await Task.sleep(for: .seconds(1))
                    if !Task.isCancelled {
                        try Task.checkCancellation()
                        try await self?.getOtherDetails()
                    }
                } catch {
                    throw error
                }
            }
            
            groupTask.addTask {[weak self] in
                do {
                    try await Task.sleep(for: .seconds(1))
                    if !Task.isCancelled {
                        try Task.checkCancellation()
                        try await self?.getCompanyDetails()
                    }
                } catch {
                    throw error
                }
            }
            
            groupTask.addTask {[weak self] in
                do {
                    try await Task.sleep(for: .seconds(2))
                    
                    if !Task.isCancelled {
                        try Task.checkCancellation()
                        try await self?.getUserData()
                    }
                } catch {
                    throw error
                }
            }
            
            
            do {
                try await Task.sleep(for: .milliseconds(1500))
                groupTask.cancelAll()
                
                try await groupTask.waitForAll()
                print("All tasks finished")
            } catch let error {
                print(type(of: error))
                print("Error is \(error.localizedDescription)")
            }
        }
    }
}

let dgo = DummyGroupOperation()
//Task {
//    let startTime = Date()
//    let (user, company, other) = try await dgo.getDetailsWithIteration()
//    print("\(String(repeating: "-", count: 20)) Async Group \(String(repeating: "-", count: 20))\nResult: \nCompany is \(company)\nUser is \(user)\nOther is \(other)")
//    let endTime = Date().timeIntervalSince(startTime)
//    print("Time taken to complete all tasks \(endTime)")
//}

Task {
    let startTime = Date()
    
    try await dgo.getDetailsUsingWait()
    
    let endTime = Date().timeIntervalSince(startTime)
    print("Time taken to complete all tasks \(endTime)")
}
