//
//  SearchViewModel.swift
//  TVSeries App
//
//  Created by David T on 7/7/21.
//

import Foundation

final class SearchViewModel {
    
    private var api: NetworkRequest?
    
    lazy var page = 1
    private lazy var language = "en-US"
    private (set) var list: Bindable<[ItemViewModel]> = Bindable([])
    
    var delegate: Navigator!
    
    init(_ api: NetworkRequest) {
        self.api = api
    }
    
    func searchSeries(query: String) {
        let adapter = SeriesAdapter(api: NetworkRequest.shared) { [weak self] in
            self?.select(series: $0)
        }
        adapter.fetchSeries(type: "tv", tv: nil, similar: nil, search: "search", query: "&query=" + query.replacingOccurrences(of: " ", with: "%20"), language: language, page: page, completed: handleApiResults(_:))
    }
    
    private func handleApiResults(_ results: Result<[ItemViewModel], ErrorHandling>) {
        switch results {
        case .success(let list):
            self.list.value.append(contentsOf: list)
        case .failure(let error):
            print(error)
        }
    }
}

extension SearchViewModel {
    private func select(series: TVSeries) {
        delegate.navigate(series)
    }
}
