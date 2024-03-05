////
////  NetworkManager.swift
////  MovieList
////
////  Created by Shivani Agarwal on 29/02/24.

import Foundation
import UIKit

class NetworkManager {
///https://api.themoviedb.org/3/account/{account_id}
//    var movieList : Movie = Movie()
    static let shared = NetworkManager()
    private let baseURL = "https://api.themoviedb.org/4/list/1?language=en-US&page=1"
    private let baseUrlForImage = "https://image.tmdb.org/t/p/w500"
    private let bearerToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIzNDdlZDcxOTgxMTQ4OTMzYTQ4MjBmYWE4YjgzOGFiNiIsInN1YiI6IjY1ZGFhYzM2NjJmMzM1MDE0OTRjMWViMiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.gfejHjcPCIgzx_98HA7SeANr1B-7gHh-B7gZR0cAs8E"

    private init() {}

    func getMovies(completion: @escaping(Result<[Movie], MovieError>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(.INVALID_URL))
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
    
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.REQUEST_FAILED(error)))
                return
            }

            guard let data = data else {
                completion(.failure(.INVALID_DATA))
                return
            }

            do {
                let ans = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(ans.results))
            } catch {
                completion(.failure(.UNABLE_TO_DECODE))
            }
        }
        task.resume()
    }
    
    func getMovie(movieId:Int, completion: @escaping(Result<Movie, MovieError>) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)") else {
            completion(.failure(.INVALID_URL))
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
    
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.REQUEST_FAILED(error)))
                return
            }

            guard let data = data else {
                completion(.failure(.INVALID_DATA))
                return
            }

            do {
                let ans = try JSONDecoder().decode(Movie.self, from: data)
                completion(.success(ans))
            } catch {
                completion(.failure(.UNABLE_TO_DECODE))
            }
        }
        task.resume()
    }

    func getBackdropImage(imagePath: String, completion: @escaping(Result<UIImage, MovieError>) -> Void) {
        let url = baseUrlForImage + imagePath
        fetchImage(urlString: url, completion: completion)
    }

    func getPosterImage(posterURL: String, completion: @escaping(Result<UIImage, MovieError>) -> Void) {
        let url = baseUrlForImage + posterURL
        fetchImage(urlString: url, completion: completion)
    }

    private func fetchImage(urlString: String, completion: @escaping(Result<UIImage, MovieError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.INVALID_URL))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.REQUEST_FAILED(error)))
                return
            }

            guard let data = data else {
                completion(.failure(.INVALID_DATA))
                return
            }

            guard let loadedImage = UIImage(data: data) else {
                completion(.failure(.UNABLE_TO_CREATE_IMAGE))
                return
            }

            completion(.success(loadedImage))
        }
        task.resume()
    }
}


