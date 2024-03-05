//
//  MovieImage.swift
//  MovieList
//
//  Created by Shivani Agarwal on 29/02/24.
//

import SwiftUI

struct MovieImage: View {
   
   @ObservedObject var movieImageModel : MovieImageModel
   
   init(movie: Movie) {
       movieImageModel = MovieImageModel(movie: movie)
   }
   
   var body: some View {
       Image(uiImage: (movieImageModel.image ?? UIImage(systemName: "bell.badge"))!)
           .renderingMode(.original)
           .resizable()
           .frame(width: 140, height: 170)
           .cornerRadius(10)
   }
}

struct MovieImage_Previews: PreviewProvider {
   static var previews: some View {
       MovieImage(movie: Movie.testMovie)
   }
}
