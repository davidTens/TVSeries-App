//
//  Navigator.swift
//  TVSeries App
//
//  Created by David T on 7/9/21.
//

import Foundation

protocol Navigator {
    func navigate(to id: TVSeries)
    func navigate(to id: Movie)
}

protocol SelectionValue {
    func moviesSelected(_ bool: Bool)
}
