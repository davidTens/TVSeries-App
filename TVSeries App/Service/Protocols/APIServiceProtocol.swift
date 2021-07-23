//
//  APIServiceProtocol.swift
//  TVSeries App
//
//  Created by David T on 7/19/21.
//

import Foundation

protocol ItemsService {
    func fetchData(language: String, page: Int, completion: @escaping (Result<[ItemViewModel], ErrorHandling>) -> Void)
    func searchData(language: String, page: Int, query: String?, completion: @escaping (Result<[ItemViewModel], ErrorHandling>) -> Void)
    func fetchSimilar(language: String, page: Int, id: Int, completion: @escaping (Result<[ItemViewModel], ErrorHandling>) -> Void)
}
