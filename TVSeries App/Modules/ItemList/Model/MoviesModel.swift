//
//  MoviesModel.swift
//  TVSeries App
//
//  Created by David T on 7/13/21.
//

import Foundation

public struct MoviesGroup: Decodable {
    
    let page: Int
    let results: [Movie]
    let totalResults: Int
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case results = "results"
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
}

public struct Movie: Decodable, Hashable {
    
    let posterPath: String?
    let popularity: Double
    let id: Int
    let backdropPath: String?
    let voteAverage: Decimal
    let overview: String
    let title: String
    let originalLanguage: String
    let originalTitle: String
    let releaseDate: String
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case popularity = "popularity"
        case id = "id"
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case overview = "overview"
        case title = "title"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case releaseDate = "release_date"
    }
}
