//
//  File.swift
//  TVSeries App
//
//  Created by David T on 7/27/21.
//

import Foundation

struct DetailFactory {
        
    static func makeDetailViewModel(listType: ListType, coordinator: DetailCoordinator) -> DetailsViewModel {
        let apiService = ApiService()
        let seriesService = SeriesDetailService(apiService)
        let viewModel = DetailsViewModel(seriesService, type: listType, coordinator: coordinator)
        return viewModel
    }
}
