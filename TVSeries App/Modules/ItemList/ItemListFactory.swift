//
//  ItemList Factory.swift
//  TVSeries App
//
//  Created by David T on 7/23/21.
//

import Foundation

struct ItemListFactory {
    static func makeSeriesViewModel(coordinator: HomeCoordinator) -> ItemsViewModel {
        let apiService = ApiService()
        let seriesService = SeriesService(apiService)
        let viewModel = ItemsViewModel(seriesService, type: .tvSeries, coordinator: coordinator)
        return viewModel
    }

    static func makeMoviesViewModel(coordinator: HomeCoordinator) -> ItemsViewModel {
        let apiService = ApiService()
        let seriesService = MoviesService(apiService)
        let viewModel = ItemsViewModel(seriesService, type: .movies, coordinator: coordinator)
        return viewModel
    }
}
