//
//  SearchMoviesViewModel.swift
//  TVSeries App
//
//  Created by David T on 7/19/21.
//

import Foundation

final class SearchMoviesViewModel {
    
    private var api: MoviesAPI?
    var delegate: MovieNavigator?
    
    lazy var page = 1
    private lazy var language = "en-US"
    private (set) var result: Bindable<[ItemViewModel]> = Bindable([])
    private (set) var serviceState: Bindable<FetchingServiceState> = Bindable(.loading)
    
    init(_ api: MoviesAPI) {
        self.api = api
    }
    
    func searchMovies(query: String) {
        let adapter = MoviesAdapter(api: MoviesAPI.shared) { [weak self] in
            self?.select(movie: $0)
        }
        serviceState.value = .loading
        let modifiedQuery = "&query=\(query)".replacingOccurrences(of: " ", with: "%20")
        adapter.fetchItems(endpoint: NetworkConstants.searchMovies, language: language, page: page, query: modifiedQuery, completion: handleApiResults(_:))
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

extension SearchMoviesViewModel {
    private func select(movie: Movie) {
        delegate?.navigate(to: movie)
    }
}
