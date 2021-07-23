//
//  BaseViewController.swift
//  TVSeries App
//
//  Created by David T on 7/22/21.
//

import UIKit

class BaseViewController: UIViewController {
    
    lazy var customRefreshControl = UIRefreshControl()
    
    lazy var errorView: ErrorView = {
        let errorView = ErrorView()
        errorView.isHidden = true
        return errorView
    }()
    
    lazy var headerView: UIView = {
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = Constants.dynamicBackgroundColors
        return headerView
    }()
    
    lazy var searchTextField: UITextField = {
        let searchTextField = UITextField()
        searchTextField.backgroundColor = #colorLiteral(red: 0.8997321725, green: 0.8998831511, blue: 0.8997122645, alpha: 1) | #colorLiteral(red: 0.404363513, green: 0.4044361711, blue: 0.4043539762, alpha: 1)
        searchTextField.textColor = Constants.dynamicSubColors
        searchTextField.clearButtonMode = .whileEditing
        searchTextField.layer.cornerRadius = 10
        searchTextField.clearButtonMode = .always
        searchTextField.returnKeyType = .search
        searchTextField.enablesReturnKeyAutomatically = true
        searchTextField.setLeftPaddingPoints(15)
        return searchTextField
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.layout(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        
        customRefreshControl.tintColor = Constants.dynamicSubColors
        tableView.addSubview(customRefreshControl)
        
        view.addSubview(errorView)
        errorView.layout(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 80, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 45))
        
        view.addSubview(headerView)
        
        headerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        headerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
        headerView.addSubview(searchTextField)
        searchTextField.layout(top: headerView.safeAreaLayoutGuide.topAnchor, leading: headerView.safeAreaLayoutGuide.leadingAnchor, bottom: headerView.bottomAnchor, trailing: headerView.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 10, left: 10, bottom: 0, right: 10))
        setup()
    }
    
    func setup() { }
    
    @objc func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if searchTextField.isEditing {
            searchTextField.resignFirstResponder()
        } else { }
    }
}
