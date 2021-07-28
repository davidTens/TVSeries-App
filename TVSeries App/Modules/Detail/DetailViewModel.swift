//
//  DetailViewModel.swift
//  TVSeries App
//
//  Created by David T on 7/27/21.
//

import Foundation

struct DetailViewModel {
    let name: String
    let rating: String
    let backdropPath: String
    let originalName: String
    let realeaseDate: String
    let originCountry: String
    let language: String
    let overview: String
    
    init(_ item: SerieDetailModel) {
        name = item.name
        rating = "Rating - \(item.vote_average)"
        backdropPath = "\(NetworkConstants.posterPath)\(item.backdrop_path ?? "")"
        originalName = item.name
        realeaseDate = item.first_air_date
        language = item.original_language
        originCountry = item.origin_country.first ?? ""
        overview = item.overview
    }
    
    init(_ item: MoviesDetailModel) {
        name = item.title
        rating = "Rating - \(item.vote_average)"
        backdropPath = "\(NetworkConstants.posterPath)\(item.backdrop_path ?? "")"
        overview = item.overview
        originalName = item.original_title
        realeaseDate = item.release_date
        language = item.original_language
        originCountry = ""
    }
}
