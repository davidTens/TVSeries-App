//
//  MoviesDetailModel.swift
//  TVSeries App
//
//  Created by David T on 7/28/21.
//

import Foundation

public struct MoviesDetailModel: Decodable, Hashable {
    
    let id: Int
    let title: String
    let original_title: String
    let overview: String
    let vote_average: Decimal
    let release_date: String
    let original_language: String
    let poster_path: String
    let backdrop_path: String?
    
}
