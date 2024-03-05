//
//  MovieListViewModel.swift
//  MovieList
//
//  Created by Shivani Agarwal on 29/02/24.
//


//
import Foundation

final class MovieListViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var deletedMovies: [Int] = [] // Store IDs of deleted movies

    init() {
        // Load deleted movies from UserDefaults
        if let data = UserDefaults.standard.data(forKey: "DeletedMovies"),
           let deletedMovies = try? JSONDecoder().decode([Int].self, from: data) {
            self.deletedMovies = deletedMovies
        }
        loadMovies() // Load movies after loading deleted movies
    }


    func loadMovies() {
        if let movies = UserDefaults.standard.object(forKey: "movie_list") as? Data {
            self.movies = try! JSONDecoder().decode([Movie].self, from: movies)
        }else{
            NetworkManager.shared.getMovies { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let movies):
                        // Filter out deleted movies
                        
                        let undeletedMovies = movies.filter { !self.deletedMovies.contains($0.id) }
                        self.movies = undeletedMovies
                        let movieString = try? JSONEncoder().encode(undeletedMovies)
                        UserDefaults.standard.set(movieString, forKey: "movie_list")
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
        }
    }



    func deleteMovie(at index: Int) {
        let deletedMovieID = movies[index].id
        deletedMovies.append(deletedMovieID)
        saveDeletedMovies() // Save deleted movies to UserDefaults
        movies.remove(at: index)
        let movieString = try? JSONEncoder().encode(movies)
        UserDefaults.standard.set(movieString, forKey: "movie_list")
    }

    private func saveDeletedMovies() {
        if let encoded = try? JSONEncoder().encode(deletedMovies) {
            UserDefaults.standard.set(encoded, forKey: "DeletedMovies")
        }
    }
}



