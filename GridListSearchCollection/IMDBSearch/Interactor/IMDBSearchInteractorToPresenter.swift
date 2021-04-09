//
//  IMDBSearchInteractorToPresenter.swift
//  GridListSearchCollection
//
//  Created by Ankit Thakur on 09/04/21.
//

import Foundation

protocol IMDBSearchInteractorToPresenterProtocol: class {
    func appendMovies(_ movies: [Movie])
    func didReceiveNoMovies()
    func didReceiveError()
}
