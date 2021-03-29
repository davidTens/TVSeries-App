//
//  Model.swift
//  TV Series App
//
//  Created by David T on 3/19/21.
//

import Foundation

struct TVSeriesList: Decodable {
    
    let page: Int
    let results: [TVSeries]
    let total_results: Int
    let total_pages: Int
}




