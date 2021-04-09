//
//  NetworkManager.swift
//  GridListSearchCollection
//
//  Created by Ankit Thakur on 09/04/21.
//

import Foundation
import Connectivity
import SystemConfiguration

private enum NetworkConnection: CustomStringConvertible {
    case none, wifi, cellular
    public var description: String {
        switch self {
        case .cellular: return "Cellular"
        case .wifi: return "WiFi"
        case .none: return "No Connection"
        }
    }
}

internal final class NetworkManager {
    
    
    static let shared = NetworkManager()
    
    let connectivity: Connectivity
    fileprivate init() {
        connectivity = Connectivity(shouldUseHTTPS: true)
        connectivity.isPollingEnabled = true
        connectivity.framework = .systemConfiguration
    }
    
    // MARK: - Internet Check
    
    func isNetworkReachable() -> Bool {
        switch connectivity.status {
        case .connected, .connectedViaWiFi, .connectedViaCellular:
            return true
        default:
            return false
        }
    }
    
    func isNetworkReachableOnWifi() -> Bool {
        return connectivity.status == .connectedViaWiFi
    }
    
    func hasCellularNetwork() -> Bool {
        return connectivity.status == .connectedViaCellular || connectivity.status == .connectedViaCellularWithoutInternet
    }
    
    
    internal func setUp() {
        connectivity.whenConnected = { connectivity in
            // notify on network available
        }
        connectivity.whenDisconnected = { connectivity in
            // notify on network not available
        }
        connectivity.startNotifier()
    }
}
