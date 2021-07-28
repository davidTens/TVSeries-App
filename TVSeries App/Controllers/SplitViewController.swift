//
//  SplitViewController.swift
//  TV Series App
//
//  Created by David T on 3/23/21.
//

import UIKit

final class SplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        let masterViewController = UINavigationController(rootViewController: HomePageViewController())
        let detailViewController = UINavigationController(rootViewController: DetailController(viewModel: DetailFactory.makeDetailViewModelForSeries()))
        
        viewControllers = [masterViewController, detailViewController]
        preferredDisplayMode = .allVisible
    }
    
    func splitViewController(
            _ splitViewController: UISplitViewController,
            collapseSecondary secondaryViewController: UIViewController,
            onto primaryViewController: UIViewController) -> Bool {
            return true
        }
        
}
