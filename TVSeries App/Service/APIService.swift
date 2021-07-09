//
//  APIService.swift
//  TVSeries App
//
//  Created by David T on 7/7/21.
//

import Foundation

protocol APIService {
    func fetchSeries(endpoint: String, language: String, page: Int, query: String?, completion: @escaping (Result<[ItemViewModel], ErrorHandling>) -> Void)
}

struct SeriesAdapter: APIService {
    let api: APICall
    let select: (TVSeries) -> Void
    
    func fetchSeries(endpoint: String, language: String, page: Int, query: String?, completion: @escaping (Result<[ItemViewModel], ErrorHandling>) -> Void) {
        api.fetchSeries(endpoint: endpoint, language: language, page: page, query: query) { result in
            completion( result.map { item in
                return item.results.map { item in
                    ItemViewModel(item, selection: {
                        select(item)
                    })
                }
            })
        }
    }
}
