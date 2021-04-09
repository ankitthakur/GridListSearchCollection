//
//  IMDBSearchInteractor.swift
//  GridListSearchCollection
//
//  Created by Ankit Thakur on 09/04/21.
//

import Foundation

class IMDBSearchInteractor {
    weak var presenter: IMDBSearchInteractorToPresenterProtocol?
}

// MARK: - IMDBSearchPresenterToInteractorProtocol
extension IMDBSearchInteractor: IMDBSearchPresenterToInteractorProtocol {
    
    func registerObservers() {
        ServiceEventManager.shared.addObserver(self)
    }
    
    func unregisterObservers() {
        ServiceEventManager.shared.removeObserver(self)
    }
    
    func fetchMovies(for searchMovieName: String?) {
        guard let searchName = searchMovieName, !searchName.isEmpty else {
            presenter?.didReceiveNoMovies()
            return
        }
        
        Service.searchResults(for: searchName)
    }
}

extension IMDBSearchInteractor: ServiceEmitter {
    
    func didReceiveSearchResults(_ searchResults: IMDBSearchDataModel) {
        let results = searchResults.movies
        if results.count > 0 {
            presenter?.appendMovies(results)
        } else {
            presenter?.didReceiveNoMovies()
        }
    }
    
    func didReceiveError(_ error: Error) {
        presenter?.didReceiveError()
    }
}
