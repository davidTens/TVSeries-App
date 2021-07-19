//
//  SelectionCell.swift
//  TVSeries App
//
//  Created by David T on 7/11/21.
//

import UIKit

final class SelectionCell: UICollectionViewCell {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = Constants.dynamicSubColors.withAlphaComponent(0.6)
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            label.textColor = isSelected ? Constants.dynamicSubColors : .lightGray
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            label.textColor = isHighlighted ? Constants.dynamicSubColors : .lightGray
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
