//
//  File.swift
//  TVSeries App
//
//  Created by David T on 7/27/21.
//

import Foundation

struct DetailFactory {
    static func makeDetailViewModelForSeries() -> DetailsViewModel {
        let apiService = ApiService()
        let seriesService = SeriesDetailService(apiService)
        let viewModel = DetailsViewModel(seriesService, type: .tvSeries)
        return viewModel
    }
    
    static func makeDetailViewModelForMovies() -> DetailsViewModel {
        let apiService = ApiService()
        let seriesService = MoviesDetailService(apiService)
        let viewModel = DetailsViewModel(seriesService, type: .movies)
        return viewModel
    }
}
