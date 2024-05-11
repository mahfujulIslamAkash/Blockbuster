//
//  MovieViewModel.swift
//  Blockbuster
//
//  Created by Temp on 10/5/24.
//

import Foundation
import UIKit

final class MovieViewModel{
    // MARK: - Properties
    
    // Static instance of NetworkService
    static var shared = NetworkService()
    
    // Pagination properties
    private var currentOffset: Int = 0
    private var limit: Int = 20
    
    // Data properties
    private var categories: [Category]?
    private var currentSelection = 0
    private var movies: [Movie]?
    var lastGenre: String?
    
    // Observable properties for UI updates
    var isLoaded: ObservableObject<Bool?> = ObservableObject(nil)
    var isMoviesLoaded: ObservableObject<Bool?> = ObservableObject(nil)
    var isLoading: ObservableObject<Bool> = ObservableObject(true)
    var error: ObservableObject<Bool?> = ObservableObject(nil)
    
    // Type of cell (all categories or popular)
    private var cellType: CellType = .all
    
    // MARK: - Methods
    
    
    func initiate(_ cellType: CellType = .all) {
        // Sets the cell type and initiates the API call
        self.cellType = cellType
        callApi(nil)
    }
    
    private func getCategories() -> [Category] {
        // Returns the list of categories if available, otherwise an empty array
        if let categories = categories {
            return categories
        } else {
            return []
        }
    }
    
    func getCurrentSelection() -> Int {
        // Returns the current selected category index
        return currentSelection
    }
    
    func updateSelection(_ indexPath: IndexPath) {
        // Updates the current selected category index
        currentSelection = indexPath.row
    }
    
    func getCountOfCategories() -> Int {
        // Returns the count of categories
        return getCategories().count
    }
    
    func getTitle(_ indexPath: IndexPath) -> String {
        // Returns the title for a category at the given index
        if let categories = categories {
            if let name = categories[indexPath.row].name {
                return name
            } else {
                return "error"
            }
        } else {
            return "n/a"
        }
    }
    
    func getCategoryCellSize() -> CGSize {
        // Returns the size for a category cell
        return CGSize(width: 90, height: 30)
    }
    
    func getMovieCellSize() -> CGSize {
        // Returns the size for a movie cell
        return CGSize(width: 110, height: 170)
    }
    
    private func getMovies() -> [Movie] {
        // Returns the list of movies if available, otherwise an empty array
        if let movies = movies {
            return movies
        } else {
            return []
        }
    }
    
    func getCountOfMovies() -> Int {
        // Returns the count of movies
        return getMovies().count
    }
    
    func getMovieTitle(_ indexPath: IndexPath) -> String {
        // Returns the title of the movie at the given index path
        if indexPath.row < getMovies().count {
            return "\(getMovies()[indexPath.row].title)"
        } else {
            return "n/a"
        }
    }
    
    func getPosterEndpoint(_ indexPath: IndexPath) -> String {
        // Returns the poster endpoint of the movie at the given index path
        if let endpoint = getMovies()[indexPath.row].posterPath {
            return endpoint
        } else {
            return "/hkxxMIGaiCTmrEArK7J56JTKUlB.jpg"
        }
    }
    
    func getPopular() {
        // Fetches popular movies from the API
        MovieViewModel.shared.getPopularMovies(completion: { [weak self] success, movies in
            if success {
                if let movies = movies {
                    self?.movies = movies
                    self?.isLoading.value = false
                    self?.isMoviesLoaded.value = true
                }
            }else{
                self?.error.value = true
            }
                
        })
    }
    
    func getGenreMovies(_ withCategory: String = "Action") {
        // Fetches movies of a specific genre from the API
        MovieViewModel.shared.getGenreMovies(withCategory, completion: { [weak self] success, movies in
            if success {
                if let movies = movies {
                    self?.movies = movies
                    self?.isLoading.value = false
                    self?.isMoviesLoaded.value = true
                }
            }else{
                self?.error.value = true
            }
        })
    }
    
    func getAllCategories() {
        // Fetches all categories from the API
        MovieViewModel.shared.getCategories(completion: { [weak self] success, categories in
            if success {
                if let categories = categories {
                    self?.categories = categories
                    self?.isLoading.value = false
                    self?.isLoaded.value = true
                }
            }else{
                self?.error.value = true
            }
        })
    }
    
    
    func callApi(_ genre: String?) {
        MovieViewModel.shared.checkConnectivity(completion: {[weak self] success in
            if success{
                self?.lastGenre = genre
                self?.isLoading.value = true
                
                // Fetches movies based on the specified genre or cell type
                if let genre = genre {
                    if self?.cellType == .all {
                        self?.getGenreMovies(genre)
                    } else {
                        self?.getPopular()
                    }
                } else {
                    // Fetches all categories and movies if no genre is specified
                    self?.getAllCategories()
                    if self?.cellType == .all {
                        self?.getGenreMovies()
                    } else {
                        self?.getPopular()
                    }
                }
            }else{
                self?.error.value = true
            }
        })
        // Sets the last genre and starts loading state
        
    }
    
    /// Shows an error toast message
    func showingErrorToast() {
        DispatchQueue.main.async {
            UIView.shared.showingToast("Error")
        }
    }
    
    /// Reloads the indexes of new items
    func reloadIndexes() -> [IndexPath]? {
        var indexPathsOfNewItems: [IndexPath]?
        if let categories = categories {
            if categories.count > 0 {
                indexPathsOfNewItems = []
                for i in categories.count - limit ..< categories.count {
                    let indexPath = IndexPath(row: i, section: 0)
                    indexPathsOfNewItems?.append(indexPath)
                }
            }
        }
        return indexPathsOfNewItems
    }
}


//https://image.tmdb.org/t/p/original//hkxxMIGaiCTmrEArK7J56JTKUlB.jpg
