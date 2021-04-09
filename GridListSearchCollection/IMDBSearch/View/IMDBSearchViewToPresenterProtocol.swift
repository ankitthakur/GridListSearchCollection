//
//  IMDBSearchViewToPresenterProtocol.swift
//  GridListSearchCollection
//
//  Created by Ankit Thakur on 09/04/21.
//

import Foundation

protocol IMDBSearchViewToPresenterProtocol {
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    
    func fetchMovies(for searchMovieName: String?, withIncrementalPage: Bool)
    
    // DataProvider apis right now in presenter
    func numberOfSections() -> Int
    func numberOfItemsInSection(_ section: Int) -> Int
    func movie(at indexPath: IndexPath) -> Movie?
}
