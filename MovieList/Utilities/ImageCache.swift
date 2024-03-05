//
//  ImageCache.swift
//  MovieList
//
//  Created by Shivani Agarwal on 29/02/24.
//

import Foundation
import SwiftUI

class ImageCache {
    static let imageCache = ImageCache()
    
    var cache = NSCache<NSString, UIImage>()
    
    func get(forKey: String) -> UIImage? {
        return cache.object(forKey: NSString(string: forKey))
    }
    
    func set(forKey: String, image: UIImage) {
        return cache.setObject(image, forKey: NSString(string: forKey))
    }
}
