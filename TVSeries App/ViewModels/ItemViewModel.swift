//
//  ItemViewModel.swift
//  TVSeries App
//
//  Created by David T on 7/7/21.
//

import Foundation

struct ItemViewModel {
    
    private var series: TVSeries!
    
    var name: String {
        return series.name
    }
    
    var rating: String {
        return "Rating - \(series.voteAverage)"
    }
    
    var imageURLPath: String {
        return "https://image.tmdb.org/t/p/w500/\(series.posterPath ?? "")"
    }
    
    let select: () -> Void
    
    init(_ item: TVSeries, selection: @escaping () -> Void) {
        self.series = item
        self.select = selection
    }
    
    
}
