//
//  ItemList Factory.swift
//  TVSeries App
//
//  Created by David T on 7/23/21.
//

import Foundation

struct ItemListFactory {
    static func makeSeriesViewModel() -> ItemsViewModel {
        let apiService = ApiService()
        let seriesService = SeriesServices(apiService, selection: { item in })
        let viewModel = ItemsViewModel(seriesService)
        return viewModel
    }

    static func makeMoviesViewModel() -> ItemsViewModel {
        let apiService = ApiService()
        let seriesService = MoviesServices(apiService, selection: { item in })
        let viewModel = ItemsViewModel(seriesService)
        return viewModel
    }
    
    static func makeDetailViewModelForSeries() -> DetailViewModel {
        let apiService = ApiService()
        let seriesService = SeriesServices(apiService, selection: { item in })
        let viewModel = DetailViewModel(seriesService)
        return viewModel
    }
    
    static func makeDetailViewModelForMovies() -> DetailViewModel {
        let apiService = ApiService()
        let seriesService = MoviesServices(apiService, selection: { item in })
        let viewModel = DetailViewModel(seriesService)
        return viewModel
    }
}
