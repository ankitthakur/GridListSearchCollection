//
//  IMDBSearchPresenterToInteractorProtoocol.swift
//  GridListSearchCollection
//
//  Created by Ankit Thakur on 09/04/21.
//

import Foundation

protocol IMDBSearchPresenterToInteractorProtocol {
    func registerObservers()
    func unregisterObservers()
    func fetchMovies(for searchMovieName: String?) 
}
