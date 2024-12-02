//
//  CacheType.swift
//  StorageSolutions
//
//  Created by Mohit Dubey on 03/10/24.
//

enum CacheType {
    case leastRecentlyUsed
    case firstInFirstOut
    case leastFrequentlyUsed
}

//enum CacheExpiry {
//    case day(Int)
//    case hour(Int)
//    case mins(Int)
//    case seconds(Int)
//}

enum CacheLocation {
    case memory
    case disk
}

struct CacheConfig {
    let sizeMB: Int
    let ttl: Int
    let cacheType: CacheType
    let cacheLocation: CacheLocation
}
