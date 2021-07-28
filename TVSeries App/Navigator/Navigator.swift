//
//  Navigator.swift
//  TVSeries App
//
//  Created by David T on 7/9/21.
//

import Foundation

protocol Navigator {
    func navigate(id: Int)
}

protocol SelectionValue {
    func scrollToIndex(_ index: Int)
}
