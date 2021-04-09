//
//  IMDBSearchPresenter.swift
//  GridListSearchCollection
//
//  Created by Ankit Thakur on 09/04/21.
//

import Foundation
import UIKit

class IMDBSearchPresenter {
    
    weak var view: IMDBSearchPresenterToViewProtocol?
    var interactor: IMDBSearchPresenterToInteractorProtocol
    var router: IMDBSearchPresenterToRouterProtocol
    var movies:[Movie] = []
    var pageIndex:Int = 0
    var lastRequestedTime: TimeInterval = 0
    init(view: IMDBSearchPresenterToViewProtocol, interactor: IMDBSearchPresenterToInteractorProtocol,
         router: IMDBSearchPresenterToRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - IMDBSearchViewToPresenterProtocol
extension IMDBSearchPresenter: IMDBSearchViewToPresenterProtocol {
    
    func viewDidLoad() {
        view?.initializeView()
    }
    
    func viewWillAppear() {
        interactor.registerObservers()
    }
    
    func viewWillDisappear() {
        interactor.unregisterObservers()
    }
    
    func fetchMovies(for searchMovieName: String?, withIncrementalPage: Bool) {
        guard NetworkManager.shared.isNetworkReachable() else {
            if let viewController = view as? UIViewController,
               let navigationController = viewController.navigationController {
                router.showNoInternetAvailable(in: navigationController)
            }
            return
        }
        if withIncrementalPage {
            pageIndex = pageIndex + 1
        } else {
            pageIndex = 0
        }
        let difference = Date().timeIntervalSince1970 - lastRequestedTime
        print("difference - \(difference)")
        guard difference > 0.2 else {return}
        interactor.fetchMovies(for:searchMovieName, pageIndex: pageIndex)
        
    }
    
    func numberOfSections() -> Int {
        return movies.count > 0 ? 1: 0
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        return movies.count
    }
    
    func canLoadMore(at indexPath: IndexPath) -> Bool {
        guard indexPath.row == movies.count-1 else {return false}
        return true
    }
    
    func movie(at indexPath: IndexPath) -> Movie? {
        guard indexPath.row < movies.count else {return nil}
        return movies[indexPath.row]
    }
}

// MARK: - IMDBSearchInteractorToPresenterProtocol
extension IMDBSearchPresenter: IMDBSearchInteractorToPresenterProtocol {
    
    func appendMovies(_ movies: [Movie]) {
        lastRequestedTime = Date().timeIntervalSince1970
        guard view != nil else {return}
        if self.pageIndex == 0 {
            self.movies = movies
        } else {
            self.movies.append(contentsOf: movies)
        }
        view!.reloadMovies()
    }
    
    func didReceiveNoMovies() {
        guard view != nil else {return}
        view!.showNoMoviesReceived()
    }
    
    func didReceiveError() {
        guard pageIndex > 0 else {return}
        pageIndex = pageIndex - 1
    }
    
}
