//
//  ImageCachingService.swift
//  Blockbuster
//
//  Created by Temp on 11/5/24.
//

import Foundation
import UIKit

final class ImageCachingService{
    static var shared = ImageCachingService()
    var image: UIImage?
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    func havingThisImage(_ enpoint: String) -> UIImage?{
        if let imageFromCache = imageCache.object(forKey: enpoint as AnyObject) as? UIImage {
            return imageFromCache
        }else{
            return nil
        }
    }
    
    func cacheImage(_ enpoint: String, data: Data){
        DispatchQueue.main.async {[weak self] in
            let imageToCache = UIImage(data: data)
            self?.imageCache.setObject(imageToCache!, forKey: enpoint as AnyObject)
            self?.image = imageToCache
        }
    }
}
