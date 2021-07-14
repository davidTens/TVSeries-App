//
//  APIService.swift
//  TVSeries App
//
//  Created by David T on 7/7/21.
//

import Foundation

protocol APIService {
    func fetchItems(endpoint: String, language: String, page: Int, query: String?, completion: @escaping (Result<[ItemViewModel], ErrorHandling>) -> Void)
}

struct SeriesAdapter: APIService {
    let api: TVSeriesAPI
    let selectSeries: (TVSeries) -> Void
    
    func fetchItems(endpoint: String, language: String, page: Int, query: String?, completion: @escaping (Result<[ItemViewModel], ErrorHandling>) -> Void) {
        api.fetchSeries(endpoint: endpoint, language: language, page: page, query: query) { result in
            completion( result.map { item in
                return item.results.map { item in
                    ItemViewModel(item) {
                        selectSeries(item)
                    }
                }
            })
        }
    }
}

struct MoviesAdapter: APIService {
    let api: MoviesAPI
    let select: (Movie) -> Void
    
    func fetchItems(endpoint: String, language: String, page: Int, query: String?, completion: @escaping (Result<[ItemViewModel], ErrorHandling>) -> Void) {
        api.fetchMovies(endpoint: endpoint, language: language, page: page, query: query) { result in
            completion( result.map { item in
                return item.results.map { item in
                    ItemViewModel(item) {
                        select(item)
                    }
                }
            })
        }
    }
}


