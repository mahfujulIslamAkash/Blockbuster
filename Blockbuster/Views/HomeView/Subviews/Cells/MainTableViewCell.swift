//
//  MovieTableViewCell.swift
//  Blockbuster
//
//  Created by Temp on 10/5/24.
//

import UIKit

class MainTableViewCell: UITableViewCell {

//    let categories: [String] = ["A", "B", "C", "A", "B", "C", "A", "B", "C", "A", "B", "C", "A", "B", "C"]
    
    let title: UILabel = {
        let label = UILabel()
        label.text = "Popular"
        return label
    }()
    
    lazy var categoriesCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "categoryCell")
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .yellow
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
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
        view.backgroundColor = .black
        view.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
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
        stack.layer.borderWidth = 0.5
        stack.addSubview(indicatorView)
        indicatorView.centerX(inView: stack)
        indicatorView.centerY(inView: stack)
        stack.backgroundColor = .red
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func allMoviesUI(){
        addSubview(stackView)
        stackView.anchorView(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
        stackView.addArrangedSubview(categoriesCollection)
        stackView.addArrangedSubview(moviesCollection)
        setupObservers()
        movieViewModel.initiate(.all)
        
    }
    func popularMoviesUI(){
        addSubview(stackView)
        stackView.anchorView(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
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
            DispatchQueue.main.async {[weak self] in
                self?.stackView.layer.opacity = 0
                self?.indicatorView.startAnimating()
            }
        } else {
            DispatchQueue.main.async {[weak self] in
                self?.stackView.layer.opacity = 1
                self?.indicatorView.stopAnimating()
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
            cell.setupTitleUI(movieViewModel.getTitle(indexPath), indexPath.row == 0 ? true : false)
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
            cell.posterViewModel = PosterViewModel(movieViewModel.getPosterEndpoint(indexPath))
            cell.setupObservers()
            cell.updateUI(movieViewModel.getMovieTitle(indexPath), movieViewModel.getPosterEndpoint(indexPath))
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoriesCollection{
            return CGSize(width: 90, height: 30)
        }else{
            return CGSize(width: 90, height: 170)
        }
        
    }
}

enum CellType{
    case all
    case popular
}
