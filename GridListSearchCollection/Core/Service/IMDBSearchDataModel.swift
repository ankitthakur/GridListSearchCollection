//
//  IMDBSearchDataModel.swift
//  GridListSearchCollection
//
//  Created by Ankit Thakur on 09/04/21.
//

import Foundation

// MARK: - SearchResults
struct IMDBSearchDataModel: Codable {
    let movies: [Movie]
    let totalResults, response: String
    
    enum CodingKeys: String, CodingKey {
        case movies = "Search"
        case totalResults
        case response = "Response"
    }
}

// MARK: - Search
struct Movie: Codable {
    let title, year, imdbID: String
    let type: TypeEnum
    let posterURL: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case posterURL = "Poster"
    }
}

enum TypeEnum: String, Codable {
    case movie = "movie"
    case game = "game"
    case series = "series"
}
