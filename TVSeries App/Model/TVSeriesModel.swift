//
//  TVSeriesModel.swift
//  TV Series App
//
//  Created by David T on 3/28/21.
//

import Foundation

struct TVSeriesGroup: Decodable {
    
    let page: Int
    let results: [TVSeries]
    let totalResults: Int
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case results = "results"
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
}

struct TVSeries: Decodable, Hashable {
    
    let posterPath: String?
    let popularity: Double
    let id: Int
    let backdropPath: String?
    let voteAverage: Decimal
    let overview: String
    let firstAirDate: String
    let originCountry: Array<String>
    let genreIds: Array<Int>
    let originalLanguage: String
    let voteCount: Int
    let name: String
    let originalName: String
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case popularity = "popularity"
        case id = "id"
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case overview = "overview"
        case firstAirDate = "first_air_date"
        case originCountry = "origin_country"
        case genreIds = "genre_ids"
        case originalLanguage = "original_language"
        case voteCount = "vote_count"
        case name = "name"
        case originalName = "original_name"
        
    }
}
