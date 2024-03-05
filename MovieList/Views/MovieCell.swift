//
//  MovieCell.swift
//  MovieList
//
//  Created by Shivani Agarwal on 29/02/24.
//

import SwiftUI

struct MovieCell: View {
    
    var movie: Movie
    
    var body: some View {
        HStack {
            MovieImage(movie: movie)
            VStack (alignment: .leading) {
                Text(movie.title)
                    .font(.system(size: 23,
                                  weight: .bold,
                                  design: .default))
                    .lineLimit(2)
            } .frame(height: 190)
        }
    }
    
}

struct MovieCell_Previews: PreviewProvider {
    static var previews: some View {
        MovieCell(movie: Movie.testMovie)
    }
        
}

