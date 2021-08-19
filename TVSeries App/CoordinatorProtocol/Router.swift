//
//  Router.swift
//  TVSeries App
//
//  Created by David T on 8/16/21.
//

import UIKit

protocol Router: AnyObject {
    var viewController: UIViewController? { get }
    func routeTo(viewController: UIViewController, animated: Bool)
    func dismiss(animated: Bool)
}

class NavigationRouter {
    
    private weak var rootViewController: UIViewController?
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.rootViewController = navigationController.viewControllers.first
    }
}


// TODO: - increment navigationDelegate
extension NavigationRouter: Router {
    var viewController: UIViewController? {
        return navigationController
    }
    
    func routeTo(viewController: UIViewController, animated: Bool) {
        navigationController?.setViewControllers([viewController], animated: false)
    }
    
    func dismiss(animated: Bool) {
        navigationController?.dismiss(animated: animated, completion: nil)
    }
}


class SplitRouter: NSObject {
    
    private weak var splitViewController: UISplitViewController?
    
    init(viewController: UISplitViewController) {
        self.splitViewController = viewController
        super.init()
        viewController.delegate = self
    }
    
}

extension SplitRouter: UISplitViewControllerDelegate {
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}


extension SplitRouter: Router {
    var viewController: UIViewController? {
        return splitViewController?.children.last
    }
    
    func routeTo(viewController: UIViewController, animated: Bool) {
        if splitViewController?.children.isEmpty == true {
            splitViewController?.setViewController(viewController, for: .primary)
//            splitViewController?.setViewController(UINavigationController(), for: .secondary)
//            splitViewController?.viewControllers = [UINavigationController(rootViewController: viewController), UINavigationController(rootViewController: .init())]
//            splitViewController?.show(viewController, sender: splitViewController)
        } else {
            splitViewController?.showDetailViewController(viewController, sender: splitViewController)
//            splitViewController?.setViewController(viewController, for: .secondary)
//            splitViewController?.viewControllers = [splitViewController?.viewControllers.first, viewController].compactMap({ $0 }).map(UINavigationController.init)
        }
    }
    
    func dismiss(animated: Bool) {
        print("must dismiss")
    }
}


class PageRouter: NSObject {
    
    private weak var pageViewController: UIPageViewController?
//    private var viewControllers: [UIViewController]
    
    init(pageViewController: UIPageViewController) {
        self.pageViewController = pageViewController
//        self.viewControllers = viewControllers
        super.init()
//        pageViewController.dataSource = self
//        pageViewController.setViewControllers(viewControllers, direction: .forward, animated: false, completion: nil)
    }
    
    @discardableResult private func transitToVCIfAvailable(_ viewController: UIViewController, animated: Bool) -> Bool {
        let isContained = pageViewController?.viewControllers?.contains(where: { vc in
            vc === viewController
        }) ?? false
        
        guard isContained else {
            return false
        }
        
        pageViewController?.setViewControllers([viewController], direction: .forward, animated: animated, completion: nil)
        
        return isContained
    }
    
}

extension PageRouter: Router {
    var viewController: UIViewController? {
        return pageViewController
    }
    
    func routeTo(viewController: UIViewController, animated: Bool) {
//        transitToVCIfAvailable(viewController, animated: animated)
        pageViewController?.setViewControllers([viewController], direction: .forward, animated: animated, completion: nil)
    }
    
    func dismiss(animated: Bool) {
        print("must dismiss")
    }
    
    
}


//extension PageRouter: UIPageViewControllerDataSource {
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        guard let viewControllerIndex = viewControllers.firstIndex(of: viewController) else { return nil }
//        let nextIndex = viewControllerIndex + 1
//        guard viewControllers.count != nextIndex else { return nil }
//        guard viewControllers.count > nextIndex else { return nil }
//        return viewControllers[nextIndex]
//    }
//
//
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        guard let viewControllerIndex = viewControllers.firstIndex(of: viewController) else { return nil }
//        let previousIndex = viewControllerIndex - 1
//        guard previousIndex >= 0 else { return nil }
//        guard viewControllers.count > previousIndex else { return nil }
//        return viewControllers[previousIndex]
//    }
//
//}
