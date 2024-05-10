//
//  PosterViewModel.swift
//  Blockbuster
//
//  Created by Temp on 10/5/24.
//

import UIKit

class PosterViewModel{
    
    init(){
//        if let endpoint = endpoint{
//            getPoster(endpoint)
//        }
    }
    static var shared = NetworkService()
    var poster: UIImage?
    var isLoaded: ObservableObject<Bool> = ObservableObject(false)
    var isLoading: ObservableObject<Bool> = ObservableObject(true)
    var error: ObservableObject<Bool?> = ObservableObject(nil)
    
    func getPoster(_ endpoint: String){
        isLoaded.value = false
        isLoading.value = true
        PosterViewModel.shared.getImageData(endpoint, completion: {[weak self] sucess, data in
            if sucess{
                if let data = data{
                    if let image = UIImage(data: data){
                        self?.poster = image
                        self?.isLoaded.value = true
                        self?.isLoading.value = false
                    }
                }
                
            }
        })
    }
    func getPosterImage() -> UIImage{
        if let image = poster{
            return image
        }else{
            return UIImage()
        }
    }
}
