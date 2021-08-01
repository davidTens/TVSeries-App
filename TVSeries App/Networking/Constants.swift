//
//  Constants.swift
//  TVSeries App
//
//  Created by David T on 7/9/21.
//

import UIKit

public struct Constants {
    static let dynamicSubColors = UIColor.black | UIColor.white
    static let dynamicBackgroundColors = UIColor.white | UIColor(hexFromString: "#37373C")
    static let deviceModelId = ["iPhone 6 Plus", "iPhone 6s Plus", "iPhone 7 Plus", "iPhone 8 Plus"]
    static let descriptionData = ["Overview", "Name", "First Air", "Countries", "Language"]
}

public struct NetworkConstants {
    static let baseURL = "https://api.themoviedb.org/3"
    static let apiKey = "7481bbcf1fcb56bd957cfe9af78205f3"
    static let topRatedTVSeries = "/tv/top_rated"
    static let searchTVPath = "/search/tv"
    static let posterPath = "https://image.tmdb.org/t/p/w500"
    static let moviesTopRated = "/movie/top_rated"
    static let searchMovies = "/search/movie"
    static let tvDetail = "/tv/"
    static let movieDetail = "/movie/"
}
