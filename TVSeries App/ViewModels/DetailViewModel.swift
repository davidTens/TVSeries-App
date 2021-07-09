//
//  DetailViewModel.swift
//  TVSeries App
//
//  Created by David T on 7/7/21.
//

import Foundation

final class DetailViewModel {
    
    private var api: APICall?
    var delegate: Navigator?
    
    lazy var page = 1
    private lazy var language = "en-US"
    private (set) var response: Bindable<[ItemViewModel]> = Bindable([])
    
    init(_ api: APICall) {
        self.api = api
    }
    
    func fetchSimilar(serieId: Int) {
        let adapter = SeriesAdapter(api: APICall.shared) { [weak self] in
            self?.select(serie: $0)
        }
        adapter.fetchSeries(endpoint: "/tv/\(String(serieId))/similar", language: language, page: page, query: nil, completion: handleApiResults(_:))
    }
    
    private func handleApiResults(_ results: Result<[ItemViewModel], ErrorHandling>) {
        switch results {
        case .success(let list):
            response.value.append(contentsOf: list)
        case .failure(let error):
            print(error)
        }
    }
}

extension DetailViewModel {
    private func select(serie: TVSeries) {
        delegate?.navigate(to: serie)
    }
}
