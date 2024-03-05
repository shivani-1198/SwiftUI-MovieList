//
//  MovieList.swift
//  MovieList
//
//  Created by Shivani Agarwal on 29/02/24.
//

import SwiftUI

struct MovieList: View {
    @ObservedObject var viewModel: MovieListViewModel
    @State var isDetailsActive:Bool = false
    @State var movie:Movie? = nil
    
        
        var body: some View {
            NavigationStack{
                ZStack{
                    LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .edgesIgnoringSafeArea(.all)
                    List {
                        ForEach(viewModel.movies) { movie in
                            NavigationLink(destination: MovieDetailView(movie: movie)) {
                                        MovieCell(movie: movie)
                            }
                        }
                        .onDelete(perform: deleteMovie)
                    }.navigationDestination(isPresented: self.$isDetailsActive){
                        if let movie = movie{
                            MovieDetailView(movie: movie)
                        }else{
                            EmptyView()
                        }
                    }
                }
            .navigationTitle("Movies")
            .listStyle(PlainListStyle())
            .onAppear {
                UITableView.appearance().separatorColor = .clear
                if let lastAccessedMovie = UserDefaults.standard.object(forKey: "last_accessed_movie") as? Data {
                    let lastMovie = try! JSONDecoder().decode(Movie.self, from: lastAccessedMovie)
                    self.movie = lastMovie
                    self.isDetailsActive = true
                }
                viewModel.loadMovies()
            }
        }
    }

    func deleteMovie(at offsets: IndexSet) {
        offsets.forEach { index in
            viewModel.deleteMovie(at: index)
        }
    }
}

