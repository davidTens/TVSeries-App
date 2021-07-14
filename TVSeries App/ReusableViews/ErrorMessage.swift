//
//  ErrorMessage.swift
//  TVSeries App
//
//  Created by David T on 7/8/21.
//

import UIKit

public final class ErrorView: UIView {
    
    lazy var errorMessageLabel: UILabel = {
        let errorMessageLabel = UILabel()
        errorMessageLabel.isUserInteractionEnabled = true
        errorMessageLabel.font = .boldSystemFont(ofSize: 18)
        errorMessageLabel.textAlignment = .center
        errorMessageLabel.backgroundColor = #colorLiteral(red: 0.5049917102, green: 0.5019935966, blue: 0.5072988272, alpha: 1) | #colorLiteral(red: 0.3686189353, green: 0.3664327264, blue: 0.370302707, alpha: 0.9290631023)
        errorMessageLabel.textColor = .white
        return errorMessageLabel
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(errorMessageLabel)
        errorMessageLabel.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
