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
    let select: () -> Void
    
    init(_ item: TVSeries, selection: @escaping () -> Void) {
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
        select = selection
    }
    
    init(_ item: Movie, selection: @escaping () -> Void) {
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
        select = selection
    }
    
}
