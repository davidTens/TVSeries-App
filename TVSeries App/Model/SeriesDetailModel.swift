//
//  SeriesDetailModel.swift
//  TVSeries App
//
//  Created by David T on 7/27/21.
//

import Foundation

public struct SerieDetailModel: Decodable, Hashable {
    
    let id: Int
    let name: String
    let overview: String
    let backdrop_path: String?
    let first_air_date: String
    let origin_country: Array<String>
    let original_language: String
    let vote_average: Decimal
}

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
