//
//  MovieTableViewCell.swift
//  Blockbuster
//
//  Created by Temp on 10/5/24.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    let title: UILabel = {
        let label = UILabel()
        label.text = "Most Popular"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    lazy var categoriesCollection: UICollectionView = {
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
    
    lazy var moviesCollection: UICollectionView = {
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
    
    var type: CellType = .all{
        didSet{
            if type == .all{
                allMoviesUI()
            }else{
                popularMoviesUI()
            }
        }
    }
    
    let movieViewModel = MovieViewModel()
    
    
    func allMoviesUI(){
        backgroundColor = .clear
        addSubview(stackView)
        stackView.anchorView(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 15)
        
        stackView.addArrangedSubview(categoriesCollection)
        stackView.addArrangedSubview(moviesCollection)
        setupObservers()
        movieViewModel.initiate(.all)
        
    }
    func popularMoviesUI(){
        backgroundColor = .clear
        addSubview(stackView)
        stackView.anchorView(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 15)
        
        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(moviesCollection)
        setupObservers()
        movieViewModel.initiate(.popular)
    }
    
    private func setupObservers() {
        setupLoadedObserver()
        setupLoadedObserverForMovies()
        setupIsLoadingObserver()
        setupErrorObserver()
    }
    
    /// Set up observer for data loaded state
    private func setupLoadedObserver() {
        movieViewModel.isLoaded.binds({[weak self] success in
            if let success = success {
                if success{
                    DispatchQueue.main.async {
                        self?.categoriesCollection.reloadData()
                    }
                }
                
            }
        })
    }
    
    private func setupLoadedObserverForMovies() {
        movieViewModel.isMoviesLoaded.binds({[weak self] success in
            if let success = success {
                if success{
                    DispatchQueue.main.async {
                        self?.moviesCollection.reloadData()
                    }
                }
                
            }
        })
    }
    
    
    /// Set up observer for loading state
    private func setupIsLoadingObserver() {
        movieViewModel.isLoading.binds({[weak self] isLoading in
            self?.loadingAnimation(isLoading)
        })
    }
    
    /// Set up observer for error state
    private func setupErrorObserver() {
        movieViewModel.error.binds({[weak self] error in
            if let _ = error {
                self?.loadingAnimation(false)
                self?.movieViewModel.showingErrorToast()
            }
        })
    }
    
    // MARK: - Loading View
    
    /// Handle loading animation
    private func loadingAnimation(_ isLoading: Bool) {
        if isLoading {
            if let _ = movieViewModel.lastGenre{
                //if having gener that means already categories data loaded
                DispatchQueue.main.async {[weak self] in
                    self?.moviesCollection.layer.opacity = 0
                    self?.indicatorView.startAnimating()
                    
                }
            }else{
                DispatchQueue.main.async {[weak self] in
                    self?.stackView.layer.opacity = 0
                    self?.indicatorView.startAnimating()
                }
            }
        }else {
            if let _ = movieViewModel.lastGenre{
                //if having gener that means already categories data loaded
                DispatchQueue.main.async {[weak self] in
                    self?.moviesCollection.layer.opacity = 1
                    self?.indicatorView.stopAnimating()
                    
                }
            }else{
                DispatchQueue.main.async {[weak self] in
                    self?.stackView.layer.opacity = 1
                    self?.indicatorView.stopAnimating()
                }
            }
        }
        }

}

extension MainTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoriesCollection{
            return movieViewModel.getCountOfCategories()
        }else{
            return movieViewModel.getCountOfMovies()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoriesCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCollectionViewCell
            cell.setupTitleUI(movieViewModel.getTitle(indexPath), movieViewModel.getCurrentSelection() == indexPath.row)
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
            cell.posterViewModel = PosterViewModel(movieViewModel.getPosterEndpoint(indexPath))
            cell.setupObservers()
            cell.updateUI()
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoriesCollection{
            return CGSize(width: 90, height: 30)
        }else{
            return CGSize(width: 110, height: 170)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoriesCollection{
            let oldPath = IndexPath(row: movieViewModel.getCurrentSelection(), section: indexPath.section)
            movieViewModel.updateSelection(indexPath)
            collectionView.reloadItems(at: [oldPath, indexPath])
            
            movieViewModel.callApi(movieViewModel.getTitle(indexPath))

        }else{
        }
    }
}

enum CellType{
    case all
    case popular
}
