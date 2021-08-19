//
//  ViewModel.swift
//  TVSeries App
//
//  Created by David T on 7/7/21.
//

import Foundation

enum ListType {
    case tvSeries
    case movies
    
    var searchTextFieldPlaceholder: String {
        switch self {
        case .tvSeries:
            return "Search TV Series"
        case .movies:
            return "Search Movies"
        }
    }
}

final class ItemsViewModel {

    let type: ListType
    private let itemsService: ItemsService

    lazy var page = 1
    private lazy var language = "en-US"
    private (set) var result: Bindable<[ItemViewModel]> = Bindable([])
    private (set) var serviceState: Bindable<FetchingServiceState> = Bindable(.loading)
    weak var coordinator: HomeCoordinator?

    init(_ service: ItemsService, type: ListType, coordinator: HomeCoordinator) {
        self.itemsService = service
        self.type = type
        self.coordinator = coordinator
    }

    func refresh() {
        result.value.count == 0 ? fetchData() : nil
    }
    
    func select(itemViewModel: ItemViewModel) {
        coordinator?.openItem(itemViewModel: itemViewModel, listType: type)
    }
    
    func makeNumberOfRowsInSection() -> Int {
        return result.value.count
    }
    
    func makeSearchTextFieldPlaceholder() -> String {
        return type.searchTextFieldPlaceholder
    }

    func fetchData() {
        serviceState.value = .loading
        itemsService.fetchData(language: language, page: page, completion: handleApiResults)
    }

    func searchData(_ query: String) {
        serviceState.value = .loading
        if result.value.count != 1 {
            let queryWithOccurrences = "&query=\(query)".replacingOccurrences(of: " ", with: "%20")
            itemsService.searchData(language: language, page: page, query: queryWithOccurrences, completion: handleApiResults)
        }
    }
    
    private func handleApiResults(_ results: Result<[ItemViewModel], ErrorHandling>) {
        switch results {
        case .success(let list):
            result.value.append(contentsOf: list)
        case .failure(let error):
            serviceState.value = .error(error.rawValue)
        }
        serviceState.value = .finished
    }
}
