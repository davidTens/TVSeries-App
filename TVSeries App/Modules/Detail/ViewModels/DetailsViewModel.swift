//
//  DetailViewModel.swift
//  TVSeries App
//
//  Created by David T on 7/7/21.
//

import Foundation

final class DetailsViewModel {
    
    let type: ListType
    private let detailService: DetailService
    
    lazy var page = 1
    private lazy var language = "en-US"
    private (set) var similarResults: Bindable<[ItemViewModel]> = Bindable([])
    private (set) var serviceState: Bindable<FetchingServiceState> = Bindable(.loading)
    private (set) lazy var detailResultsArray = Bindable<[String]>([])
    private weak var coordinator: DetailCoordinator?
    
    init(_ service: DetailService, type: ListType, coordinator: DetailCoordinator) {
        self.detailService = service
        self.type = type
        self.coordinator = coordinator
    }
    
    func fetchSimilarData(with id: Int) {
        serviceState.value = .loading
        detailService.fetchSimilar(language: language, page: page, id: id, completion: handleSimilarApiResults)
    }
    
    func appendListToDetailResults(list: ItemViewModel) {
        detailResultsArray.value.append(list.overview)
        detailResultsArray.value.append(list.name)
        detailResultsArray.value.append(list.realeaseDate)
        detailResultsArray.value.append(list.originCountry)
        detailResultsArray.value.append(list.language)
    }
    
    private func handleSimilarApiResults(_ results: Result<[ItemViewModel], ErrorHandling>) {
        switch results {
        case .success(let list):
            similarResults.value.append(contentsOf: list)
        case .failure(let error):
            serviceState.value = .error(error.rawValue)
        }
        serviceState.value = .finished
    }
}
