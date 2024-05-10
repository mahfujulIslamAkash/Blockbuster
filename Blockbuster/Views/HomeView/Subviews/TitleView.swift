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
        return label
    }()
    
    lazy var seachButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        view.tintColor = .white
        view.widthAnchor.constraint(equalToConstant: motherSize.height).isActive = true
        view.backgroundColor = UIColor(hexString: "FF2DAF")
        return view
    }()
    
    init(motherSize: CGSize){
        super.init(frame: .zero)
        self.motherSize = motherSize
        setupUI(motherSize: motherSize)
        
    }
    
    func setupUI(motherSize: CGSize){
        addSubview(title)
        title.anchorView(left: leftAnchor, bottom: bottomAnchor, height: 50)
        addSubview(seachButton)
        seachButton.anchorView(bottom: bottomAnchor, right: rightAnchor, height: 50)
        
        heightAnchor.constraint(equalToConstant: motherSize.height).isActive = true
        widthAnchor.constraint(equalToConstant: motherSize.width).isActive = true
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
