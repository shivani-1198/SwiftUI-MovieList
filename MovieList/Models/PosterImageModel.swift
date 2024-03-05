//
//  PosterImageModel.swift
//  MovieList
//
//  Created by Shivani Agarwal on 29/02/24.
//

import Foundation
import SwiftUI

class PosterImageModel: ObservableObject {
    @Published var image: UIImage?
    var movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
        loadImage()
    }
    
    func getImage() -> Bool {
        if let posterPath = movie.poster_path {
            guard let cachedImage = ImageCache.imageCache.get(forKey: posterPath) else {
                return false
            }
            image = cachedImage
            return true
        } else {
            return false
        }
    }
    
    func loadImage() {
        if let posterPath = movie.poster_path {
            NetworkManager.shared.getPosterImage(posterURL: posterPath) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let posterImage):
                    ImageCache.imageCache.set(forKey: posterPath, image: posterImage)
                    DispatchQueue.main.async {
                        self.image = posterImage
                    }
                case .failure(_):
                    break
                }
            }
        }
    }
}
