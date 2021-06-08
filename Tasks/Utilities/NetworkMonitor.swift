//
//  NetworkMonitor.swift
//  Tasks
//
//  Created by Adam Lingham on 08/06/2021.
//

import Network
import SwiftUI

enum NetworkStatus {
    case connected, disconnected
}

class NetworkMonitor: ObservableObject {
    @Published var status = NetworkStatus.connected

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }

            DispatchQueue.main.async {
                if path.status == .satisfied {
                    self.status = .connected
                } else {
                    self.status = .disconnected
                }
            }
        }

        monitor.start(queue: queue)
    }
}
