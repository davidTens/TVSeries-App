//
//  DetailTableViewCell.swift
//  TV Series App
//
//  Created by David T on 3/24/21.
//

import UIKit

final class DetailTableViewCell: UITableViewCell {
    
    lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = .boldSystemFont(ofSize: 16)
        descriptionLabel.textAlignment = .left
        descriptionLabel.backgroundColor = .clear
        descriptionLabel.textColor = Constants.dynamicSubColors
        return descriptionLabel
    }()
    
    lazy var customTextView: UITextView = {
        let customTextView = UITextView()
        customTextView.textContainerInset = UIEdgeInsets(top: 1, left: 3, bottom: 0, right: 3)
        customTextView.textAlignment = .left
        customTextView.isEditable = false
        customTextView.isScrollEnabled = false
        customTextView.backgroundColor = .clear
        customTextView.textColor = Constants.dynamicSubColors
        customTextView.font = UIFont(name: "Avenir", size: 15)
        return customTextView
    }()
    
    func configure(_ viewModel: DetailViewModel) {
        customTextView.text = viewModel.name
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        addSubview(descriptionLabel)
        addSubview(customTextView)
        
        descriptionLabel.layout(top: topAnchor, leading: safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 5, left: 6, bottom: 5, right: 6), size: .init(width: 0, height: 20))
        customTextView.layout(top: descriptionLabel.bottomAnchor, leading: safeAreaLayoutGuide.leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, trailing: safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 5, left: 2, bottom: 2, right: 5))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
