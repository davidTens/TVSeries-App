//
//  ItemViewModel.swift
//  TVSeries App
//
//  Created by David T on 7/7/21.
//

import Foundation

public struct ItemViewModel {
    
    let id: Int
    let name: String
    let rating: String
    let imageURLPath: String
    let backdropPath: String
    let originalName: String
    let realeaseDate: String
    let originCountry: String
    let language: String
    let overview: String
    
    init(_ item: TVSeries) {
        id = item.id
        name = item.name
        rating = "Rating - \(item.voteAverage)"
        imageURLPath = "\(NetworkConstants.posterPath)\(item.posterPath ?? "")"
        backdropPath = "\(NetworkConstants.posterPath)/\(item.backdropPath ?? "")"
        originalName = item.originalName
        realeaseDate = item.firstAirDate
        language = item.originalLanguage
        originCountry = item.originCountry.first ?? ""
        overview = item.overview
        
    }
    
    init(_ item: Movie) {
        id = item.id
        name = item.title
        rating = "Rating - \(item.voteAverage)"
        imageURLPath = "\(NetworkConstants.posterPath)\(item.posterPath ?? "")"
        backdropPath = "\(NetworkConstants.posterPath)/\(item.backdropPath ?? "")"
        overview = item.overview
        originalName = item.originalTitle
        realeaseDate = item.releaseDate
        language = item.originalLanguage
        originCountry = ""
    }
    
}
