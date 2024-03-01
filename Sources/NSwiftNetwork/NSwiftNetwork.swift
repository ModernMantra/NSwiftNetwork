
//
//  File.swift
//
//
//  Created by Kerim Njuhovic on 2/27/24.
//

import Foundation
import Combine

/**
 `NSwiftNetwork` is an actor responsible for managing network requests with caching support using `NSCache`.

 This actor provides methods to fetch data from URLs, with the ability to cache responses for future use. It utilizes Combine framework for handling asynchronous operations and publishing data or errors.

 ## Usage Example:
 ```swift
 let network = NSwiftNetwork()

 let url = URL(string: "https://api.example.com/data")!
 let request = URLRequest(url: url)

 let cancellable = network.fetchData(with: request)
     .sink(receiveCompletion: { completion in
         switch completion {
         case .finished:
             print("Data fetched successfully.")
         case .failure(let error):
             print("Error: \(error)")
         }
     }, receiveValue: { data in
         print("Received data: \(data)")
     })
*/
public actor NSwiftNetwork {
    
    /// The manager responsible for caching data.
    private let cacheManager: NSCacheEntry
    
    /// A range of status codes that indicate success.
    private static var successStatusCodes: Range<Int> {
        200 ..< 300
    }
    var session = URLSession.shared
    
    public init(session: URLSession = URLSession.shared, cache: NSCacheEntry = NSCacheManager()) {
        self.session = session
        self.cacheManager = cache
    }
    
    /**
     Fetches data from a URL with caching support.

     - Parameters:
        - request: The URLRequest to fetch data.

     - Returns: A publisher that emits the fetched data or an error of type `NSNetworkError`.
     */
    public func fetchData<T: Decodable>(with request: URLRequest) -> AnyPublisher<T, NSNetworkError> {
        // Check if data is cached.
        if
            let url = request.url,
            let cachedData = cacheManager.fetchDataFor(url: url)
        {
            return try! Just(JSONDecoder().decode(T.self, from: cachedData))
                .setFailureType(to: NSNetworkError.self)
                .eraseToAnyPublisher()
        }
        
        // Fetch data from network.
        return session.dataTaskPublisher(for: request)
            .mapError { error in
                NSNetworkError.requestFailed(error.localizedDescription)
            }
            .tryMap { (data, response) in
                if
                    let httpResponse = response as? HTTPURLResponse,
                    let url = request.url,
                    NSwiftNetwork.successStatusCodes.contains(httpResponse.statusCode)
                {
                    self.cacheManager.cache(data: data, forURL: url)
                    return data
                } else {
                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                    throw NSNetworkError.requestFailed("Request failed with status code: \(statusCode)")
                }
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if error is DecodingError {
                    return NSNetworkError.decodingFailed
                } else {
                    return NSNetworkError.requestFailed("An unknown error occurred.")
                }
            }
            .eraseToAnyPublisher()
    }
    
}
