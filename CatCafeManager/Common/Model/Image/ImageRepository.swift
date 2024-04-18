//
//  ImageRepository.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 18.12.2023.
//

import Foundation
import UIKit

protocol ImageRepositoryProtocol {
    func loadImage(url: URL?) async -> UIImage?
    func saveImage(image: UIImage?, url: URL?)
}

/// This class helps to work with images
final class ImageRepository: ImageRepositoryProtocol {
    private var imageCache: NSCache<NSString, UIImage>?
    
    init() {
        self.imageCache = NSCache<NSString, UIImage>()
    }
    
    /// Loads or get from cache the image by url
    /// - Parameter url: image url
    /// - Returns: UIImage or nil
    func loadImage(url: URL?) async -> UIImage? {
        guard let url = url else { return nil }
        
        if let image = imageCache?.object(forKey: url.absoluteString as NSString) {
            return image
        }
        
        if let data = try? Data(contentsOf: url) {
            return await MainActor.run {
                guard let loadedImage = UIImage(data: data) else {
                    return nil
                }
                imageCache?.setObject(loadedImage, forKey: url.absoluteString as NSString)
                return loadedImage
            }
        } else {
            return nil
        }
    }
    
    /// Saves the image
    /// - Parameters:
    ///   - image: UIImage
    ///   - url: url to save
    func saveImage(image: UIImage?, url: URL?) {
        guard let url = url else { return }
        if let image = image {
            if let data = image.jpegData(compressionQuality: 1.0) {
                try? data.write(to: url)
                imageCache?.setObject(image, forKey: url.absoluteString as NSString)
            }
        }
    }
    
    /// if we've a Memory Warning then we've clear the cache
    @objc private func didReceiveMemoryWarning() {
        imageCache?.removeAllObjects()
    }
}
