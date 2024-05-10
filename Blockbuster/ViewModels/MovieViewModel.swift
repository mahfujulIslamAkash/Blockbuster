//
//  MovieViewModel.swift
//  Blockbuster
//
//  Created by Temp on 10/5/24.
//

import Foundation
import UIKit

class MovieViewModel{
    // MARK: - Properties
    static var shared = NetworkService()
    private var currentOffset: Int = 0
    private var limit: Int = 20
    
    var categories: [Category]?
    var movies: [Movie]?
        
    var isLoaded: ObservableObject<Bool?> = ObservableObject(nil)
    var isMoviesLoaded: ObservableObject<Bool?> = ObservableObject(nil)
    var isLoading: ObservableObject<Bool> = ObservableObject(true)
    var error: ObservableObject<Bool?> = ObservableObject(nil)
    
    var cellType: CellType = .all
    
    func initiate(_ cellType: CellType = .all){
        self.cellType = cellType
        callApi()
    }
    private func getCategories() -> [Category]{
        if let categories = categories{
            return categories
        }else{
            return []
        }
    }
    func getCountOfCategories() -> Int{
        return getCategories().count
    }
    private func getMovies() -> [Movie]{
        if let movies = movies{
            return movies
        }else{
            return []
        }
    }
    func getCountOfMovies() -> Int{
        return getMovies().count
    }
    
    func getTitle(_ indexPath: IndexPath) -> String{
        if let categories = categories{
            if let name = categories[indexPath.row].name{
                return name
            }else{
                return "error"
            }
            
        }else{
            return "n/a"
        }
    }
    
    func getMovieTitle(_ indexPath: IndexPath) -> String{
        return "\(getMovies()[indexPath.row].id)"
    }
    func getPosterEndpoint(_ indexPath: IndexPath) -> String{
        if let endpoint = getMovies()[indexPath.row].posterPath{
            return endpoint
        }else{
            return "/hkxxMIGaiCTmrEArK7J56JTKUlB.jpg"
        }
        
    }
    
    func callApi(){
        MovieViewModel.shared.getCategories(completion: {[weak self] success, categories in
            if success{
                if let categories = categories{
                    self?.categories = categories
                    self?.isLoading.value = false
                    self?.isLoaded.value = true
                }
            }
            
        })
        
        if cellType == .all{
            MovieViewModel.shared.getGenreMovies(completion: {[weak self] success, movies in
                if success{
                    if let movies = movies{
                        self?.movies = movies
                        self?.isLoading.value = false
                        self?.isMoviesLoaded.value = true
                    }
                }
                
            })
        }else{
            MovieViewModel.shared.getPopularMovies(completion: {[weak self] success, movies in
                if success{
                    if let movies = movies{
                        self?.movies = movies
                        self?.isLoading.value = false
                        self?.isMoviesLoaded.value = true
                    }
                }
                
            })
        }
        
    }
    
    
    
    /// Shows an error toast message
    func showingErrorToast() {
        DispatchQueue.main.async {
            UIView.shared.showingToast("Error")
        }
    }
    
    func reloadIndexes() ->[IndexPath]?{
        
        var indexPathsOfNewItems: [IndexPath]?
        if let categories = categories{
            if categories.count > 0{
                indexPathsOfNewItems = []
                for i in categories.count-limit..<categories.count{
                    let indexPath = IndexPath(row: i, section: 0)
                    indexPathsOfNewItems?.append(indexPath)
                }
            }
        }
        return indexPathsOfNewItems
    }
    

}

//https://image.tmdb.org/t/p/original//hkxxMIGaiCTmrEArK7J56JTKUlB.jpg
