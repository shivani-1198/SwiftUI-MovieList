//
//  MovieDetailView.swift
//  MovieList
//
//  Created by Shivani Agarwal on 29/02/24.
//


import SwiftUI

struct MovieDetailView: View {
    var movie: Movie
    @State private var genres: [Genre]?
    @State private var images: [UIImage] = []

    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    Text(movie.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10){
                            ForEach(0..<2, id: \.self) { _ in
                                ForEach(images, id: \.self) { image in
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 200, height: 300)
                                        .cornerRadius(12)
                                }
                            }
                        
                        }
                        .padding(.horizontal)
                    }

                    VStack(alignment: .leading, spacing: 8){
                        HStack{
                            RatingStars(rating: movie.vote_average)
                                .foregroundColor(.yellow)
                                .padding(.horizontal)
                            Text("Release Date: \(movie.release_date)")
                                .font(.subheadline)
                                .foregroundColor(.black)
                                .padding(.horizontal)
                            
                        }
                        if let genres = self.genres {
                            Text("Genres:")
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            ForEach(0..<genres.count, id: \.self) { index in
                                Text(genres[index].name ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                    .padding(.horizontal)
                            }
                        }
                        Spacer()
                        Text("Description")
                            .fontWeight(.bold)
                        Text(movie.overview)
                            .font(.body)
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal)
                        
                    }
                }
                .padding()
                .onAppear {
                    let movieData = try? JSONEncoder().encode(self.movie)
                    UserDefaults.standard.set(movieData, forKey: "last_accessed_movie")
                    NetworkManager.shared.getMovie(movieId: movie.id){ result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let movie):
                                // Filter out deleted movies
                                if let genres = movie.genres{
                                    self.genres = []
                                    for genre in genres{
                                        self.genres?.append(genre)
                                        print(genre.name ?? "Not available")
                                    }
                                    
                                }
                            case .failure(let err):
                                switch err {
                                case .INVALID_DATA:
                                    print("Invalid data!")
                                case .UNABLE_TO_DECODE:
                                    print("Unable to decode!")
                                case .UNABLE_TO_CREATE_IMAGE:
                                    print("Unable to convert Image!")
                                case .REQUEST_FAILED(let error):
                                    print("Request failed with error: \(error.localizedDescription)")
                                case .INVALID_URL:
                                    print("Invalid URL!")
                                case .INVALID_RESPONSE:
                                    print("Invalid response!")
                                }
                            }
                        }
                    }
                    loadImages()
                }
                .onDisappear{
                    UserDefaults.standard.removeObject(forKey: "last_accessed_movie")
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    func loadImages() {
        if let posterPath = movie.poster_path,
           let backdropPath = movie.backdrop_path {
            NetworkManager.shared.getPosterImage(posterURL: posterPath) { result in
                handleImageResult(result: result)
            }

            NetworkManager.shared.getBackdropImage(imagePath: backdropPath) { result in
                handleImageResult(result: result)
            }
        }
    }

    func handleImageResult(result: Result<UIImage, MovieError>) {
        switch result {
        case .success(let image):
            DispatchQueue.main.async {
                images.append(image)
            }
        case .failure(let error):
            print("Failed to fetch image: \(error)")
        }
    }
}
