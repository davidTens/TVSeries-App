//
//  ViewModel.swift
//  TVSeries App
//
//  Created by David T on 7/7/21.
//

import Foundation

final class SeriesViewModel {
    
    private var seriesAPI: TVSeriesAPI?
    var delegate: SerieNavigator?
    
    lazy var page = 1
    private lazy var language = "en-US"
    private (set) var result: Bindable<[ItemViewModel]> = Bindable([])
    private (set) var serviceState: Bindable<FetchingServiceState> = Bindable(.loading)
    
    init(_ series: TVSeriesAPI) {
        self.seriesAPI = series
    }
    
    func refresh() {
        result.value.count == 0 ? fetchSeries() : print("done")
    }
    
    func fetchSeries() {
        let adapter = SeriesAdapter(api: TVSeriesAPI.shared, selectSeries: { [weak self] in
            self?.select(serie: $0)
        })
        serviceState.value = .loading
        adapter.fetchItems(endpoint: NetworkConstants.popularTVSeries, language: language, page: page, query: nil, completion: handleApiResults(_:))
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

extension SeriesViewModel {
    private func select(serie: TVSeries) {
        delegate?.navigate(to: serie)
    }
}
