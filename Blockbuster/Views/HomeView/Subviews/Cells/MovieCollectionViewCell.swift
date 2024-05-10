//
//  MovieCollectionViewCell.swift
//  Blockbuster
//
//  Created by Temp on 10/5/24.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    var posterViewModel = PosterViewModel()
    
    let title: UILabel = {
        let label = UILabel()
        label.text = "Movie"
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    let indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        view.tintColor = .black
        return view
    }()
    
    lazy var moviePoster: UIImageView = {
        let view = UIImageView()
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = .green
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func updateUI(_ name: String, _ endpoint: String){
        addSubview(moviePoster)
        moviePoster.anchorView(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
        addSubview(indicatorView)
        indicatorView.fillSuperview()
//        addSubview(title)
//        title.anchorView(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
//        title.text = name
        
        setupObservers()
        
    }
    
    func setupObservers() {
        setupLoadedObserver()
        setupIsLoadingObserver()
        setupErrorObserver()
        getPoster()
        
    }
    func getPoster(){
        posterViewModel.getPoster()
    }
    
//    private func updateUI(){
//        DispatchQueue.main.async {[weak self] in
//            self?.moviePoster.image = self?.posterViewModel.getPosterImage()
//            self?.indicatorView.stopAnimating()
//        }
//        
//    }
    
    /// Set up observer for data loaded state
    private func setupLoadedObserver() {
        posterViewModel.isLoaded.binds({[weak self] success in
            if success{
                DispatchQueue.main.async {[weak self] in
                    self?.moviePoster.image = self?.posterViewModel.getPosterImage()
                    self?.indicatorView.stopAnimating()
                }
                
            }
        })
    }
    
    
    /// Set up observer for loading state
    private func setupIsLoadingObserver() {
        posterViewModel.isLoading.binds({[weak self] isLoading in
            self?.loadingAnimation(isLoading)
        })
    }
    
    /// Set up observer for error state
    private func setupErrorObserver() {
        posterViewModel.error.binds({[weak self] error in
            if let _ = error {
                self?.loadingAnimation(false)
            }
        })
    }
    
    // MARK: - Loading View
    
    /// Handle loading animation
    private func loadingAnimation(_ isLoading: Bool) {
        if isLoading {
            DispatchQueue.main.async {[weak self] in
                self?.moviePoster.layer.opacity = 0
                self?.indicatorView.startAnimating()
            }
        } else {
            DispatchQueue.main.async {[weak self] in
                self?.moviePoster.layer.opacity = 1
                self?.indicatorView.stopAnimating()
            }
        }
    }
}
