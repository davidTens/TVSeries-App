//
//  Adapters.swift
//  TVSeries App
//
//  Created by David T on 7/7/21.
//

import Foundation


struct SeriesServices: ItemsService {
    
    let api: ApiService
    
    init(_ api: ApiService) {
        self.api = api
    }
    
    func fetchData(language: String, page: Int, completion: @escaping (Result<[ItemViewModel], ErrorHandling>) -> Void) {
        api.get(endpoint: NetworkConstants.popularTVSeries,
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
    
    func fetchSimilar(language: String, page: Int, id: Int, completion: @escaping (Result<[ItemViewModel], ErrorHandling>) -> Void) {
        api.get(endpoint: "/tv/\(String(id))/similar", language: language, page: page) { (result: Result<TVSeriesGroup, ErrorHandling>) in
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
    
    func fetchSimilar(language: String, page: Int, id: Int, completion: @escaping (Result<[ItemViewModel], ErrorHandling>) -> Void) {
        api.get(endpoint: "/movie/\(String(id))/similar", language: language, page: page) { (result: Result<MoviesGroup, ErrorHandling>) in
            completion( result.map { item in
                return item.results.map { item in
                    ItemViewModel(item)
                }
            })
        }
    }
}
