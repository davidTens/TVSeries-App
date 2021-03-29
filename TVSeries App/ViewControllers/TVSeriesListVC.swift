//
//  MoviesListVC.swift
//  TV Series App
//
//  Created by David T on 3/18/21.
//

import UIKit

final class TVSeriesListVC: UITableViewController, UISearchControllerDelegate {
    
    var tvSeries = [TVSeries]()
    var searchTVSeries = [TVSeries]()
    
    let cellId = "cellId"
    private var customRefreshControl = UIRefreshControl()
    let searchController = UISearchController(searchResultsController: nil)
    
    lazy var page = 1
    lazy var language = "en-US"
    
    lazy var isLoading = false
    
    private lazy var deviceModelId = [
        "iPhone 6 Plus",
        "iPhone 6s Plus",
        "iPhone 7 Plus",
        "iPhone 8 Plus"
    ]
    
    lazy var errorMessageLabel: UILabel = {
        let errorMessageLabel = UILabel()
        errorMessageLabel.isUserInteractionEnabled = true
        errorMessageLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(errorMessageDissapear)))
        errorMessageLabel.font = .boldSystemFont(ofSize: 18)
        errorMessageLabel.textAlignment = .center
        errorMessageLabel.backgroundColor = #colorLiteral(red: 0.3686189353, green: 0.3664327264, blue: 0.370302707, alpha: 0.9290631023) | #colorLiteral(red: 0.5049917102, green: 0.5019935966, blue: 0.5072988272, alpha: 1)
        errorMessageLabel.textColor = .white
        errorMessageLabel.text = "An error occured"
        return errorMessageLabel
    }()
    
    lazy var noResultsLabel: UILabel = {
        let errorMessageLabel = UILabel()
        errorMessageLabel.isUserInteractionEnabled = true
        errorMessageLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(noResultsLabelDissapear)))
        errorMessageLabel.font = .boldSystemFont(ofSize: 18)
        errorMessageLabel.textAlignment = .center
        errorMessageLabel.backgroundColor = #colorLiteral(red: 0.3686189353, green: 0.3664327264, blue: 0.370302707, alpha: 0.9290631023) | #colorLiteral(red: 0.5049917102, green: 0.5019935966, blue: 0.5072988272, alpha: 1)
        errorMessageLabel.textColor = .white
        errorMessageLabel.text = "No Results"
        return errorMessageLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    fileprivate func searchControllerSetUp() {
        
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
            navigationItem.searchController = searchController
        } else {
            navigationItem.titleView = searchController.searchBar
        }
    }
    
    func getSeries(type: StringIntProtocol, language: String, page: Int) {
        isLoading = true
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            NetworkRequest.shared.getTvSeries(type: type, tv: "tv", similar: nil, search: nil, query: nil, language: language, page: page) { [weak self] result in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    
                    switch result {
                    case .success(let list):
                        
                        self.tvSeries.append(contentsOf: list.results)
                        self.tableView.reloadData()
                        
                    case .failure(let error):
                        print(error)
                        self.page += 1
                        self.errorMessageAppear()
                    }
                }
                self.isLoading = false
            }
        }
    }
    
    fileprivate func updateSeries(type: StringIntProtocol, language: String, page: Int, query: String) {
        
        customRefreshControl.beginRefreshing()
        isLoading = true
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            NetworkRequest.shared.getTvSeries(type: type, tv: nil, similar: nil, search: "search", query: query, language: language, page: page) { [weak self] result in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    
                    switch result {
                    case .success(let list):
                        
                        self.noResultsLabelDissapear()
                        self.searchTVSeries.append(contentsOf: list.results)
                        self.tableView.reloadData()
                        self.customRefreshControl.endRefreshing()
                        
                    case .failure(let error):
                        print(error)
                        self.noResultsMessage()
                        self.customRefreshControl.endRefreshing()
                    }
                }
                self.isLoading = false
            }
        }
        
    }
    
    private func noResultsMessage() {
        view.addSubview(noResultsLabel)
        
        if #available(iOS 11.0, *) {
            noResultsLabel.layout(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, size: .init(width: 0, height: 45))
        } else {
            noResultsLabel.layout(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 45))
        }
    }
    
    private func errorMessageAppear() {
        view.addSubview(errorMessageLabel)
        if #available(iOS 11.0, *) {
            errorMessageLabel.layout(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, size: .init(width: 0, height: 45))
        } else {
            errorMessageLabel.layout(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 45))
        }
    }
    
    @objc private func noResultsLabelDissapear() {
        noResultsLabel.removeFromSuperview()
        if searchTVSeries.count > 0 {
            searchTVSeries.removeAll()
            tableView.reloadData()
        }
    }
    
    @objc private func errorMessageDissapear() {
        errorMessageLabel.removeFromSuperview()
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

