//
//  NetworkRequest.swift
//  TV Series App
//
//  Created by David T on 3/22/21.
//

import Foundation

final class NetworkRequest {
    
    public static let shared = NetworkRequest()
    private let mainURL = "https://api.themoviedb.org/3"
    private let apiKey = "?api_key=7481bbcf1fcb56bd957cfe9af78205f3"
    
    private init() {}
    
    func fetchSeries(type: StringIntProtocol, tv: String?, similar: String?, search: String?, query: String?, language: String, page: Int, completed: @escaping (Result<TVSeriesGroup, ErrorHandling>) -> Void) {
        
        let finalPath = mainURL + "/\(search ?? "")\(tv ?? "")/\(type)/\(similar ?? "")\(apiKey)&language=\(language)&page=\(page)\(query ?? "")"
        print(finalPath)
        guard let url = URL(string: finalPath)
        else {
            return completed(.failure(.apiError))
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200
            else {
                completed(.failure(.invalidData))
                return
            }
            
            guard let data = data
            else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let seriesList = try JSONDecoder().decode(TVSeriesGroup.self, from: data)
                completed(.success(seriesList))
            }
            catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
}


enum Endpoint: String, CustomStringConvertible, CaseIterable {
    case popular
    
    var description: String {
        switch self {
        case .popular: return "Popular"
        }
    }
    
    init?(index: Int) {
        switch index {
        case 0: self = .popular
        default: return nil
        }
    }
}
