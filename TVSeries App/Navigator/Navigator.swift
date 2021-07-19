//
//  Navigator.swift
//  TVSeries App
//
//  Created by David T on 7/9/21.
//

import Foundation

protocol MovieNavigator {
    func navigate(to id: Movie)
}

protocol SerieNavigator {
    func navigate(to id: TVSeries)
}

protocol SelectionValue {
    func scrollToIndex(_ index: Int)
}

protocol DetailNavigator: MovieNavigator, SerieNavigator { }
