//
//  IMDBSearchPresenterToViewProtocol.swift
//  GridListSearchCollection
//
//  Created by Ankit Thakur on 09/04/21.
//

import Foundation

protocol IMDBSearchPresenterToViewProtocol: class {
    func initializeView()
    func reloadMovies()
    func showNoMoviesReceived()
}
