//
//  NetworkRequest.swift
//  TV Series App
//
//  Created by David T on 3/22/21.
//

import Foundation

final public class APICall {
    
    public static let shared = APICall()
    
    private init() {}
    
    func fetchSeries(endpoint: String, language: String, page: Int, query: String?, completion: @escaping (Result<TVSeriesGroup, ErrorHandling>) -> Void) {
        
        let finalPath = NetworkConstants.baseURL + endpoint + "?api_key=" + NetworkConstants.apiKey + "&language=" + language + "&page=\(page)\(query ?? "")"
        
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
            }
            catch {
                completion(.failure(.invalidData))
            }
        }
        task.resume()
    }
}
