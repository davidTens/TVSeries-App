//
//  Adapters.swift
//  TVSeries App
//
//  Created by David T on 7/7/21.
//

import Foundation

protocol ItemsService {
    func fetchData(language: String, page: Int, completion: @escaping (Result<[ItemViewModel], ErrorHandling>) -> Void)
    func searchData(language: String, page: Int, query: String?, completion: @escaping (Result<[ItemViewModel], ErrorHandling>) -> Void)
}

struct SeriesServices: ItemsService {
    
    let api: ApiService
    
    init(_ api: ApiService) {
        self.api = api
    }
    
    func fetchData(language: String, page: Int, completion: @escaping (Result<[ItemViewModel], ErrorHandling>) -> Void) {
        api.get(endpoint: NetworkConstants.topRatedTVSeries,
                       language: language, page: page, query: nil) { (result: Result<TVSeriesGroup, ErrorHandling>) in
            completion( result.map { item in
                return item.results.map { item in
                    ItemViewModel(item)
                }
            })
        }
    }
    
    func searchData(language: String, page: Int, query: String?, completion: @escaping (Result<[ItemViewModel], ErrorHandling>) -> Void) {
        api.get(endpoint: NetworkConstants.searchTVPath,
                       language: language, page: page, query: query) { (result: Result<TVSeriesGroup, ErrorHandling>) in
            completion( result.map { item in
                return item.results.map { item in
                    ItemViewModel(item)
                }
            })
        }
    }
}

struct MoviesServices: ItemsService {
    
    let api: ApiService
    
    init(_ api: ApiService) {
        self.api = api
    }
    
    func fetchData(language: String, page: Int, completion: @escaping (Result<[ItemViewModel], ErrorHandling>) -> Void) {
        api.get(endpoint: NetworkConstants.moviesTopRated,
                       language: language, page: page, query: nil) { (result: Result<MoviesGroup, ErrorHandling>) in
            completion( result.map { item in
                return item.results.map { item in
                    ItemViewModel(item)
                }
            })
        }
    }
    
    func searchData(language: String, page: Int, query: String?, completion: @escaping (Result<[ItemViewModel], ErrorHandling>) -> Void) {
        api.get(endpoint: NetworkConstants.searchMovies,
                       language: language, page: page, query: query) { (result: Result<MoviesGroup, ErrorHandling>) in
            completion( result.map { item in
                return item.results.map { item in
                    ItemViewModel(item)
                }
            })
        }
    }
}
