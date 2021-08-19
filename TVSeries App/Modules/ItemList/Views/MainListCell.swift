//
//  MovieListCellView.swift
//  TV Series App
//
//  Created by David T on 3/18/21.
//

import UIKit

final class MainListCell: UITableViewCell {
    
    private lazy var customImageView: UIImageView = {
        let customImageView = UIImageView()
        customImageView.backgroundColor = UIColor(hexFromString: "#F4F4F4")
        customImageView.layer.masksToBounds = true
        customImageView.layer.cornerRadius = 10
        return customImageView
    }()
    
    private lazy var titleTextView: UILabel = {
        let titleTextView = UILabel()
        titleTextView.font = UIFont(name: "Avenir Book", size: 20)
        titleTextView.backgroundColor = .clear
        titleTextView.textAlignment = .left
        titleTextView.adjustsFontSizeToFitWidth = true
        titleTextView.textColor = Constants.dynamicSubColors
        return titleTextView
    }()
    
    
    private lazy var nextButton: UIButton = {
        let nextButton = UIButton()
        nextButton.titleLabel?.font = UIFont(name: "Avenir Medium", size: 20)
        nextButton.titleLabel?.textAlignment = .center
        nextButton.backgroundColor = UIColor(hexFromString: "#37373C") | .white
        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(.white | .black, for: .normal)
        nextButton.clipsToBounds = true
        nextButton.layer.cornerRadius = 6
        return nextButton
    }()
    
    private lazy var ratingLabel: UILabel = {
        let ratingLabel = UILabel()
        ratingLabel.font = .boldSystemFont(ofSize: 14)
        ratingLabel.textAlignment = .left
        ratingLabel.textColor = .lightGray
        return ratingLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        uiSetUp()
    }
    
    func configure(_ viewModel: ItemViewModel) {
        titleTextView.text = viewModel.name
        ratingLabel.text = viewModel.rating
        customImageView.loadImageUsingCacheWithURL(urlString: viewModel.imageURLPath)
    }
    
    private func uiSetUp() {
        backgroundColor = .clear
        
        [customImageView, titleTextView, ratingLabel, nextButton].forEach( {addSubview($0) })
        
        customImageView.layout(top: topAnchor, leading: safeAreaLayoutGuide.leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 10, left: 15, bottom: 10, right: 0), size: .init(width: 120, height: 0))
        
        titleTextView.layout(top: customImageView.topAnchor, leading: customImageView.trailingAnchor, bottom: nil, trailing: safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: 12), size: .init(width: 0, height: 22))
        
        nextButton.layout(top: nil, leading: nil, bottom: bottomAnchor, trailing: safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 10, right: 8), size: .init(width: 100, height: 35))
        
        ratingLabel.layout(top: titleTextView.bottomAnchor, leading: titleTextView.leadingAnchor, bottom: nil, trailing: titleTextView.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 20))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
