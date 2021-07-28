//
//  DetailServices.swift
//  TVSeries App
//
//  Created by David T on 7/26/21.
//

import Foundation

protocol DetailService {
    func fetchData(id: Int, language: String, page: Int, completion: @escaping (Result<DetailViewModel, ErrorHandling>) -> Void)
    func fetchSimilar(language: String, page: Int, id: Int, completion: @escaping (Result<[ItemViewModel], ErrorHandling>) -> Void)
}

struct SeriesDetailService: DetailService {
    let api: ApiService
    
    init(_ api: ApiService) {
        self.api = api
    }
    
    func fetchData(id: Int, language: String, page: Int, completion: @escaping (Result<DetailViewModel, ErrorHandling>) -> Void) {
        api.get(endpoint: NetworkConstants.tvDetail + String(id),
                       language: language, page: page, query: nil) { (result: Result<SerieDetailModel, ErrorHandling>) in
            completion( result.map { item in
                return DetailViewModel(item)
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

struct MoviesDetailService: DetailService {
    let api: ApiService
    
    init(_ api: ApiService) {
        self.api = api
    }
    
    func fetchData(id: Int, language: String, page: Int, completion: @escaping (Result<DetailViewModel, ErrorHandling>) -> Void) {
        api.get(endpoint: NetworkConstants.movieDetail + String(id),
                       language: language, page: page, query: nil) { (result: Result<MoviesDetailModel, ErrorHandling>) in
            completion( result.map { item in
                return DetailViewModel(item)
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
