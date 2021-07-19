//
//  MoviesCell.swift
//  TVSeries App
//
//  Created by David T on 7/16/21.
//

import UIKit

final class MoviesCell: UICollectionViewCell {
    private let cellId = "cellId"
    
    private var viewModel: MoviesViewModel!
    private var searchViewModel: SearchMoviesViewModel!
    lazy var homeController = HomeViewController()
    
    private lazy var errorView: ErrorView = {
        let errorView = ErrorView()
        errorView.isHidden = true
        return errorView
    }()
    
    private var customRefreshControl = UIRefreshControl()
    
    private lazy var headerView: UIView = {
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = Constants.dynamicBackgroundColors
        return headerView
    }()
    
    private lazy var searchTextField: UITextField = {
        let searchTextField = UITextField()
        searchTextField.delegate = self
        searchTextField.backgroundColor = #colorLiteral(red: 0.8997321725, green: 0.8998831511, blue: 0.8997122645, alpha: 1) | #colorLiteral(red: 0.404363513, green: 0.4044361711, blue: 0.4043539762, alpha: 1)
        searchTextField.textColor = Constants.dynamicSubColors
        searchTextField.clearButtonMode = .whileEditing
        searchTextField.layer.cornerRadius = 10
        searchTextField.placeholder = "Search TV Series"
        searchTextField.clearButtonMode = .always
        searchTextField.returnKeyType = .search
        searchTextField.enablesReturnKeyAutomatically = true
        searchTextField.setLeftPaddingPoints(15)
        return searchTextField
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(TVSeriesListCell.self, forCellReuseIdentifier: cellId)
        tableView.contentInset = UIEdgeInsets(top: 28, left: 0, bottom: 0, right: 0)
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        viewModel = MoviesViewModel(MoviesAPI.shared)
        searchViewModel = SearchMoviesViewModel(MoviesAPI.shared)
        viewModel.delegate = self
        searchViewModel.delegate = self
        bindViewModel()
        customRefreshControl.beginRefreshing()
        viewModel.fetchMovies()
    }
    
    private func setupUI() {
        addSubview(tableView)
        tableView.layout(top: safeAreaLayoutGuide.topAnchor, leading: safeAreaLayoutGuide.leadingAnchor, bottom: bottomAnchor, trailing: safeAreaLayoutGuide.trailingAnchor)
        
        customRefreshControl.tintColor = Constants.dynamicSubColors
        customRefreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(customRefreshControl)
        
        addSubview(errorView)
        errorView.layout(top: safeAreaLayoutGuide.topAnchor, leading: safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 80, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 45))
        
        addSubview(headerView)
        
        headerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        headerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
        headerView.addSubview(searchTextField)
        searchTextField.layout(top: headerView.safeAreaLayoutGuide.topAnchor, leading: headerView.safeAreaLayoutGuide.leadingAnchor, bottom: headerView.bottomAnchor, trailing: headerView.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 10, left: 10, bottom: 0, right: 10))
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
        viewModel.refresh()
    }
    
    private func perfromSearch(_ query: String?) {
        if viewModel.result.value.count > 0 || searchViewModel.result.value.count > 0 {
            viewModel.result.value.removeAll()
            searchViewModel.result.value.removeAll()
        }
        searchViewModel.searchMovies(query: query!)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if searchTextField.isEditing {
            searchTextField.resignFirstResponder()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MoviesCell: MovieNavigator {
    func navigate(to id: Movie) {
        let detailViewController = DetailController()
        detailViewController.movieId = id
        
        if UIDevice.current.userInterfaceIdiom == .pad || Constants.deviceModelId.contains(UIDevice.current.modelName) && UIDevice.current.orientation == .landscapeRight || UIDevice.current.orientation == .landscapeLeft {
            let rootViewController = UINavigationController(rootViewController: detailViewController)
            homeController.showDetailViewController(rootViewController, sender: self)
        } else {
            homeController.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}


extension MoviesCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchTextField.text != "" ? searchViewModel.result.value.count : viewModel.result.value.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchTextField.text != "" {
            let serie = searchViewModel.result.value[indexPath.row]
            serie.select()
        } else {
            let serie = viewModel.result.value[indexPath.row]
            serie.select()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TVSeriesListCell
        if searchTextField.text != "" {
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
            viewModel.fetchMovies()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}


extension MoviesCell: UISearchControllerDelegate, UISearchBarDelegate {
    
}


extension MoviesCell: UITextFieldDelegate {
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
            viewModel.fetchMovies()
        }
        errorView.isHidden = true
        textField.text = nil
        textField.resignFirstResponder()
        return false
    }
}
