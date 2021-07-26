//
//  ViewModel.swift
//  TVSeries App
//
//  Created by David T on 7/7/21.
//

import Foundation

final class ItemsViewModel {

    private let itemsService: ItemsService
    var delegate: Navigator?

    lazy var page = 1
    private lazy var language = "en-US"
    private (set) var result: Bindable<[ItemViewModel]> = Bindable([])
    private (set) var serviceState: Bindable<FetchingServiceState> = Bindable(.loading)

    init(_ service: ItemsService) {
        self.itemsService = service
    }

    func refresh() {
        result.value.count == 0 ? fetchData() : print("done")
    }

    func fetchData(query: String? = nil) {
        serviceState.value = .loading
        if let value = query {
            let modifiedQuery = "&query=\(value)".replacingOccurrences(of: " ", with: "%20")
            itemsService.searchData(language: language, page: page, query: modifiedQuery, completion: handleApiResults)
        } else {
            itemsService.fetchData(language: language, page: page, completion: handleApiResults)
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
