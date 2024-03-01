//
//  File.swift
//  
//
//  Created by Kerim Njuhovic on 2/28/24.
//

import Foundation

public enum NSNetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingFailed
    case requestFailed(String)
    case noNetworkConnection
}
