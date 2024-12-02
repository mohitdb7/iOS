//
//  CacheFactory.swift
//  StorageSolutions
//
//  Created by Mohit Dubey on 03/10/24.
//

actor CacheFactory {
    private var cachePool: [String : CacheOperations] = [:]
    
    func getCacheManager(module: String, cacheConfig: CacheConfig) -> CacheOperations {
        guard let _cache = cachePool[module] else {
            let _cache = CacheOperations(config: cacheConfig)
            cachePool[module] = _cache
            return _cache
        }
        
        return _cache
    }
}
