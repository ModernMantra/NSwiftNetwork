//
//  File.swift
//  
//
//  Created by Kerim Njuhovic on 2/27/24.
//

import Foundation

public final class NSCacheManager: NSCacheEntry {
    
    private var timeInterval: TimeInterval
    private let cache = NSCache<NSString, Response>()
    
    public init(timeInterval: TimeInterval = 3600) {
        self.timeInterval = timeInterval
    }
    
    public func fetchDataFor(url: URL) -> Data? {
        // Check if cached response is recent
        if let cachedResponse = cache[url], Date().timeIntervalSince(cachedResponse.timestamp) < self.timeInterval {
            return cachedResponse.data
        }
        return nil
    }
    
    public func cache(data: Data, forURL url: URL) {
        cache[url] = Response(data: data, timestamp: Date())
    }
    
}

// MARK: - Response -

internal extension NSCacheManager {
    
    final class Response {
        
        let data: Data
        let timestamp: Date
        
        init(data: Data, timestamp: Date) {
            self.data = data
            self.timestamp = timestamp
        }
        
    }
    
}
