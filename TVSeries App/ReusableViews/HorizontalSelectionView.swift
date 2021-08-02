//
//  HorizontalSelectionView.swift
//  TVSeries App
//
//  Created by David T on 7/11/21.
//

import UIKit

public final class HorizontalSelectionView: UIView {
    
    var delegate: SelectionValue?
    lazy var options = ["TV Series", "Movies"]
    private lazy var cellId = "cellId"
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(SelectionCell.self, forCellWithReuseIdentifier: cellId)
        flowLayout.scrollDirection = .horizontal
        collectionView.backgroundColor = Constants.dynamicBackgroundColors
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private lazy var horizontalBar: UIView = {
        let horizontalBar = UIView()
        horizontalBar.translatesAutoresizingMaskIntoConstraints = false
        horizontalBar.backgroundColor = Constants.dynamicSubColors
        return horizontalBar
    }()
    
    var horizontalBarLeadingAnchor: NSLayoutConstraint?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        collectionView.fillSuperview()
        addSubview(horizontalBar)
        horizontalBarLeadingAnchor = horizontalBar.leadingAnchor.constraint(equalTo: leadingAnchor)
        horizontalBarLeadingAnchor?.isActive = true
        horizontalBar.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        horizontalBar.heightAnchor.constraint(equalToConstant: 1).isActive = true
        horizontalBar.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1 / CGFloat(options.count)).isActive = true
        collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HorizontalSelectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SelectionCell
        cell.label.text = options[indexPath.item]
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / CGFloat(options.count), height: frame.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.scrollToIndex(indexPath.item)
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        horizontalBarLeadingAnchor?.constant = scrollView.contentOffset.x / CGFloat(options.count)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
