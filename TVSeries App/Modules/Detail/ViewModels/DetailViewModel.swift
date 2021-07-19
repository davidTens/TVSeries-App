//
//  DetailViewModel.swift
//  TVSeries App
//
//  Created by David T on 7/7/21.
//

import Foundation

final class DetailViewModel {
    
    private var seriesAPI: TVSeriesAPI?
    private var moviesAPI: MoviesAPI?
    var delegate: DetailNavigator?
    
    lazy var page = 1
    private lazy var language = "en-US"
    private (set) var response: Bindable<[ItemViewModel]> = Bindable([])
    
    init(_ series: TVSeriesAPI) {
        self.seriesAPI = series
    }
    
    init(_ movies: MoviesAPI) {
        self.moviesAPI = movies
    }
    
    func fetchSimilarSerie(serieId: Int) {
        let adapter = SeriesAdapter(api: TVSeriesAPI.shared) { [weak self] in
            self?.select(serie: $0)
        }
        adapter.fetchItems(endpoint: "/tv/\(String(serieId))/similar", language: language, page: page, query: nil, completion: handleApiResults(_:))
    }
    
    func fetchSimilarMovie(movieId: Int) {
        let adapter = MoviesAdapter(api: MoviesAPI.shared) { [weak self] in
            self?.select(movie: $0)
        }
        adapter.fetchItems(endpoint: "/movie/\(String(movieId))/similar", language: language, page: page, query: nil, completion: handleApiResults(_:))
    }
    
    private func handleApiResults(_ results: Result<[ItemViewModel], ErrorHandling>) {
        switch results {
        case .success(let list):
            response.value.append(contentsOf: list)
        case .failure(let error):
            print(error)
        }
    }
}

extension DetailViewModel {
    private func select(serie: TVSeries) {
        delegate?.navigate(to: serie)
    }
    
    private func select(movie: Movie) {
        delegate?.navigate(to: movie)
    }
}
