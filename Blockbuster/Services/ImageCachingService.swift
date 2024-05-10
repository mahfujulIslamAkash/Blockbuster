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
    
    //caching using NSCache
//    func havingThisImage(_ enpoint: String) -> UIImage?{
//        if let imageFromCache = imageCache.object(forKey: enpoint as AnyObject) as? UIImage {
//            return imageFromCache
//        }else{
//            return nil
//        }
//    }
//    
//    func cacheImage(_ enpoint: String, data: Data){
//        DispatchQueue.main.async {[weak self] in
//            let imageToCache = UIImage(data: data)
//            self?.imageCache.setObject(imageToCache!, forKey: enpoint as AnyObject)
//            self?.image = imageToCache
//        }
//    }
    
    //caching using local file manager
    func havingThisImage(_ endpoint: String, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

            // Append filename to the document directory URL
            let fileURL = documentsDirectory.appendingPathComponent(endpoint)

            do {
                // Read data from file
                let imageData = try Data(contentsOf: fileURL)
                let image = UIImage(data: imageData)
                completion(image)
                
            } catch {
                print("Error getting image data from file:", error)
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }

    
    func cacheImage(_ enpoint: String, data: Data){
        DispatchQueue.global(qos: .background).async {
            // Get the document directory URL
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // Append filename to the document directory URL
            let fileURL = documentsDirectory.appendingPathComponent(enpoint)
            
            do {
                // Write data to file
                try data.write(to: fileURL)
            } catch {
                print("Error saving image to file:", error)
            }
        }
        
    }
}
