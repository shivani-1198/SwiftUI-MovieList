//
//  RatingStars.swift
//  MovieList
//
//  Created by Shivani Agarwal on 01/03/24.
//

import SwiftUI

struct RatingStars: View {
    var rating: Double
    
    var body: some View {
        HStack {
            let filledStars = Int(rating / 2)
            ForEach(0..<filledStars, id: \.self) { _ in
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
            ForEach(0..<5-filledStars, id: \.self) { _ in
                Image(systemName: "star")
                    .foregroundColor(.gray)
            }
        }
    }
}
