//
//  ImageCachingService.swift
//  Blockbuster
//
//  Created by Temp on 11/5/24.
//

import Foundation
import UIKit

final class ImageCachingService {
    static var shared = ImageCachingService()
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    // MARK: - Caching using NSCache (Alternative Method)
    
//    /// Retrieves the cached image for the given endpoint from the NSCache.
//    ///
//    /// - Parameter endpoint: The endpoint of the image.
//    /// - Returns: The cached image if available, otherwise nil.
//    func havingThisImage(_ endpoint: String) -> UIImage? {
//        if let imageFromCache = imageCache.object(forKey: endpoint as AnyObject) as? UIImage {
//            return imageFromCache
//        } else {
//            return nil
//        }
//    }
//
//    /// Caches the image data for the given endpoint using NSCache.
//    ///
//    /// - Parameters:
//    ///   - endpoint: The endpoint of the image.
//    ///   - data: The image data to be cached.
//    func cacheImage(_ endpoint: String, data: Data) {
//        DispatchQueue.main.async { [weak self] in
//            let imageToCache = UIImage(data: data)
//            self?.imageCache.setObject(imageToCache!, forKey: endpoint as AnyObject)
//        }
//    }
    
    // MARK: - Caching using FileManager
    
    /// Retrieves the cached image for the given endpoint.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint of the image.
    ///   - completion: A closure to be called when the image retrieval is complete, containing the cached image.
    func havingThisImage(_ endpoint: String, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsDirectory.appendingPathComponent(endpoint)
            do {
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

    /// Caches the image data for the given endpoint.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint of the image.
    ///   - data: The image data to be cached.
    func cacheImage(_ endpoint: String, data: Data) {
        DispatchQueue.global(qos: .background).async {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsDirectory.appendingPathComponent(endpoint)
            do {
                try data.write(to: fileURL)
            } catch {
                print("Error saving image to file:", error)
            }
        }
    }
}
