//
//  TVSeriesListExtension.swift
//  TV Series App
//
//  Created by David T on 3/25/21.
//

import Foundation
import UIKit

extension TVSeriesListVC: UISearchBarDelegate {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive && searchController.searchBar.text != "" ? searchTVSeries.count : tvSeries.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if searchController.isActive && searchController.searchBar.text != "" { }
        else {
            if isLoading == false {
                if indexPath.row + 1 == tvSeries.count {
                    page += 1
                    getSeries(type: "popular", language: language, page: page)
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! TVSeriesListCell
        cell.backgroundColor = .clear
        if searchController.isActive && searchController.searchBar.text != "" {
            let tvSeriesId = searchTVSeries[indexPath.row]
            cell.tvSeries = tvSeriesId
        } else {
            let tvSeriesId = tvSeries[indexPath.row]
            cell.tvSeries = tvSeriesId
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchController.isActive && searchController.searchBar.text != "" {
            let seriesId = searchTVSeries[indexPath.row]
            pushToDetailView(tvId: seriesId)
        } else {
            let seriesId = tvSeries[indexPath.row]
            pushToDetailView(tvId: seriesId)
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if searchTVSeries.count >= 0 {
            searchTVSeries.removeAll()
            tableView.reloadData()
            page = 1
            getSeries(type: "popular", language: language, page: page)
        }
        
        noResultsLabel.removeFromSuperview()
        searchBar.text = nil
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchController.isActive && searchController.searchBar.text != "" {
            searchTextChanged(query: searchBar.text)
        }
        searchBar.resignFirstResponder()
    }

}
