//
//  ViewModel.swift
//  TVSeries App
//
//  Created by David T on 7/7/21.
//

import Foundation

final class HomeViewModel {
    
    private var seriesAPI: TVSeriesAPI?
    private var moviesAPI: MoviesAPI?
    var delegate: Navigator?
    
    lazy var page = 1
    lazy var optionSelected = Bool()
    private lazy var language = "en-US"
    private (set) var response: Bindable<[ItemViewModel]> = Bindable([])
    private (set) var serviceState: Bindable<FetchingServiceState> = Bindable(.loading)
    
    init(_ series: TVSeriesAPI) {
        self.seriesAPI = series
    }
    
    init(_ movies: MoviesAPI) {
        self.moviesAPI = movies
    }
    
    func refresh() {
        response.value.count == 0 ? fetchSeries() : print("done")
    }
    
    func fetchSelectedOption(moviesSelected: Bool) {
        optionSelected = moviesSelected
        
        if moviesSelected == false {
            if response.value.count == 0 {
                fetchSeries()
            } else if response.value.count > 0 {
                response.value.removeAll()
                page = 1
                fetchSeries()
            }
        } else {
            if response.value.count > 0 {
                response.value.removeAll()
                page = 1
                fetchMovies()
            }
        }
    }
    
    func fetchSeries() {
        let adapter = SeriesAdapter(api: TVSeriesAPI.shared, selectSeries: { [weak self] in
            self?.select(serie: $0)
        })
        serviceState.value = .loading
        adapter.fetchItems(endpoint: NetworkConstants.popularTVSeries, language: language, page: page, query: nil, completion: handleApiResults(_:))
    }
    
    func fetchMovies() {
        let adapter = MoviesAdapter(api: MoviesAPI.shared) { [weak self] in
            self?.select(movie: $0)
        }
        adapter.fetchItems(endpoint: NetworkConstants.movies, language: language, page: page, query: nil, completion: handleApiResults(_:))
    }
    
    private func handleApiResults(_ results: Result<[ItemViewModel], ErrorHandling>) {
        switch results {
        case .success(let list):
            response.value.append(contentsOf: list)
        case .failure(let error):
            serviceState.value = .error(error.rawValue)
        }
        serviceState.value = .finished
    }
}

extension HomeViewModel {
    private func select(serie: TVSeries) {
        delegate?.navigate(to: serie)
    }
    
    private func select(movie: Movie) {
        delegate?.navigate(to: movie)
    }
}
