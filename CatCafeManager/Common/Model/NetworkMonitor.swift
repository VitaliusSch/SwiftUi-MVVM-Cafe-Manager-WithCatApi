//
//  NetworkMonitor.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 10.04.2023.
//

import Foundation
import Network

/// Allows to check the network status
final class NetworkMonitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
     
    @Published var isConnected = true
     
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.setConnect(isAvailable: path.status == .satisfied)
        }
        monitor.start(queue: queue)
    }
    
    private func setConnect(isAvailable: Bool) {
        Task(priority: .high) { [weak self] in
            guard let self = self else { return }
            let pingResult = await self.ping()
            DispatchQueue.main.async {
                self.isConnected =  isAvailable && pingResult
            }
        }
    }
    
    private func ping() async -> Bool {
        if let url = URL(string: AppRoutes.BasicURL) {
            var request = URLRequest(url: url)
            request.httpMethod = "HEAD"
            do {
                let (_, response) = try await URLSession(configuration: .default).data(for: request)
                guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                    return false
                }
                return true
            } catch {
                return false
            }
        }
        return false
    }
}
