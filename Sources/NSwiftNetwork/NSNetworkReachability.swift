//
//  File.swift
//  
//
//  Created by Kerim Njuhovic on 2/28/24.
//

import Foundation
import Network
import Combine

class NSNetworkReachability {

    static let shared = NSNetworkReachability()
    private let monitor = NWPathMonitor()
    private let isConnectedSubject = CurrentValueSubject<Bool, Never>(false)

    var isConnectedPublisher: AnyPublisher<Bool, Never> {
        isConnectedSubject.eraseToAnyPublisher()
    }

    var isConnected: Bool {
        monitor.currentPath.status == .satisfied
    }

    init() {
        startNetworkReachabilityObserver()
    }

    private func startNetworkReachabilityObserver() {
        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            if path.status == .satisfied {
                self.isConnectedSubject.send(true)
            } else if path.status == .unsatisfied {
                self.isConnectedSubject.send(false)
            }
        }
    }
    
}
