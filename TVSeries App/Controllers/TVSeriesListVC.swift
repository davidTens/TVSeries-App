//
//  MoviesListVC.swift
//  TV Series App
//
//  Created by David T on 3/18/21.
//

import UIKit

final class TVSeriesListVC: UITableViewController, UISearchControllerDelegate {
    
    private var tvSeries = [TVSeries]()
    private var searchTVSeries = [TVSeries]()
    private let cellId = "cellId"
    private var customRefreshControl = UIRefreshControl()
    private let searchController = UISearchController(searchResultsController: nil)
    
    private lazy var dataSource = makeDataSource()
    
    private lazy var page = 1
    private lazy var language = "en-US"
    private lazy var isLoading = false
    private lazy var deviceModelId = [
        "iPhone 6 Plus",
        "iPhone 6s Plus",
        "iPhone 7 Plus",
        "iPhone 8 Plus"
    ]
    
    private var errorMessageView: ErrorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        customRefreshControl.tintColor = dynamicSubColors
        customRefreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(customRefreshControl)
        
        navigationItem.title = "TV Series"
        view.backgroundColor = dynamicBackgroundColors
        navigationController?.navigationBar.tintColor = dynamicSubColors
        
        searchControllerSetUp()
        
        tableView.register(TVSeriesListCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
        getSeries(type: "popular", language: language, page: page)
        errorMessageAppear()
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
    
    private func getSeries(type: StringIntProtocol, language: String, page: Int) {
        isLoading = true
        customRefreshControl.beginRefreshing()
        
        NetworkRequest.shared.getTvSeries(type: type, tv: "tv", similar: nil, search: nil, query: nil, language: language, page: page) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                
                switch result {
                case .success(let list):
                    
                    print(list.results.count)
                    
//                    self.tvSeries.append(contentsOf: list.results)
                    self.update(with: list)
                    print("snapshot - \(self.dataSource.snapshot().numberOfItems)")
                    self.errorMessageView.isHidden = true
                    self.tableView.reloadData()
                    
                case .failure(let error):
                    self.page += 1
                    self.errorMessageView.isHidden = false
                    self.errorMessageView.errorMessageLabel.text = error.rawValue
                }
                self.customRefreshControl.endRefreshing()
                self.isLoading = false
            }
            
        }
    }
    
    fileprivate func updateSeries(type: StringIntProtocol, language: String, page: Int, query: String) {
        
        customRefreshControl.beginRefreshing()
        isLoading = true
        
        NetworkRequest.shared.getTvSeries(type: type, tv: nil, similar: nil, search: "search", query: query, language: language, page: page) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                
                switch result {
                case .success(let list):
                    
                    self.searchTVSeries.append(contentsOf: list.results)
                    self.errorMessageView.isHidden = true
                    self.tableView.reloadData()
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    self.errorMessageView.isHidden = false
                    self.errorMessageView.errorMessageLabel.text = error.rawValue
                }
                self.isLoading = false
                self.customRefreshControl.endRefreshing()
            }
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
        if searchTVSeries.count > 0 {
            searchTVSeries.removeAll()
            tableView.reloadData()
        }
    }
    
    @objc private func errorMessageDissapear() {
        errorMessageView.removeFromSuperview()
    }
    
    func pushToDetailView(tvId: TVSeries) {
        let detailViewController = SerieDetailVC()
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
        if tvSeries.count > 0 || searchTVSeries.count > 0 {
            searchTVSeries.removeAll()
            tvSeries.removeAll()
            tableView.reloadData()
        }
        updateSeries(type: "tv", language: language, page: 1, query: "&query=" + query!.replacingOccurrences(of: " ", with: "%20"))
    }
    
}

extension TVSeriesListVC: UISearchBarDelegate {

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if searchController.isActive && searchController.searchBar.text != "" { }
        else {
            if isLoading == false {
                if indexPath.row + 1 == dataSource.snapshot().numberOfItems {
                    page += 1
                    getSeries(type: "popular", language: language, page: page)
                    print("kaboom")
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let serieId = dataSource.itemIdentifier(for: indexPath) else { return }
        pushToDetailView(tvId: serieId)
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


private extension TVSeriesListVC {
    func makeDataSource() -> UITableViewDiffableDataSource<Section, TVSeries> {
        let id = cellId
        return UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, series in
            let cell = tableView.dequeueReusableCell(withIdentifier: id) as! TVSeriesListCell
            cell.tvSeries = self.dataSource.itemIdentifier(for: indexPath)
            return cell
        }
    }
}

extension TVSeriesListVC {
    enum Section: CaseIterable {
        case first
    }
    
    func update(with list: TVSeriesGroup, animate: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, TVSeries>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(list.results)
        dataSource.apply(snapshot, animatingDifferences: animate)
    }
}
