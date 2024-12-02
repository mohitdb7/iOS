//
//  CacheOperations.swift
//  StorageSolutions
//
//  Created by Mohit Dubey on 04/10/24.
//
import Foundation

protocol CacheReorder {
    func bringToFront(key: String, cached: [String]) -> [String]
}

class CacheReorderFirstInFirstOut: CacheReorder {
    func bringToFront(key: String, cached: [String]) -> [String] {
        return []
    }
}

class CacheReorderLeastFrequentlyUsed: CacheReorder {
    func bringToFront(key: String, cached: [String]) -> [String] {
        return []
    }
}

class CacheReorderLeastRecentlyUsed: CacheReorder {
    func bringToFront(key: String, cached: [String]) -> [String] {
        return []
    }
}

class CacheOperations {
    private let _config: CacheConfig
    private let _cachePriority: CacheReorder
    
    private var cached: [String] = []
    private var cache: [String : Data] = [:]
    
    init(config: CacheConfig) {
        _config = config
        
        switch _config.cacheType {
        case .leastRecentlyUsed:
            _cachePriority = CacheReorderLeastRecentlyUsed()
        case .firstInFirstOut:
            _cachePriority = CacheReorderFirstInFirstOut()
        case .leastFrequentlyUsed:
            _cachePriority = CacheReorderLeastFrequentlyUsed()
        }
    }
    
    private func purgeCache() -> ([String], [String : Data]) {
        return ([], [:])
    }
    
    public func get(for key: String) -> Data? {
        guard let item = cache[key] else {
            return nil
        }
        
        return item
    }
    
    public func store(_ key: String, _ value: Data) {
        cache[key] = value
    }
}
