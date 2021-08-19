//
//  APIService.swift
//  TV Series App
//
//  Created by David T on 3/22/21.
//

import Foundation

protocol APIClient: AnyObject {
    func get<T: Decodable> (endpoint: String, language: String, page: Int, query: String?, completion: @escaping (Result<T, ErrorHandling>) -> Void)
}

final class ApiService: APIClient {
    
    func get<T>(endpoint: String, language: String, page: Int, query: String? = nil, completion: @escaping (Result<T, ErrorHandling>) -> Void) where T: Decodable {
        
        let finalPath = NetworkConstants.baseURL + endpoint + "?api_key=" + NetworkConstants.apiKey + "&language=" + language + "&page=\(page)\(query ?? "")"
        print("API: \(finalPath)")
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
                let items = try JSONDecoder().decode(T.self, from: data)
                completion(.success(items))
            }
            catch {
                completion(.failure(.invalidData))
                print(error)
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
