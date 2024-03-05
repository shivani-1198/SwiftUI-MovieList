//
//  PosterImage.swift
//  MovieList
//
//  Created by Shivani Agarwal on 29/02/24.
//

import SwiftUI

struct PosterImage: View {
    
    @ObservedObject var posterImageModel: PosterImageModel
    
    init(movie: Movie) {
        posterImageModel = PosterImageModel(movie: movie)
    }
    
    var body: some View {
        ZStack {
            Image(uiImage: posterImageModel.image ?? UIImage(systemName: "paperplane.circle.fill")!)
                .renderingMode(.original)
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.screenWidth, height: 250)
        }
    }
}

struct PosterImage_Previews: PreviewProvider {
    static var previews: some View {
        PosterImage(movie: Movie.testMovie)
    }
}
