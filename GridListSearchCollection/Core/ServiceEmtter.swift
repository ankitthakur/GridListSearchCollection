//
//  ServiceEmtter.swift
//  GridListSearchCollection
//
//  Created by Ankit Thakur on 09/04/21.
//

import Foundation

protocol ServiceEmitter {
    func didReceiveSearchResults(_ searchResults:IMDBSearchDataModel)
    func didReceiveError(_ error: Error)
}

extension ServiceEmitter {
    func didReceiveSearchResults(_ searchResults:IMDBSearchDataModel) {}
    func didReceiveError(_ error: Error) {}
}

final class ServiceEventManager {
    static let shared = ServiceEventManager()
    fileprivate init() {}
    var observers = NSMutableSet()
    
    func addObserver(_ observer: ServiceEmitter) {
        self.observers.add(observer)
    }
    
    func removeObserver(_ observer: ServiceEmitter) {
        self.observers.remove(observer)
    }
    
    func didReceiveSearchResults(_ searchResults:IMDBSearchDataModel) {
        for observer in self.observers {
            guard let emitter = observer as? ServiceEmitter else {continue}
            emitter.didReceiveSearchResults(searchResults)
        }
    }
    
    func didReceiveError(_ error: Error) {
        for observer in self.observers {
            guard let emitter = observer as? ServiceEmitter else {continue}
            emitter.didReceiveError(error)
        }
    }
    
}
