//
//  HomeViewController.swift
//  TVSeries App
//
//  Created by David T on 7/16/21.
//

import UIKit

final class HomeViewController: UIViewController {
    
    private let seriesCellId = "seriesCellId"
    private let moviesCellId = "moviesCellId"
    
    private var viewModel: SeriesViewModel!
    private var searchViewModel: SearchSeriesViewModel!
    
    private lazy var horizontalSelectionView: HorizontalSelectionView = {
        let horizontalSelectionView = HorizontalSelectionView()
        horizontalSelectionView.delegate = self
        return horizontalSelectionView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(SeriesCell.self, forCellWithReuseIdentifier: seriesCellId)
        collectionView.register(MoviesCell.self, forCellWithReuseIdentifier: moviesCellId)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Home"
        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = Constants.dynamicBackgroundColors
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = Constants.dynamicBackgroundColors
        
        view.addSubview(horizontalSelectionView)
        horizontalSelectionView.layout(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, size: .init(width: 0, height: 50))
    }
    
    private func setupCollectionView() {
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        
        view.addSubview(collectionView)
        collectionView.layout(top: horizontalSelectionView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
    }
    
    private func scrollToSelectionIndex(_ index: Int) {
        collectionView.isPagingEnabled = false
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: [], animated: true)
        collectionView.isPagingEnabled = true
    }
}

extension HomeViewController: SelectionValue {
    func scrollToIndex(_ index: Int) {
        scrollToSelectionIndex(index)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return horizontalSelectionView.options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: seriesCellId, for: indexPath) as! SeriesCell
            cell.homeController = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: moviesCellId, for: indexPath) as! MoviesCell
            cell.homeController = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
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
