//
//  Binding.swift
//  TVSeries App
//
//  Created by David T on 7/7/21.
//

import Foundation

final class Bindable<T> {
    
    typealias Listener = ((T) -> Void)
    private var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ v: T) {
        self.value = v
    }
    
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
}
