//
//  ViewModel.swift
//  TVSeries App
//
//  Created by David T on 7/7/21.
//

import Foundation

final class SeriesViewModel {
    
    private var api: APICall?
    var delegate: Navigator?
    
    lazy var page = 1
    private lazy var language = "en-US"
    private (set) var response: Bindable<[ItemViewModel]> = Bindable([])
    private (set) var serviceState: Bindable<FetchingServiceState> = Bindable(.loading)
    
    init(_ api: APICall) {
        self.api = api
    }
    
    func refresh() {
        response.value.count == 0 ? fetchSeries() : print("done")
    }
    
    func fetchSeries() {
        let adapter = SeriesAdapter(api: APICall.shared, select: { [weak self] in
            self?.select(serie: $0)
        })
        serviceState.value = .loading
        adapter.fetchSeries(endpoint: NetworkConstants.popularTVSeries, language: language, page: page, query: nil, completion: handleApiResults(_:))
    }
    
    private func handleApiResults(_ results: Result<[ItemViewModel], ErrorHandling>) {
        switch results {
        case .success(let list):
            response.value.append(contentsOf: list)
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
