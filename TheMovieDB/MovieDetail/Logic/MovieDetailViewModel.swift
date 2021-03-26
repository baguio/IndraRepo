//
//  MovieDetailViewModel.swift
//  TheMovieDB
//
//  Created by Jhonatan A. on 25/03/21.
//

import Foundation
import Combine

class MovieDetailViewModel {
    let movie: Movie
    let logic = MovieDetailLogic()
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    func obtainPoster() -> AnyPublisher<Data, Swift.Error>{
        logic.obtainPoster(for: movie)
    }
}
