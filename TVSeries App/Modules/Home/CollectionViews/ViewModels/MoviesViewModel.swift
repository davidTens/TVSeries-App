//
//  MoviesViewModel.swift
//  TVSeries App
//
//  Created by David T on 7/18/21.
//

import Foundation

final class MoviesViewModel {
    
    private var moviesAPI: MoviesAPI?
    var delegate: MovieNavigator?
    
    lazy var page = 1
    private lazy var language = "en-US"
    private (set) var result: Bindable<[ItemViewModel]> = Bindable([])
    private (set) var serviceState: Bindable<FetchingServiceState> = Bindable(.loading)
    
    init(_ movies: MoviesAPI) {
        self.moviesAPI = movies
    }
    
    func refresh() {
        result.value.count == 0 ? fetchMovies() : print("done")
    }
    
    func fetchMovies() {
        let adapter = MoviesAdapter(api: MoviesAPI.shared, select: { [weak self] in
            self?.select(movie: $0)
        })
        serviceState.value = .loading
        adapter.fetchItems(endpoint: NetworkConstants.moviesTopRated, language: language, page: page, query: nil, completion: handleApiResults(_:))
    }
    
    private func handleApiResults(_ results: Result<[ItemViewModel], ErrorHandling>) {
        switch results {
        case .success(let list):
            result.value.append(contentsOf: list)
        case .failure(let error):
            serviceState.value = .error(error.rawValue)
        }
        serviceState.value = .finished
    }
}

extension MoviesViewModel {
    private func select(movie: Movie) {
        delegate?.navigate(to: movie)
    }
}
