//
//  SeriesViewController.swift
//  TVSeries App
//
//  Created by David on 7/22/21.
//

import UIKit
import Combine

final class ItemsViewController: BaseViewController  {
    
    private let cellId = "cellId"
    private let viewModel: ItemsViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
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
        searchTextField.placeholder = viewModel.makeSearchTextFieldPlaceholder()
    }
    
    private func bindViewModel() {
//        viewModel.result.bind { [weak self] _ in
//            DispatchQueue.main.async {
//                self?.tableView.reloadData()
//                self?.customRefreshControl.endRefreshing()
//                self?.hideErrorView()
//            }
//        }
        
        viewModel.items
            .receive(on: RunLoop.main)
            .sink { [weak self] items in
                self?.tableView.reloadData()
                self?.customRefreshControl.endRefreshing()
                self?.hideErrorView()
            }
            .store(in: &cancellables)
        
        viewModel.shouldReloadTableView
            .receive(on: RunLoop.main)
            .sink { [weak self]  in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
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
    
    var appCordinator: AppCoordinator?
    var navigationRouter: NavigationRouter?
    
    @objc private func refresh() {
        viewModel.refresh()
        customRefreshControl.endRefreshing()
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


//extension ItemsViewController: Navigator {
//    func navigate(itemViewModel: ItemViewModel) {
//        switch viewModel.type {
//        case .tvSeries:
//            navigate(viewModel: DetailFactory.makeDetailViewModelForSeries(), itemViewModel: itemViewModel)
//        case .movies:
//            navigate(viewModel: DetailFactory.makeDetailViewModelForMovies(), itemViewModel: itemViewModel)
//        }
//    }
//}


extension ItemsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.makeNumberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.selectedIndexPath.send(indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MainListCell
        let serie = viewModel.getItemAtIndex(indexPath: indexPath)
        cell.configure(serie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.moveToNewPageIfNeeded(indexPath: indexPath)
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
            viewModel.performSearch(textField.text)
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        viewModel.clearTableViewIfNeeded()
        hideErrorView()
        textField.text = nil
        textField.resignFirstResponder()
        return false
    }
}
