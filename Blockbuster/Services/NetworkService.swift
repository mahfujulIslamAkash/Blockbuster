//
//  NetworkService.swift
//  Blockbuster
//
//  Created by Temp on 10/5/24.
//

import Foundation

final class NetworkService{
    static var shared = NetworkService()
    
    
    func getCategories(completion: @escaping(_ success: Bool, _ categories: [Category]?)-> Void){

        let url = URL(string: "https://api.themoviedb.org/3/genre/movie/list")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "language", value: "en"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5MjFlZmMyMGE4MTU2MjM2ZDI3NGVkNTMyOWQ1ZGM0MSIsInN1YiI6IjY2M2UwOTYwZGRlZjY0MjhlNzBmYTcwNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.wOGh6PlteVpFEH8GnWILB1495eRl4Lv8KCNWiCzp0bQ"
        ]
        
        let urlSession = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            
            if let _ = error{
                completion(false, nil)
            }else{
                if let data = data{
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            print("json: ", json)
                            // Accessing the entire JSON dictionary
                            if let dataArray = json["genres"] as? [[String: Any]] {
                                if dataArray.isEmpty{
                                    completion(false, nil)
                                }else{
                                    var categories: [Category] = []
                                    for data in dataArray {
                                        var category = Category()
                                        if let id = data["id"] as? String{
                                            category.id = id
                                        }
                                        if let url = data["name"] as? String{
                                            category.name = url
                                        }
                                        
                                        categories.append(category)
                                    }
                                    
                                    completion(true, categories)
                                }
                                
                                
                            }else {
                                //invalid data
                                completion(false, nil)
                            }
                        }}
                    catch{
                        completion(false, nil)
                        print("error")
                    }
                }
            }
//
//            
            
            
            
        })
        
        urlSession.resume()

        
    }
    
    func getPopularMovies(completion: @escaping(_ success: Bool, _ movies: [Movie]?)-> Void){

        let url = URL(string: "https://api.themoviedb.org/3/movie/popular")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "language", value: "en-US"),
          URLQueryItem(name: "page", value: "1"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5MjFlZmMyMGE4MTU2MjM2ZDI3NGVkNTMyOWQ1ZGM0MSIsInN1YiI6IjY2M2UwOTYwZGRlZjY0MjhlNzBmYTcwNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.wOGh6PlteVpFEH8GnWILB1495eRl4Lv8KCNWiCzp0bQ"
        ]
        
        let urlSession = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            
            if let _ = error{
                completion(false, nil)
            }else{
                if let data = data{
                    do {
                        let decoder = JSONDecoder()
                        let movieResponse = try decoder.decode(MovieResponse.self, from: data)
                        completion(true, movieResponse.results)
                    }
                    catch{
                        completion(false, nil)
                        print("error")
                    }
                }
            }
        })
        
        urlSession.resume()

        
        
    }
    
    func getGenreMovies(_ withCategory: String = "Action", completion: @escaping(_ success: Bool, _ movies: [Movie]?)-> Void){

        let url = URL(string: "https://api.themoviedb.org/3/search/movie")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "query", value: withCategory),
          URLQueryItem(name: "include_adult", value: "false"),
          URLQueryItem(name: "language", value: "en-US"),
          URLQueryItem(name: "page", value: "1"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5MjFlZmMyMGE4MTU2MjM2ZDI3NGVkNTMyOWQ1ZGM0MSIsInN1YiI6IjY2M2UwOTYwZGRlZjY0MjhlNzBmYTcwNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.wOGh6PlteVpFEH8GnWILB1495eRl4Lv8KCNWiCzp0bQ"
        ]
        
        let urlSession = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            
            if let _ = error{
                completion(false, nil)
            }else{
                if let data = data{
                    do {
                        let decoder = JSONDecoder()
                        let movieResponse = try decoder.decode(MovieResponse.self, from: data)
                        completion(true, movieResponse.results)
                    }
                    catch{
                        completion(false, nil)
                        print("error")
                    }
                }
            }
        })
        
        urlSession.resume()

        
        
    }
    
    func getImageData(_ endpoint: String, completion: @escaping(_ success: Bool, _ data: Data?)-> Void){
        var request = URLRequest(url: URL(string: "https://image.tmdb.org/t/p/original"+endpoint)!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5MjFlZmMyMGE4MTU2MjM2ZDI3NGVkNTMyOWQ1ZGM0MSIsInN1YiI6IjY2M2UwOTYwZGRlZjY0MjhlNzBmYTcwNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.wOGh6PlteVpFEH8GnWILB1495eRl4Lv8KCNWiCzp0bQ"
        ]
        
        let urlSession = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            
            if let _ = error{
                completion(false, nil)
            }else{
                if let data = data{
                    completion(true, data)
                }
            }
        })
        
        urlSession.resume()
            
    }
    
    //This func is helping to detect internet connection
    func checkConnectivity(completion: @escaping (Bool) -> Void) {
            guard let url = URL(string: "https://www.apple.com") else {
                completion(false) // Invalid URL
                return
            }
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error as NSError?, error.domain == NSURLErrorDomain {
                    // Error occurred, indicating no internet connection
                    completion(false)
                } else {
                    // No error, internet connection is available
                    completion(true)
                }
            }
            task.resume()
        }
     
}


//API key: 921efc20a8156236d274ed5329d5dc41
//access token: eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5MjFlZmMyMGE4MTU2MjM2ZDI3NGVkNTMyOWQ1ZGM0MSIsInN1YiI6IjY2M2UwOTYwZGRlZjY0MjhlNzBmYTcwNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.wOGh6PlteVpFEH8GnWILB1495eRl4Lv8KCNWiCzp0bQ
