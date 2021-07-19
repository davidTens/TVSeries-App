//
//  SeriesCell.swift
//  TVSeries App
//
//  Created by David T on 7/16/21.
//

import UIKit

final class SeriesCell: BaseCell {
    private let cellId = "cellId"
    
    private var viewModel: SeriesViewModel!
    private var searchViewModel: SearchSeriesViewModel!
    lazy var homeController = HomeViewController()
    
    override func setup() {
        super.setup()
        searchTextField.delegate = self
        searchTextField.placeholder = "Search TV Series"
        tableView.register(MainListCell.self, forCellReuseIdentifier: cellId)
        tableView.delegate = self
        tableView.dataSource = self
        
        customRefreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        viewModel = SeriesViewModel(TVSeriesAPI.shared)
        searchViewModel = SearchSeriesViewModel(TVSeriesAPI.shared)
        viewModel.delegate = self
        searchViewModel.delegate = self
        bindViewModel()
        customRefreshControl.beginRefreshing()
        viewModel.fetchSeries()
    }
    
    private func bindViewModel() {
        viewModel.result.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.customRefreshControl.endRefreshing()
            }
        }
        
        searchViewModel.result.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.errorView.isHidden = true
                self?.tableView.reloadData()
            }
        }
        viewModel.serviceState.bind { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .error(let error):
                    self?.errorView.isHidden = false
                    self?.errorView.errorMessageLabel.text = error
                case .loading, .finished:
                    break
                }
            }
        }
        searchViewModel.serviceState.bind { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .error(_):
                    self?.errorView.isHidden = false
                    self?.errorView.errorMessageLabel.text = "No results"
                case .loading, .finished:
                    break
                }
            }
        }
    }
    
    @objc private func refresh() {
        customRefreshControl.endRefreshing()
        if searchViewModel.result.value.count == 0 {
            viewModel.refresh()
        }
    }
    
    private func perfromSearch(_ query: String?) {
        if viewModel.result.value.count > 0 || searchViewModel.result.value.count > 0 {
            viewModel.result.value.removeAll()
            searchViewModel.result.value.removeAll()
        }
        searchViewModel.searchSeries(query: query!)
    }
}

extension SeriesCell: SerieNavigator {
    func navigate(to id: TVSeries) {
        let detailViewController = DetailController()
        detailViewController.tvSerieId = id
        
        if UIDevice.current.userInterfaceIdiom == .pad || Constants.deviceModelId.contains(UIDevice.current.modelName) && UIDevice.current.orientation == .landscapeRight || UIDevice.current.orientation == .landscapeLeft {
            let rootViewController = UINavigationController(rootViewController: detailViewController)
            homeController.showDetailViewController(rootViewController, sender: self)
        } else {
            homeController.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}


extension SeriesCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchTextField.text != "" ? searchViewModel.result.value.count : viewModel.result.value.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if searchTextField.text != "" {
            let serie = searchViewModel.result.value[indexPath.row]
            serie.select()
        } else {
            let serie = viewModel.result.value[indexPath.row]
            serie.select()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MainListCell
        if searchTextField.text != "" && viewModel.result.value.count == 0 {
            let serie = searchViewModel.result.value[indexPath.row]
            cell.configure(serie)
        } else {
            let serie = viewModel.result.value[indexPath.row]
            cell.configure(serie)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == viewModel.result.value.count && viewModel.serviceState.value != .loading {
            viewModel.page += 1
            viewModel.fetchSeries()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}


extension SeriesCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isEditing && textField.text != "" {
            perfromSearch(textField.text)
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if searchViewModel.result.value.count >= 0 {
            searchViewModel.result.value.removeAll()
            tableView.reloadData()
            viewModel.page = 1
            viewModel.fetchSeries()
        }
        errorView.isHidden = true
        textField.text = nil
        textField.resignFirstResponder()
        return false
    }
}
