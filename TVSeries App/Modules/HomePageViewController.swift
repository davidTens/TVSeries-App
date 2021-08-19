//
//  HomaPageViewController.swift
//  TVSeries App
//
//  Created by David T on 7/22/21.
//

import UIKit

final class HomePageViewController: UIPageViewController {
    
    weak var coordinator: HomeCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Home"
        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = Constants.dynamicBackgroundColors
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = Constants.dynamicBackgroundColors
        navigationController?.navigationBar.tintColor = Constants.dynamicSubColors
    }
}
