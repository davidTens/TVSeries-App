//
//  APIService.swift
//  TV Series App
//
//  Created by David T on 3/22/21.
//

import Foundation

final public class TVSeriesAPI {
    
    public static let shared = TVSeriesAPI()
    
    private init() {}
    
    func fetchSeries(endpoint: String, language: String, page: Int, query: String? = nil, completion: @escaping (Result<TVSeriesGroup, ErrorHandling>) -> Void) {
        
        let finalPath = NetworkConstants.baseURL + endpoint + "?api_key=" + NetworkConstants.apiKey + "&language=" + language + "&page=\(page)\(query ?? "")"
        print(finalPath)
        guard let url = URL(string: finalPath)
        else {
            return completion(.failure(.apiError))
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200
            else {
                completion(.failure(.invalidData))
                return
            }
            
            guard let data = data
            else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let seriesList = try JSONDecoder().decode(TVSeriesGroup.self, from: data)
                completion(.success(seriesList))
                print(seriesList.results.count)
            }
            catch {
                completion(.failure(.invalidData))
            }
        }
        task.resume()
    }
}


final public class MoviesAPI {
    
    public static let shared = MoviesAPI()
    
    private init() {}
    
    func fetchMovies(endpoint: String, language: String, page: Int, query: String? = nil, completion: @escaping (Result<MoviesGroup, ErrorHandling>) -> Void) {
        
        let finalPath = NetworkConstants.baseURL + endpoint + "?api_key=" + NetworkConstants.apiKey + "&language=" + language + "&page=\(page)\(query ?? "")"
        print(finalPath)
        guard let url = URL(string: finalPath)
        else {
            return completion(.failure(.apiError))
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200
            else {
                completion(.failure(.invalidData))
                return
            }
            
            guard let data = data
            else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let moviesList = try JSONDecoder().decode(MoviesGroup.self, from: data)
                completion(.success(moviesList))
            }
            catch {
                completion(.failure(.invalidData))
            }
        }
        task.resume()
    }
}

enum ErrorHandling: String, Error {
    
    case apiError = "Invalid api"
    case invalidResponse = "Invalid response"
    case invalidData = "Invalid Data"
}
