//
//  File.swift
//  
//
//  Created by Kerim Njuhovic on 2/27/24.
//

import Foundation

extension NSCache where KeyType == NSString, ObjectType == NSCacheManager.Response {
    
    subscript(_ url: URL) -> NSCacheManager.Response? {
        get {
            let key = url.absoluteString as NSString
            let value = object(forKey: key)
            return value
        }
        set {
            let key = url.absoluteString as NSString
            if let entry = newValue {
                setObject(entry, forKey: key)
            } else {
                removeObject(forKey: key)
            }
        }
    }
    
}
