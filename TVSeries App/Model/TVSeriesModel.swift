//
//  TVSeriesModel.swift
//  TV Series App
//
//  Created by David T on 3/28/21.
//

import Foundation

struct TVSeries: Decodable {
    
    let poster_path: String?
    let popularity: Double
    let id: Int
    let backdrop_path: String?
    let vote_average: Decimal
    let overview: String
    let first_air_date: String
    let origin_country: Array<String>
    let genre_ids: Array<Int>
    let original_language: String
    let vote_count: Int
    let name: String
    let original_name: String
}
