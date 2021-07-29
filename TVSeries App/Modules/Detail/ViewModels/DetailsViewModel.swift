//
//  DetailViewModel.swift
//  TVSeries App
//
//  Created by David T on 7/7/21.
//

import Foundation

final class DetailsViewModel {
    
    private let detailService: DetailService
    var delegate: Navigator?
    let type: ListType
    
    lazy var page = 1
    private lazy var language = "en-US"
    private (set) var similarResults: Bindable<[ItemViewModel]> = Bindable([])
    private (set) var serviceState: Bindable<FetchingServiceState> = Bindable(.loading)
    private (set) lazy var detailResultsViewModel: Bindable<[DetailViewModel]> = Bindable([])
    private (set) lazy var detailResultsArray = Bindable<[String]>([])
    
    init(_ service: DetailService, type: ListType) {
        self.detailService = service
        self.type = type
    }
    
    func fetchSimilarData(with id: Int) {
        serviceState.value = .loading
        detailService.fetchSimilar(language: language, page: page, id: id, completion: handleSimilarApiResults)
    }
    
    func fetchData(id: Int) {
        serviceState.value = .loading
        detailService.fetchData(id: id, language: language, page: page, completion: handleApiResults)
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
    
    private func handleApiResults(_ results: Result<DetailViewModel, ErrorHandling>) {
        switch results {
        case .success(let list):
            detailResultsArray.value.append(list.overview)
            detailResultsArray.value.append(list.name)
            detailResultsArray.value.append(list.realeaseDate)
            detailResultsArray.value.append(list.originCountry)
            detailResultsArray.value.append(list.language)
            detailResultsArray.value.append(list.backdropPath)
            detailResultsViewModel.value.append(list)
        case .failure(let error):
            serviceState.value = .error(error.rawValue)
        }
        serviceState.value = .finished
    }
}
