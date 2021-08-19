//
//  Coordinator.swift
//  TVSeries App
//
//  Created by David T on 8/10/21.
//

import UIKit

class Coordinator {
    
    private (set) var router: Router?
    private (set) var children = [Coordinator]()
    private (set) weak var parent: Coordinator?
    
    init(router: Router) {
        self.router = router
    }
    
    func start(animated: Bool = false) {
        fatalError("fuck")
    }
    
    func stop(animted: Bool) {
        router?.dismiss(animated: animted)
        parent?.childDidDismiss(child: self)
    }
    
    func coordinateTo(_ coordinator: Coordinator, animated: Bool) {
        addChild(coordinator)
        coordinator.start(animated: animated)
    }
    
    func childDidDismiss(child: Coordinator) {
        removeChild(child)
    }
    
    func addChild(_ coordinator: Coordinator) {
        children.append(coordinator)
    }
    
    func removeChild(_ coordinator: Coordinator) {
        children.removeAll { coordinator === $0 }
    }
    
}

final class AppCoordinator: Coordinator {
    
    override func start(animated: Bool = false) {
        let pageController = HomePageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: .none)
        let pageRouter = PageRouter(pageViewController: pageController)
        
        let homeCoordinator = HomeCoordinator(router: pageRouter)
        homeCoordinator.delegate = self
        pageController.coordinator = homeCoordinator
//        homeCoordinator.start()
        coordinateTo(homeCoordinator, animated: false)
        router?.routeTo(viewController: pageController, animated: false)

    }
}

extension AppCoordinator: HomeCoordinatorDelegate {
    func openItem(itemViewModel: ItemViewModel, listType: ListType) {
        let navigationController = UINavigationController()
        let navRouter = NavigationRouter(navigationController: navigationController)
        let coordinator = DetailCoordinator(router: navRouter, listType: listType, itemViewModel: itemViewModel)
        coordinateTo(coordinator, animated: true)
    }
}


// temporary work around
protocol HomeCoordinatorDelegate: AnyObject {
    func openItem(itemViewModel: ItemViewModel, listType: ListType)
}

final class HomeCoordinator: Coordinator {
    
    private var viewControllers: [UIViewController]
    private lazy var itemsForSeries = ItemsViewController(viewModel: ItemListFactory.makeSeriesViewModel(coordinator: self))
    private lazy var itemsForMovies = ItemsViewController(viewModel: ItemListFactory.makeMoviesViewModel(coordinator: self))
    weak var delegate: HomeCoordinatorDelegate?
    
    init(viewControllers: [UIViewController] = [], router: Router) {
        self.viewControllers = viewControllers
        super.init(router: router)
    }
    
    override func start(animated: Bool = false) {
        presentSeries(animated: animated)
    }
    
    func presentSeries(animated: Bool) {
        router?.routeTo(viewController: itemsForSeries, animated: animated)
    }
    
    func presentMovies(animated: Bool) {
        router?.routeTo(viewController: itemsForMovies, animated: animated)
    }
    
    func openItem(itemViewModel: ItemViewModel, listType: ListType) {
        delegate?.openItem(itemViewModel: itemViewModel, listType: listType)
    }
}







final class DetailCoordinator: Coordinator {
    
    private let listType: ListType
    private let itemViewModel: ItemViewModel
    
    init(router: Router, listType: ListType, itemViewModel: ItemViewModel) {
        self.listType = listType
        self.itemViewModel = itemViewModel
        super.init(router: router)
    }
    
    override func start(animated: Bool = false) {
        let detailViewController = DetailController(viewModel: DetailFactory.makeDetailViewModel(listType: listType, coordinator: self))
        detailViewController.itemViewModel = itemViewModel
        router?.routeTo(viewController: detailViewController, animated: animated)
        
    }
}
