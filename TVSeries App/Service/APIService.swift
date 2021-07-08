//
//  APIService.swift
//  TVSeries App
//
//  Created by David T on 7/7/21.
//

import Foundation

protocol APIService {
    func fetchSeries(type: StringIntProtocol, tv: String?, similar: String?, search: String?, query: String?, language: String, page: Int, completed: @escaping (Result<[ItemViewModel], ErrorHandling>) -> Void)
}

struct SeriesAdapter: APIService {
    let api: NetworkRequest
    let select: (TVSeries) -> Void
    
    func fetchSeries(type: StringIntProtocol, tv: String?, similar: String?, search: String?, query: String?, language: String, page: Int, completed: @escaping (Result<[ItemViewModel], ErrorHandling>) -> Void) {
        api.fetchSeries(type: type, tv: tv, similar: similar, search: search, query: query, language: language, page: page) { result in
            DispatchQueue.main.async {
                completed( result.map { item in
                    return item.results.map { item in
                        ItemViewModel(item, selection: {
                            select(item)
                        })
                    }
                })
            }
        }
    }
}
