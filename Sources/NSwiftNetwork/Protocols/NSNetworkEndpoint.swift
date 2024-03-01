//
//  File.swift
//  
//
//  Created by Kerim Njuhovic on 2/28/24.
//

import Foundation

/// A dictionary of parameters to apply to a `URLRequest`.
public typealias Parameters = [String: String]
public typealias HTTPHeaders = [String : String]

/**
 `NSNetworkEndpoint` protocol defines the structure of a network endpoint.

 An endpoint encapsulates information necessary to construct a URLRequest for communicating with a server.

 ## Usage Example:
 ```swift
 struct ExampleEndpoint: NSNetworkEndpoint {
     var baseURL: URL {
         URL(string: "https://api.example.com")!
     }
     
     var path: String {
         "/data"
     }
     
     var headers: HTTPHeaders {
         ["Authorization": "Bearer <token>"]
     }
     
     var parameters: Parameters? {
         ["page": "1", "limit": "10"]
     }
     
     var method: HTTPMethod {
         .get
     }
 }
*/
public protocol NSNetworkEndpoint {
    
    /// The base URL of the server.
    var baseURL: URL { get }

    /// The full URL constructed from the base URL and path.
    var requestURL: URL { get }

    /// The path component of the URL.
    var path: String { get }

    /// Dictionary representing HTTP headers.
    var headers: HTTPHeaders { get }

    /// Optional parameters to be included in the request.
    var parameters: Parameters? { get }

    /// The HTTP method to be used for the request.
    var method: HTTPMethod { get }

    /// The URLRequest constructed using endpoint information.
    var urlRequest: URLRequest { get }
    
}

// MARK: - Default Implementation -

package extension NSNetworkEndpoint {
    
    var requestURL: URL {
        baseURL.appendingPathComponent(path)
    }
    
    var headers: HTTPHeaders {
        ["Accept": "application/json"]
    }
    
    var urlRequest: URLRequest {
        var request = URLRequest(url: requestURL)
        var urlComponents = URLComponents(string: requestURL.absoluteString)
        
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        // If parameters exist, add them as query items
        if let parameters = parameters {
            let queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
            if urlComponents?.queryItems == nil {
                urlComponents?.queryItems = queryItems
            } else {
                urlComponents?.queryItems?.append(contentsOf: queryItems)
            }
        }
        
        // Get the updated URL string
        if let updatedURL = urlComponents?.url {
            request = URLRequest(url: updatedURL)
        }
        
        return request
    }
    
}
