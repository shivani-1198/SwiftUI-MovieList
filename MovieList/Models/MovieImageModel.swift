//
//  MovieImageModel.swift
//  MovieList
//
//  Created by Shivani Agarwal on 29/02/24.
//
import Foundation
import SwiftUI

class MovieImageModel: ObservableObject {
    @Published var image: UIImage?
    var movie: Movie

    init(movie: Movie) {
        self.movie = movie
        getImage()
    }

    func getImage() {
        if loadImageFromCache() {
            return
        }
        loadImage()
    }

    func loadImageFromCache() -> Bool {
        if let backdropPath = movie.backdrop_path {
            guard let cachedImage = ImageCache.imageCache.get(forKey: backdropPath) else {
                return false
            }
            image = cachedImage
            return true
        } else {
            return false
        }
    }

    func loadImage() {
        if let backdropPath = movie.backdrop_path {
            NetworkManager.shared.getBackdropImage(imagePath: backdropPath) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let image):
                    ImageCache.imageCache.set(forKey: backdropPath, image: image)
                    DispatchQueue.main.async {
                        self.image = image
                    }
                case .failure(_): break
                }
            }

        }
    }
}

