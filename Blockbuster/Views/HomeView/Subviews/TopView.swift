//
//  TopView.swift
//  Blockbuster
//
//  Created by Temp on 10/5/24.
//

import UIKit

// TopView: UIView subclass represents a custom view with a title label and a search button.
class TopView: UIView {

    // Size of the parent view.
    var motherSize: CGSize = .zero
    
    // Title label for the view.
    let title: UILabel = {
        let label = UILabel()
        label.text = "Movie"
        label.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        label.textColor = .white
        return label
    }()
    
    // Search button for the view.
    lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    // Initializes the view with the given parent size.
    init(motherSize: CGSize){
        super.init(frame: .zero)
        self.motherSize = motherSize
        setupUI(motherSize: motherSize)
        backgroundColor = .clear
        
    }
    
    // Sets up the UI elements of the view.
    func setupUI(motherSize: CGSize){
        addSubview(title)
        title.anchorView(left: leftAnchor, bottom: bottomAnchor, paddingLeft: 15, height: 40)
        addSubview(searchButton)
        searchButton.anchorView(bottom: bottomAnchor, right: rightAnchor, paddingRight: 15, height: 40)
        
        heightAnchor.constraint(equalToConstant: motherSize.height).isActive = true
        widthAnchor.constraint(equalToConstant: motherSize.width).isActive = true
        
    }
    
    // Required initializer, not implemented.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
