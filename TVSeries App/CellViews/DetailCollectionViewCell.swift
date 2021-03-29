//
//  DetailCollectionViewCell.swift
//  TV Series App
//
//  Created by David T on 3/22/21.
//

import UIKit

class DetailCollectionViewCell: UICollectionViewCell {
    
    var tvSeriesId: TVSeries? {
        didSet {
            titleLabel.text = tvSeriesId?.name
            
            if let imageURL = tvSeriesId?.poster_path {
                let imageURLFinalPath = "https://image.tmdb.org/t/p/w500/\(imageURL)"
                customImageView.loadImageUsingCacheWithURL(urlString: imageURLFinalPath)
            }
        }
    }
    
    lazy var customImageView: UIImageView = {
        let customImageView = UIImageView()
        customImageView.backgroundColor = UIColor(hexFromString: "#F4F4F4")
        customImageView.layer.masksToBounds = true
        customImageView.layer.cornerRadius = 16.0
        return customImageView
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textAlignment = .left
        titleLabel.textColor = dynamicSubColors
        titleLabel.adjustsFontSizeToFitWidth = true
        return titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        ui()
    }
    
    private func ui() {
        
        [customImageView, titleLabel].forEach({ addSubview($0) })
        
        customImageView.layout(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 2, left: 4, bottom: 26, right: 4))
        
        titleLabel.layout(top: customImageView.bottomAnchor, leading: customImageView.leadingAnchor, bottom: bottomAnchor, trailing: customImageView.trailingAnchor, padding: .init(top: 5, left: 0, bottom: 0, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
