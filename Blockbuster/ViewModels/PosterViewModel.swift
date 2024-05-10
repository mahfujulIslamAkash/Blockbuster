//
//  PosterViewModel.swift
//  Blockbuster
//
//  Created by Temp on 10/5/24.
//

import UIKit

class PosterViewModel{
    
    init(_ endpoint: String? = nil){
        self.endpoint = endpoint
    }
    
    static var shared = NetworkService()
    var poster: UIImage?
    var isLoaded: ObservableObject<Bool> = ObservableObject(false)
    var isLoading: ObservableObject<Bool> = ObservableObject(true)
    var error: ObservableObject<Bool?> = ObservableObject(nil)
    var endpoint: String?
    
    func getPoster(){
        if let endpoint = endpoint{
            isLoading.value = true
            ImageCachingService.shared.havingThisImage(endpoint, completion: {[weak self] image in
                if let image = image{
                    self?.poster = image
                    self?.isLoaded.value = true
                    self?.isLoading.value = false
                }else{
                    
                    PosterViewModel.shared.getImageData(endpoint, completion: {[weak self] sucess, data in
                        if sucess{
                            if let data = data{
                                ImageCachingService.shared.cacheImage(endpoint, data: data)
                                if let image = UIImage(data: data){
                                    self?.poster = image
                                    self?.isLoaded.value = true
                                    self?.isLoading.value = false
                                }
                                else{
                                    self?.isLoading.value = false
                                }
                            }
                            else{
                                self?.isLoading.value = false
                            }
                            
                        }
                        else{
                            self?.isLoading.value = false
                        }
                    })
                    
                }
                
                
            })
            
        }
    }
    func getPosterImage() -> UIImage{
        if let image = poster{
            return image
        }else{
            return UIImage()
        }
    }
}
