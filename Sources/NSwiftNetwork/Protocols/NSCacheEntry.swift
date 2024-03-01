//
//  File.swift
//  
//
//  Created by Kerim Njuhovic on 2/29/24.
//

import Foundation

/**
 `NSCacheEntry` protocol defines the requirements for managing cached data for a specific URL.

 Implement this protocol to create custom caching mechanisms for network data.

 ## Usage Example:
 ```swift
 class ExampleCacheManager: NSCacheEntry {
     private var cache: [URL: Data] = [:]
     private let defaultCacheDuration: TimeInterval = 3600
     
     required init(timeInterval: TimeInterval) {
         // Custom initialization logic
     }
     
     func fetchDataFor(url: URL) -> Data? {
         return cache[url]
     }
     
     func cache(data: Data, forURL url: URL) {
         cache[url] = data
     }
 }
*/
public protocol NSCacheEntry {
    init(timeInterval: TimeInterval)
    
    func fetchDataFor(url: URL) -> Data?
    func cache(data: Data, forURL url: URL)
}
