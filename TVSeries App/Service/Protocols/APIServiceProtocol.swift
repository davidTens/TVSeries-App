//
//  APIServiceProtocol.swift
//  TVSeries App
//
//  Created by David T on 7/19/21.
//

import Foundation

protocol APIService {
    func fetchItems(endpoint: String, language: String, page: Int, query: String?, completion: @escaping (Result<[ItemViewModel], ErrorHandling>) -> Void)
}
