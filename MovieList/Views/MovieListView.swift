//
//  MovieListView.swift
//  MovieList
//
//  Created by Shivani Agarwal on 29/02/24.
//


import SwiftUI

struct MovieListView: View {
    @StateObject private var viewModel = MovieListViewModel()
    
    var body: some View {
            NavigationView {
                MovieList(viewModel: viewModel)
            }
        
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView()
    }
}

