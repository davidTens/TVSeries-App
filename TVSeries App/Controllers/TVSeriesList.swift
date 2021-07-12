//
//  MoviesListVC.swift
//  TV Series App
//
//  Created by David T on 3/18/21.
//

import UIKit

final class TVSeriesList: UITableViewController {
    
    private let cellId = "cellId"
    private var viewModel: SeriesViewModel!
    private var searchViewModel: SearchViewModel!
    
    private var customRefreshControl = UIRefreshControl()
    private let searchController = UISearchController(searchResultsController: nil)
    private var errorMessageView: ErrorView!
    private lazy var horizontalSelectionView: HorizontalSelectionView = {
        let horizontalSelectionView = HorizontalSelectionView()
        horizontalSelectionView.delegate = self
        return horizontalSelectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interfaceSetUp()
        viewModel = SeriesViewModel(APICall.shared)
        searchViewModel = SearchViewModel(APICall.shared)
        viewModel.delegate = self
        searchViewModel.delegate = self
        bindViewModel()
        customRefreshControl.beginRefreshing()
        viewModel?.fetchSeries()
    }
    
    private func interfaceSetUp() {
        navigationItem.title = "Home"
        view.backgroundColor = Constants.dynamicBackgroundColors
        navigationController?.navigationBar.tintColor = Constants.dynamicSubColors
        
        customRefreshControl.tintColor = Constants.dynamicSubColors
        customRefreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(customRefreshControl)
        
        tableView.register(TVSeriesListCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
        
        errorMessageView = ErrorView()
        errorMessageView.isHidden = true
        view.addSubview(errorMessageView)
        errorMessageView.layout(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, size: .init(width: 0, height: 45))
        
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.searchController = searchController
        searchController.searchBar.backgroundImage = UIImage()
    }
    
    private func bindViewModel() {
        viewModel.response.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.customRefreshControl.endRefreshing()
            }
        }
        searchViewModel.response.bind { [weak self] value in
            DispatchQueue.main.async {
                self?.errorMessageView.isHidden = true
                self?.tableView.reloadData()
                self?.customRefreshControl.endRefreshing()
            }
        }
        searchViewModel.serviceState.bind { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .error(_):
                    self?.errorMessageView.isHidden = false
                    self?.errorMessageView.errorMessageLabel.text = "No results"
                case .loading, .finished:
                    break
                }
            }
        }
    }
    
    @objc private func refresh() {
        customRefreshControl.endRefreshing()
        viewModel.refresh()
    }
    
    private func searchTextChanged(query: String?) {
        if viewModel.response.value.count > 0 || searchViewModel.response.value.count > 0 {
            viewModel.response.value.removeAll()
            searchViewModel.response.value.removeAll()
        }
        searchViewModel?.searchSeries(query: query!)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPosition = scrollView.contentOffset.y
        if yPosition != 90 && yPosition != -44 && yPosition > -44 {
            // do something
        }
        
        if scrollView == tableView {
            if tableView.rectForHeader(inSection: 0).origin.y <= tableView.contentOffset.y + CGFloat(50.0) && tableView.rectForHeader(inSection: 0).origin.y <= tableView.contentOffset.y + CGFloat(50.0) {
//                navigationController?.navigationBar.tintColor = Constants.dynamicBackgroundColors
//                navigationController?.navigationBar.isTranslucent = false
            }
        }
    }
    
}

// MARK: - EXTENSIONS

extension TVSeriesList: Navigator, SelectionValue {
    func selectionDidChangeValue(to option: String) {
        print(option)
    }
    
    func navigate(to id: TVSeries) {
        let detailViewController = SerieDetail()
        detailViewController.tvSerieId = id
        
        if UIDevice.current.userInterfaceIdiom == .pad || Constants.deviceModelId.contains(UIDevice.current.modelName) && UIDevice.current.orientation == .landscapeRight || UIDevice.current.orientation == .landscapeLeft {
            let rootViewController = UINavigationController(rootViewController: detailViewController)
            showDetailViewController(rootViewController, sender: self)
        } else {
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}

extension TVSeriesList: UISearchControllerDelegate, UISearchBarDelegate {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive && searchController.searchBar.text != "" ? searchViewModel.response.value.count : viewModel.response.value.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return horizontalSelectionView
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if searchController.isActive && searchController.searchBar.text != "" { }
        else {
            if indexPath.row + 1 == viewModel.response.value.count && viewModel.serviceState.value != .loading {
                viewModel.page += 1
                viewModel.fetchSeries()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! TVSeriesListCell
        if searchController.isActive && searchController.searchBar.text != "" {
            let id = searchViewModel.response.value[indexPath.row]
            cell.configure(id)
        } else {
            let id = viewModel.response.value[indexPath.row]
            cell.configure(id)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchController.isActive && searchController.searchBar.text != "" {
            let serie = searchViewModel.response.value[indexPath.row]
            serie.select()
        } else {
            let item = viewModel.response.value[indexPath.row]
            item.select()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if searchViewModel.response.value.count >= 0 {
            searchViewModel.response.value.removeAll()
            tableView.reloadData()
            viewModel.page = 1
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
