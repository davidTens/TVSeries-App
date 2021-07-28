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
        let seriesService = SeriesServices(apiService)
        let viewModel = ItemsViewModel(seriesService, type: .tvSeries)
        return viewModel
    }

    static func makeMoviesViewModel() -> ItemsViewModel {
        let apiService = ApiService()
        let seriesService = MoviesServices(apiService)
        let viewModel = ItemsViewModel(seriesService, type: .movies)
        return viewModel
    }
}
