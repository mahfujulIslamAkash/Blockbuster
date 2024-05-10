//
//  NetworkService.swift
//  Blockbuster
//
//  Created by Temp on 10/5/24.
//

import Foundation

final class NetworkService{
    static var shared = NetworkService()
    
    private func getBasePathByOffset(_ searchText: String?, _ limit: Int = 30, _ offset: Int = 0) -> String{
        guard let text = searchText else{
            let path = "https://api.giphy.com/v1/gifs/search?api_key=229ac3e932794695b695e71a9076f4e5&limit=\(limit)&offset=\(offset)&rating=G&lang=en&q=" + "Trending"
            return path
        }
        let path = "https://api.giphy.com/v1/gifs/search?api_key=229ac3e932794695b695e71a9076f4e5&limit=\(limit)&offset=\(offset)&rating=G&lang=en&q=" + text
        return path
    }
    
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
    
    func getGenreMovies(_ withID: Int = 0, completion: @escaping(_ success: Bool, _ movies: [Movie]?)-> Void){

        let url = URL(string: "https://api.themoviedb.org/3/discover/movie")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "include_adult", value: "false"),
          URLQueryItem(name: "include_video", value: "false"),
          URLQueryItem(name: "language", value: "en-US"),
          URLQueryItem(name: "page", value: "1"),
          URLQueryItem(name: "sort_by", value: "popularity.desc"),
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
    
    //MARK: Respose for gify, tenor
//    private func getResponse(_ searchFor÷
    
    //MARK: Gify Data fetch using JSONSerialization
//    private func parsingForGify(data: Data?, completion: @escaping(_ success: Bool, [Movie]?)-> Void){
//        if let data = data{
//            do {
//                // Deserialize JSON data
//                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                    // Accessing the entire JSON dictionary
//                    if let dataArray = json["data"] as? [[String: Any]] {
//                        if dataArray.isEmpty{
//                            completion(false, nil)
//                        }else{
//                            var gifs: [Movie] = []
//                            for data in dataArray {
//                                var gif = Movie()
//                                if let id = data["id"] as? String{
//                                    gif.id = id
//                                }
//                                if let url = data["url"] as? String{
//                                    gif.url = url
//                                }
//                                if let image = data["images"] as? [String: Any]{
//                                    if let original = image["original"] as? [String: Any]{
//                                        if let url = original["url"] as? String{
//                                            gif.original = url
//                                        }
//                                    }
//                                    
//                                    if let preview = image["preview_gif"] as? [String: Any]{
//                                        if let url = preview["url"] as? String{
//                                            gif.placeHolder = url
//                                        }
//                                    }
//                                    
//                                    
//                                }
//                                gifs.append(gif)
//                            }
//                            
//                            completion(true, gifs)
//                        }
//                        
//                        
//                    }else {
//                        //invalid data
//                        completion(false, nil)
//                    }
//                } else {
//                    //print("Invalid JSON format")
//                    completion(false, nil)
//                }
//            } catch {
//                //print("Error parsing JSON: \(error)")
//                completion(false, nil)
//            }
//        }
//    }
    
    //MARK: Tenor Data fetch using JSONSerialization
//    private func parsingForTenor(data: Data?, completion: @escaping(_ success: Bool, [Movie]?)-> Void){
//        if let data = data{
//            do {
//                // Deserialize JSON data
//                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                    // Accessing the entire JSON dictionary
//                    if let dataArray = json["results"] as? [[String: Any]] {
//                        if dataArray.isEmpty{
//                            completion(false, nil)
//                        }else{
//                            var gifs: [Movie] = []
//                            for data in dataArray {
//                                var gif = Movie()
//                                if let id = data["id"] as? String{
//                                    gif.id = id
//                                }
//                                if let url = data["url"] as? String{
//                                    gif.url = url
//                                }
//                                if let medias = data["media"] as? [[String: Any]]{
//                                    for media in medias{
//                                        if let nanoGif = media["nanogif"] as? [String: Any]{
//                                            if let previewUrl = nanoGif["url"] as? String{
//                                                gif.placeHolder = previewUrl
//                                            }
//                                        }
//                                        
//                                        if let gifObjc = media["gif"] as? [String: Any]{
//                                            if let originalUrl = gifObjc["url"] as? String{
//                                                gif.original = originalUrl
//                                            }
//                                        }
//                                    }
//                                    
//                                    
//                                }
//                                gifs.append(gif)
//                            }
//                            
//                            completion(true, gifs)
//                        }
//                        
//                        
//                    }else {
//                        //invalid data
//                        completion(false, nil)
//                    }
//                } else {
//                    //print("Invalid JSON format")
//                    completion(false, nil)
//                }
//            } catch {
//                //print("Error parsing JSON: \(error)")
//                completion(false, nil)
//            }
//        }
//    }
    
    //This func will be called by the VM
    func getSearchedGifs(_ searchFor: String?, _ limit: Int = 30, _ offset: Int = 0, completion: @escaping(_ success: Bool, [Movie]?)-> Void){
//        getResponse(searchFor,limit, offset, completion: {success, result in
//            completion(success, result)
//        })
    }
    
    //This func will be called by the VM
//    func getGifResults()->[Gif]?{
//        return result
//    }
//    func clearResult(){
//        result = []
//    }
    
    //This function fetch the data from URL_path
    //Using for fetching gif file data
    //This func will be called by the VM
//    func gettingDataOf(_ dataPath: String, completion: @escaping(Data?)->Void){
//        if let url = URL(string: dataPath){
//            URLSession.shared.dataTask(with: url, completionHandler: {data, response, error in
//                if let _ = error{
//                    completion(nil)
//                }else{
//                    if let data = data{
//                        completion(data)
//                    }else{
//                        completion(nil)
//                    }
//                    
//                }
//            }).resume()
//        }else{
//            completion(nil)
//        }
//    }
    
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

//MARK: Provider Type
enum ProviderType{
    case gify
    case tenor
}

//API key: 921efc20a8156236d274ed5329d5dc41
//access token: eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5MjFlZmMyMGE4MTU2MjM2ZDI3NGVkNTMyOWQ1ZGM0MSIsInN1YiI6IjY2M2UwOTYwZGRlZjY0MjhlNzBmYTcwNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.wOGh6PlteVpFEH8GnWILB1495eRl4Lv8KCNWiCzp0bQ
