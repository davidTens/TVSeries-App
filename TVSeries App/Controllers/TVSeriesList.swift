//
//  MoviesListVC.swift
//  TV Series App
//
//  Created by David T on 3/18/21.
//

import UIKit

protocol Navigator {
    func navigate(_ id: TVSeries)
}

final class TVSeriesList: UITableViewController, UISearchControllerDelegate, Navigator {
    
    private let cellId = "cellId"
    private var customRefreshControl = UIRefreshControl()
    private let searchController = UISearchController(searchResultsController: nil)
    
//    private lazy var dataSource = makeDataSource()
    
    private var viewModel: SeriesViewModel!
    private var searchViewModel: SearchViewModel!
    private var api: APIService?
    
    private lazy var deviceModelId = [
        "iPhone 6 Plus",
        "iPhone 6s Plus",
        "iPhone 7 Plus",
        "iPhone 8 Plus"
    ]
    
    private var errorMessageView: ErrorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.dataSource = dataSource
        uiStaff()
        errorMessageAppear()
        
        
        
        viewModel = SeriesViewModel(NetworkRequest.shared)
        searchViewModel = SearchViewModel(NetworkRequest.shared)
        viewModel.delegate = self
        searchViewModel.delegate = self
        bindViewModel()
        customRefreshControl.beginRefreshing()
        viewModel?.fetchSeries()
    }
    
    private func uiStaff() {
        customRefreshControl.tintColor = dynamicSubColors
        customRefreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(customRefreshControl)
        
        navigationItem.title = "TV Series"
        view.backgroundColor = dynamicBackgroundColors
        navigationController?.navigationBar.tintColor = dynamicSubColors
        
        searchControllerSetUp()
        
        tableView.register(TVSeriesListCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
    }
    
    private func bindViewModel() {
        viewModel.list.bind { [weak self] _ in
            self?.tableView.reloadData()
            self?.customRefreshControl.endRefreshing()
        }
        searchViewModel.list.bind { [weak self] value in
            self?.tableView.reloadData()
            self?.customRefreshControl.endRefreshing()
        }
    }
    
    func navigate(_ id: TVSeries) {
        pushToDetailView(tvId: id)
    }
    
    fileprivate func searchControllerSetUp() {
        
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
            navigationItem.searchController = searchController
        } else {
            navigationItem.titleView = searchController.searchBar
        }
    }
    
    private func errorMessageAppear() {
        errorMessageView = ErrorView()
        errorMessageView.isHidden = true
        view.addSubview(errorMessageView)
        
        if #available(iOS 11.0, *) {
            errorMessageView.layout(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, size: .init(width: 0, height: 45))
        } else {
            errorMessageView.layout(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 45))
        }
    }
    
    @objc private func noResultsLabelDissapear() {
        if searchViewModel.list.value.count > 0 {
            searchViewModel.list.value.removeAll()
            tableView.reloadData()
        }
    }
    
    @objc private func errorMessageDissapear() {
        errorMessageView.removeFromSuperview()
    }
    
    func pushToDetailView(tvId: TVSeries) {
        let detailViewController = SerieDetail()
        detailViewController.tvSerieId = tvId
        
        if UIDevice.current.userInterfaceIdiom == .pad || deviceModelId.contains(UIDevice.current.modelName) && UIDevice.current.orientation == .landscapeRight || UIDevice.current.orientation == .landscapeLeft {
            let rootViewController = UINavigationController(rootViewController: detailViewController)
            showDetailViewController(rootViewController, sender: self)
        } else {
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
    @objc func refresh() {
        customRefreshControl.endRefreshing()
    }
    
    func searchTextChanged(query: String?) {
        if viewModel.list.value.count > 0 || searchViewModel.list.value.count > 0 {
            viewModel.list.value.removeAll()
            searchViewModel.list.value.removeAll()
            tableView.reloadData()
        }
        searchViewModel?.searchSeries(query: query!)
        tableView.reloadData()
    }
    
}

// MARK: - EXTENSIONS

extension TVSeriesList: UISearchBarDelegate {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive && searchController.searchBar.text != "" ? searchViewModel.list.value.count : viewModel.list.value.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if searchController.isActive && searchController.searchBar.text != "" {
            if indexPath.row + 1 == searchViewModel.list.value.count {
            searchViewModel.page += 1
            searchViewModel.searchSeries(query: searchController.searchBar.text!)
            }
        }
        else {
            if indexPath.row + 1 == viewModel.list.value.count {
            viewModel.page += 1
            viewModel.fetchSeries()
                
        }
    }
}
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! TVSeriesListCell
                cell.backgroundColor = .clear
                if searchController.isActive && searchController.searchBar.text != "" {
                    let series = searchViewModel.list.value[indexPath.row]
                    cell.configure(series)
                } else {
                    let series = viewModel.list.value[indexPath.row]
                    cell.configure(series)
                }
                return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let serieId = dataSource.itemIdentifier(for: indexPath) else { return }
        if searchController.isActive && searchController.searchBar.text != "" {
            let serie = searchViewModel.list.value[indexPath.row]
            serie.select()
        } else {
            let item = viewModel.list.value[indexPath.row]
            item.select()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if searchViewModel.list.value.count >= 0 {
            searchViewModel.list.value.removeAll()
            tableView.reloadData()
//            page = 1
//            getSeries(type: "popular", language: language, page: page)
            viewModel.fetchSeries()
        }
        
        errorMessageView.isHidden = true
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

extension UIViewController {
    func select(series: TVSeries) {
        let detailController = SerieDetail()
        detailController.tvSerieId = series
        navigationController?.pushViewController(detailController, animated: true)
    }
}


//private extension TVSeriesListVC {
//    func makeDataSource() -> UITableViewDiffableDataSource<Section, TVSeries> {
//        let id = cellId
//        return UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, series in
//            let cell = tableView.dequeueReusableCell(withIdentifier: id) as! TVSeriesListCell
//            cell.tvSeries = self.dataSource.itemIdentifier(for: indexPath)
//            return cell
//        }
//    }
//}
//
//extension TVSeriesListVC {
//    enum Section: CaseIterable {
//        case first
//    }
//
//    func update(with list: TVSeriesGroup, animate: Bool = true) {
//        var snapshot = NSDiffableDataSourceSnapshot<Section, TVSeries>()
//        snapshot.appendSections(Section.allCases)
//        snapshot.appendItems(list.results)
//        dataSource.apply(snapshot, animatingDifferences: animate)
//    }
//}
