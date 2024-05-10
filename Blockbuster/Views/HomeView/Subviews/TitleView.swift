//
//  TitleView.swift
//  Blockbuster
//
//  Created by Temp on 10/5/24.
//

import UIKit

class TitleView: UIView {

    var motherSize: CGSize = .zero
    
    let title: UILabel = {
        let label = UILabel()
        label.text = "Movie"
        label.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        label.textColor = .white
        return label
    }()
    
    lazy var seachButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        view.tintColor = .white
        return view
    }()
    
    init(motherSize: CGSize){
        super.init(frame: .zero)
        self.motherSize = motherSize
        setupUI(motherSize: motherSize)
        backgroundColor = .clear
        
    }
    
    func setupUI(motherSize: CGSize){
        addSubview(title)
        title.anchorView(left: leftAnchor, bottom: bottomAnchor, paddingLeft: 15, height: 40)
        addSubview(seachButton)
        seachButton.anchorView(bottom: bottomAnchor, right: rightAnchor, paddingRight: 15, height: 40)
        
        heightAnchor.constraint(equalToConstant: motherSize.height).isActive = true
        widthAnchor.constraint(equalToConstant: motherSize.width).isActive = true
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
