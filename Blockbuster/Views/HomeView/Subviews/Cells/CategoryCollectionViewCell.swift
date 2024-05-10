//
//  CategoryCollectionViewCell.swift
//  Blockbuster
//
//  Created by Temp on 10/5/24.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    let title: UILabel = {
        let label = UILabel()
        label.text = "Movie"
        label.textAlignment = .center
        label.backgroundColor = .systemPink
        label.textColor = .black
        label.layer.masksToBounds = true
        return label
    }()
    override init(frame: CGRect) {
        // Initialize your cell as usual
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupTitleUI(_ category: String, _ isSelected: Bool){
        title.text = category
        addSubview(title)
        title.anchorView(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        title.layer.cornerRadius = isSelected ? 16 : 0
        title.backgroundColor = isSelected ? UIColor.systemPink : UIColor.clear
    }
}
