//
//  HomaPageViewController.swift
//  TVSeries App
//
//  Created by David T on 7/22/21.
//

import UIKit

final class HomePageViewController: UIPageViewController {
    
    private lazy var viewControllerList: [UIViewController] = {
        let seriesViewController = SeriesViewController(viewModel: ItemListFactory.makeSeriesViewModel())
        let moviesViewController = MoviesViewController(viewModel: ItemListFactory.makeMoviesViewModel())
        return [seriesViewController, moviesViewController]
    }()
    
    private lazy var horizontalSelectionView: HorizontalSelectionView = {
        let horizontalSelectionView = HorizontalSelectionView()
        horizontalSelectionView.delegate = self
        return horizontalSelectionView
    }()
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        navigationItem.title = "Home"
        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = Constants.dynamicBackgroundColors
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = Constants.dynamicBackgroundColors
        navigationController?.navigationBar.tintColor = Constants.dynamicSubColors
        
//        navigationController?.view.addSubview(horizontalSelectionView)
//        horizontalSelectionView.layout(top: navigationController?.navigationBar.bottomAnchor, leading: navigationController?.view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: navigationController?.view.safeAreaLayoutGuide.trailingAnchor, size: .init(width: 0, height: 50))
        
        if let first = viewControllerList.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func scrollToSelectionIndex(_ index: Int) {
        //
    }
}


extension HomePageViewController: SelectionValue {
    func scrollToIndex(_ index: Int) {
        scrollToSelectionIndex(index)
    }
}


extension HomePageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewControllerList.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return nil }
        guard viewControllerList.count > previousIndex else { return nil }
        return viewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewControllerList.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard viewControllerList.count != nextIndex else { return nil }
        guard viewControllerList.count > nextIndex else { return nil }
        return viewControllerList[nextIndex]
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        horizontalSelectionView.horizontalBarLeadingAnchor?.constant = scrollView.contentOffset.x / CGFloat(horizontalSelectionView.options.count)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        horizontalSelectionView.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }
    
}
