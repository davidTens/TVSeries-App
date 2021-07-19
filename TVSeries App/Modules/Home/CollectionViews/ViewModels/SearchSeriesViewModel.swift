//
//  SearchViewModel.swift
//  TVSeries App
//
//  Created by David T on 7/7/21.
//

import Foundation

final class SearchSeriesViewModel {
    
    private var api: TVSeriesAPI?
    var delegate: SerieNavigator?
    
    lazy var page = 1
    private lazy var language = "en-US"
    private (set) var result: Bindable<[ItemViewModel]> = Bindable([])
    private (set) var serviceState: Bindable<FetchingServiceState> = Bindable(.loading)
    
    init(_ api: TVSeriesAPI) {
        self.api = api
    }
    
    func searchSeries(query: String) {
        let adapter = SeriesAdapter(api: TVSeriesAPI.shared) { [weak self] in
            self?.select(serie: $0)
        }
        serviceState.value = .loading
        let modifiedQuery = "&query=\(query)".replacingOccurrences(of: " ", with: "%20")
        adapter.fetchItems(endpoint: NetworkConstants.searchTVPath, language: language, page: page, query: modifiedQuery, completion: handleApiResults(_:))
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

extension SearchSeriesViewModel {
    private func select(serie: TVSeries) {
        delegate?.navigate(to: serie)
    }
}
