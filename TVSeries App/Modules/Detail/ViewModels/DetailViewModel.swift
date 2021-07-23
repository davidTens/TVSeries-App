//
//  DetailViewModel.swift
//  TVSeries App
//
//  Created by David T on 7/7/21.
//

import Foundation

final class DetailViewModel {
    
    private let itemsService: ItemsService
    var delegate: Navigator?
    
    lazy var page = 1
    private lazy var language = "en-US"
    private (set) var result: Bindable<[ItemViewModel]> = Bindable([])
    private (set) var serviceState: Bindable<FetchingServiceState> = Bindable(.loading)
    
    init(_ service: ItemsService) {
        self.itemsService = service
    }
    
    func fetchSimilarData(with id: Int) {
        itemsService.fetchSimilar(language: language, page: page, id: id, completion: handleApiResults)
    }
    
    private func handleApiResults(_ results: Result<[ItemViewModel], ErrorHandling>) {
        switch results {
        case .success(let list):
            result.value.append(contentsOf: list)
        case .failure(let error):
            print(error)
        }
    }
}
