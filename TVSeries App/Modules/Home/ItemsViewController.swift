//
//  SeriesViewController.swift
//  TVSeries App
//
//  Created by David on 7/22/21.
//

import UIKit

final class ItemsViewController: BaseViewController  {
    
    private let cellId = "cellId"
    private let viewModel: ItemsViewModel
    
    init(viewModel: ItemsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        super.setup()
        tableView.register(MainListCell.self, forCellReuseIdentifier: cellId)
        tableView.delegate = self
        tableView.dataSource = self
        searchTextField.delegate = self
        customRefreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        bindViewModel()
        customRefreshControl.beginRefreshing()
        viewModel.fetchData()
        
        switch viewModel.type {
        case .tvSeries:
            searchTextField.placeholder = "Search TV Series"
        case .movies:
            searchTextField.placeholder = "Search Movies"
        }
    }
    
    private func bindViewModel() {
        viewModel.result.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.customRefreshControl.endRefreshing()
                self?.hideErrorView()
            }
        }
        viewModel.serviceState.bind { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .error(let error):
                    self?.displayErrorView()
                    self?.errorView.errorMessageLabel.text = error
                case .loading, .finished:
                    break
                }
            }
        }
    }
    
    @objc private func refresh() {
        viewModel.refresh()
        customRefreshControl.endRefreshing()
    }
    
    private func performSearch(_ query: String?) {
        if viewModel.result.value.count > 0 {
            viewModel.result.value.removeAll()
            tableView.reloadData()
        }
        viewModel.searchData(query!)
    }
    
    private func navigate(viewModel: DetailsViewModel, itemViewModel: ItemViewModel) {
        let detailViewController = DetailController(viewModel: viewModel)
        detailViewController.itemViewModel = itemViewModel

        if UIDevice.current.userInterfaceIdiom == .pad || Constants.deviceModelId.contains(UIDevice.current.modelName) && UIDevice.current.orientation == .landscapeRight || UIDevice.current.orientation == .landscapeLeft {
            let rootViewController = UINavigationController(rootViewController: detailViewController)
            showDetailViewController(rootViewController, sender: self)
        } else {
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}


extension ItemsViewController: Navigator {
    func navigate(itemViewModel: ItemViewModel) {
        switch viewModel.type {
        case .tvSeries:
            navigate(viewModel: DetailFactory.makeDetailViewModelForSeries(), itemViewModel: itemViewModel)
        case .movies:
            navigate(viewModel: DetailFactory.makeDetailViewModelForMovies(), itemViewModel: itemViewModel)
        }
    }
}


extension ItemsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.result.value.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let serie = viewModel.result.value[indexPath.row]
        navigate(itemViewModel: serie)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MainListCell
        let serie = viewModel.result.value[indexPath.row]
        cell.configure(serie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row + 1 == viewModel.result.value.count && viewModel.serviceState.value != .loading {
            viewModel.page += 1
            if searchTextField.text != "" {
                viewModel.searchData(searchTextField.text!)
            } else {
                viewModel.fetchData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

extension ItemsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isEditing && textField.text != "" {
            performSearch(textField.text)
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if viewModel.result.value.count >= 0 {
            viewModel.result.value.removeAll()
            tableView.reloadData()
            viewModel.page = 1
            viewModel.fetchData()
        }
        hideErrorView()
        textField.text = nil
        textField.resignFirstResponder()
        return false
    }
}
