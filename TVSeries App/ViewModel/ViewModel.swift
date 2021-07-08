//
//  ViewModel.swift
//  TVSeries App
//
//  Created by David T on 7/7/21.
//

import Foundation

final class SeriesViewModel {
    
    private var api: NetworkRequest?
    
    var delegate: Navigator!
    
    lazy var page = 1
    private lazy var language = "en-US"
    private (set) var list: Bindable<[ItemViewModel]> = Bindable([])
    
    init(_ api: NetworkRequest) {
        self.api = api
    }
    
    
    func fetchSeries() {
        let adapter = SeriesAdapter(api: NetworkRequest.shared, select: { [weak self] in
            self?.select(series: $0)
        })
        adapter.fetchSeries(type: "popular", tv: "tv", similar: nil, search: nil, query: nil, language: language, page: page, completed: handleApiResults(_:))
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

extension SeriesViewModel {
    private func select(series: TVSeries) {
        delegate.navigate(series)
    }
}
