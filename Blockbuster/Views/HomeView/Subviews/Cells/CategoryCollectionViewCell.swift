//
//  CategoryCollectionViewCell.swift
//  Blockbuster
//
//  Created by Temp on 10/5/24.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    let title: UILabel = {
        let label = UILabel()
        label.text = "Movie"
        label.textAlignment = .center
        label.backgroundColor = .systemPink
        label.textColor = .black
        label.layer.masksToBounds = true
        return label
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        // Initialize your cell as usual
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    /// Sets up the UI for the category cell
    ///
    /// - Parameters:
    ///   - category: The category name to display
    ///   - isSelected: A Boolean value indicating whether the category is selected
    func setupTitleUI(_ category: String, _ isSelected: Bool) {
        backgroundColor = .clear
        title.text = category
        addSubview(title)
        title.anchorView(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        title.layer.cornerRadius = isSelected ? 16 : 0
        title.backgroundColor = isSelected ? UIColor.systemPink : UIColor.clear
        title.textColor = isSelected ? UIColor.white : UIColor.white.withAlphaComponent(0.3)
    }
}
