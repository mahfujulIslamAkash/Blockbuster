//
//  PosterViewModel.swift
//  Blockbuster
//
//  Created by Temp on 10/5/24.
//

import UIKit

final class PosterViewModel {
    
    // MARK: - Properties
    
    static var shared = NetworkService()
    
    var poster: UIImage?
    var isLoaded: ObservableObject<Bool> = ObservableObject(false)
    var isLoading: ObservableObject<Bool> = ObservableObject(true)
    var error: ObservableObject<Bool?> = ObservableObject(nil)
    var endpoint: String?
    
    // MARK: - Initialization
    
    init(_ endpoint: String? = nil) {
        self.endpoint = endpoint
    }
    
    // MARK: - Methods
    
    /// Fetches the poster image from the endpoint
    func getPoster() {
        if let endpoint = endpoint {
            isLoading.value = true
            ImageCachingService.shared.havingThisImage(endpoint) { [weak self] image in
                if let image = image {
                    self?.poster = image
                    self?.isLoaded.value = true
                    self?.isLoading.value = false
                } else {
                    PosterViewModel.shared.getImageData(endpoint) { [weak self] success, data in
                        if success {
                            if let data = data {
                                ImageCachingService.shared.cacheImage(endpoint, data: data)
                                if let image = UIImage(data: data) {
                                    self?.poster = image
                                    self?.isLoaded.value = true
                                    self?.isLoading.value = false
                                } else {
                                    self?.isLoading.value = false
                                }
                            } else {
                                self?.isLoading.value = false
                            }
                        } else {
                            self?.isLoading.value = false
                        }
                    }
                }
            }
        }
    }
    
    /// Returns the poster image
    func getPosterImage() -> UIImage? {
        return poster
    }
}
