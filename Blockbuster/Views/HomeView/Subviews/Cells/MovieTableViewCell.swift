//
//  MovieTableViewCell.swift
//  Blockbuster
//
//  Created by Temp on 10/5/24.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    let title: UILabel = {
        let label = UILabel()
        label.text = "Most Popular"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    // Collection view for displaying categories
    lazy var categoriesCollection: UICollectionView = {
        // Collection view setup
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "categoryCell")
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    // Collection view for displaying movies
    lazy var moviesCollection: UICollectionView = {
        // Collection view setup
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "movieCell")
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    /// Activity indicator to show loading state
    let indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        view.transform = view.transform.scaledBy(x: 10, y: 10)
        view.tintColor = .white
        return view
    }()
    
    /// Stack view to organize UI components
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 0
        stack.addSubview(indicatorView)
        indicatorView.centerX(inView: stack)
        indicatorView.centerY(inView: stack)
        stack.backgroundColor = .clear
        return stack
    }()
    
    var type: CellType = .all {
        didSet {
            // Update UI based on cell type
            if type == .all {
                allMoviesUI()
            } else {
                popularMoviesUI()
            }
        }
    }
    
    let movieViewModel = MovieViewModel()
    
    // MARK: - Setup Methods
    
    /// Configure UI for displaying all movies
    func allMoviesUI() {
        backgroundColor = .clear
        addSubview(stackView)
        stackView.anchorView(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 15)
        
        // Add categories and movies collection views
        stackView.addArrangedSubview(categoriesCollection)
        stackView.addArrangedSubview(moviesCollection)
        
        // Set up observers and initiate API call
        setupObservers()
        movieViewModel.initiate(.all)
    }
    
    /// Configure UI for displaying popular movies
    func popularMoviesUI() {
        backgroundColor = .clear
        addSubview(stackView)
        stackView.anchorView(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 15)
        
        // Add title and movies collection views
        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(moviesCollection)
        
        // Set up observers and initiate API call
        setupObservers()
        movieViewModel.initiate(.popular)
    }
    
    // MARK: - Observers
    
    /// Set up observers for data loading, error, and loading state
    private func setupObservers() {
        setupLoadedObserver()
        setupLoadedObserverForMovies()
        setupIsLoadingObserver()
        setupErrorObserver()
    }
    // MARK: - Observer Setup

    /// Set up observer for data loaded state
    private func setupLoadedObserver() {
        movieViewModel.isLoaded.binds { [weak self] success in
            guard let self = self, let success = success else { return }
            
            // Check if data is successfully loaded
            if success {
                // Reload categoriesCollection on the main thread to update UI
                DispatchQueue.main.async {
                    self.categoriesCollection.reloadData()
                }
            }
        }
    }

    /// Set up observer for data loaded state for movies
    private func setupLoadedObserverForMovies() {
        movieViewModel.isMoviesLoaded.binds { [weak self] success in
            guard let self = self, let success = success else { return }
            
            // Check if movies data is successfully loaded
            if success {
                // Reload moviesCollection on the main thread to update UI
                DispatchQueue.main.async {
                    self.moviesCollection.reloadData()
                }
            }
        }
    }

    /// Set up observer for loading state
    private func setupIsLoadingObserver() {
        movieViewModel.isLoading.binds { [weak self] isLoading in
            guard let self = self else { return }
            
            // Trigger loading animation based on loading state
            self.loadingAnimation(isLoading)
        }
    }

    /// Set up observer for error state
    private func setupErrorObserver() {
        movieViewModel.error.binds { [weak self] error in
            guard let self = self, let _ = error else { return }
            
            // Stop loading animation and display error toast
            self.loadingAnimation(false)
            self.movieViewModel.showingErrorToast()
        }
    }

    
    // MARK: - Loading Animation
    
    /// Handle loading animation
    private func loadingAnimation(_ isLoading: Bool) {
        // Show or hide loading animation based on loading state
        if isLoading {
            if let _ = movieViewModel.lastGenre {
                // Categories data already loaded, show movie collection loading animation
                DispatchQueue.main.async { [weak self] in
                    self?.moviesCollection.layer.opacity = 0
                    self?.indicatorView.startAnimating()
                }
            } else {
                // Categories data not yet loaded, show stack view loading animation
                DispatchQueue.main.async { [weak self] in
                    self?.stackView.layer.opacity = 0
                    self?.indicatorView.startAnimating()
                }
            }
        } else {
            if let _ = movieViewModel.lastGenre {
                // Categories data already loaded, hide movie collection loading animation
                DispatchQueue.main.async { [weak self] in
                    self?.moviesCollection.layer.opacity = 1
                    self?.indicatorView.stopAnimating()
                }
            } else {
                // Categories data not yet loaded, hide stack view loading animation
                DispatchQueue.main.async { [weak self] in
                    self?.stackView.layer.opacity = 1
                    self?.indicatorView.stopAnimating()
                }
            }
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension MovieTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoriesCollection {
            return movieViewModel.getCountOfCategories()
        } else {
            return movieViewModel.getCountOfMovies()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoriesCollection {
            // Configure category cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCollectionViewCell
            cell.setupTitleUI(movieViewModel.getTitle(indexPath), movieViewModel.getCurrentSelection() == indexPath.row)
            return cell
        } else {
            // Configure movie cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
            cell.posterViewModel = PosterViewModel(movieViewModel.getPosterEndpoint(indexPath))
            cell.setupObservers()
            cell.updateUI()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoriesCollection {
            return movieViewModel.getCategoryCellSize()
        } else {
            return movieViewModel.getMovieCellSize()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoriesCollection {
            // Update selection and call API
            let oldPath = IndexPath(row: movieViewModel.getCurrentSelection(), section: indexPath.section)
            movieViewModel.updateSelection(indexPath)
            collectionView.reloadItems(at: [oldPath, indexPath])
            movieViewModel.callApi(movieViewModel.getTitle(indexPath))
        } else {
            // Handle movie selection
        }
    }
}

// MARK: - Enum

enum CellType {
    case all
    case popular
}
