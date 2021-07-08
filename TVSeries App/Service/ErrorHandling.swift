//
//  ErrorHandling.swift
//  TV Series App
//
//  Created by David T on 3/22/21.
//

import Foundation

enum ErrorHandling: String, Error {
    
    case apiError = "Invalid api"
    case invalidResponse = "Invalid response"
    case invalidData = "Invalid Data"
}
