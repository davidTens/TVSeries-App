//
//  ItemViewModel.swift
//  TVSeries App
//
//  Created by David T on 7/7/21.
//

import Foundation

public struct ItemViewModel {
    
    let name: String
    let rating: String
    let imageURLPath: String
    let select: () -> Void
    
    init(_ series: TVSeries, selection: @escaping () -> Void) {
        name = series.name
        rating = "Rating - \(series.voteAverage)"
        imageURLPath = "\(NetworkConstants.posterPath)\(series.posterPath ?? "")"
        select = selection
    }
    
    init(_ movie: Movie, selection: @escaping () -> Void) {
        name = movie.title
        rating = "Rating - \(movie.voteAverage)"
        imageURLPath = "\(NetworkConstants.posterPath)\(movie.posterPath ?? "")"
        select = selection
    }
    
}
