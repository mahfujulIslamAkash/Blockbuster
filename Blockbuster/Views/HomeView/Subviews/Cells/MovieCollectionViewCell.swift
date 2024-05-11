//
//  MovieCollectionViewCell.swift
//  Blockbuster
//
//  Created by Temp on 10/5/24.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var posterViewModel = PosterViewModel()
    
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
    
    // MARK: - Methods
    
    /// Updates the UI with movie poster and loading indicator
    func updateUI() {
        addSubview(moviePoster)
        moviePoster.anchorView(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
        addSubview(indicatorView)
        indicatorView.fillSuperview()
        setupObservers()
    }
    
    /// Sets up observers for data loading states
    func setupObservers() {
        setupLoadedObserver()
        setupIsLoadingObserver()
        setupErrorObserver()
        getPoster()
    }
    
    /// Fetches the movie poster
    func getPoster() {
        posterViewModel.getPoster()
    }
    
    /// Sets up observer for data loaded state
    private func setupLoadedObserver() {
        posterViewModel.isLoaded.binds({ [weak self] success in
            if success {
                DispatchQueue.main.async { [weak self] in
                    if let image = self?.posterViewModel.getPosterImage() {
                        self?.moviePoster.image = image
                    }
                    self?.indicatorView.stopAnimating()
                }
            }
        })
    }
    
    /// Sets up observer for loading state
    private func setupIsLoadingObserver() {
        posterViewModel.isLoading.binds({ [weak self] isLoading in
            self?.loadingAnimation(isLoading)
        })
    }
    
    /// Sets up observer for error state
    private func setupErrorObserver() {
        posterViewModel.error.binds({ [weak self] error in
            if let _ = error {
                self?.loadingAnimation(false)
            }
        })
    }
    
    /// Handles loading animation
    private func loadingAnimation(_ isLoading: Bool) {
        if isLoading {
            DispatchQueue.main.async { [weak self] in
                self?.moviePoster.layer.opacity = 0
                self?.indicatorView.startAnimating()
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.moviePoster.layer.opacity = 1
                self?.indicatorView.stopAnimating()
            }
        }
    }
}
