//
//  Navigator.swift
//  TVSeries App
//
//  Created by David T on 7/9/21.
//

import Foundation

protocol Navigator {
    func navigate(to id: TVSeries)
}

protocol SelectionValue {
    func selectionDidChangeValue(to option: String)
}
