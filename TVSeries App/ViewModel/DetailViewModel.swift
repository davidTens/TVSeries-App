//
//  DetailViewModel.swift
//  TVSeries App
//
//  Created by David T on 7/7/21.
//

import Foundation

final class DetailViewModel {
    
    private var api: NetworkRequest?
    
    lazy var page = 1
    private lazy var language = "en-US"
    private (set) var list: Bindable<[ItemViewModel]> = Bindable([])
    
    init(_ api: NetworkRequest) {
        self.api = api
    }
    
    func fetchSimilar(serieId: Int) {
        let adapter = SeriesAdapter(api: NetworkRequest.shared) { [weak self] in
            self?.select(series: $0)
        }
        adapter.fetchSeries(type: serieId, tv: "tv", similar: "similar", search: nil, query: nil, language: language, page: page, completed: handleApiResults(_:))
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

extension DetailViewModel {
    private func select(series: TVSeries) {
        print(series.name)
    }
}
