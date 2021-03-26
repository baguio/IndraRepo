//
//  MovieListViewModel.swift
//  TheMovieDB
//
//  Created by Jhonatan A. on 25/03/21.
//

import Foundation
import Combine

class MovieListViewModel {
    let logic = MovieListLogic()
    
    func obtainUpcomingMovies() -> AnyPublisher<[Movie], Swift.Error> {
        logic.obtainSession()
            .mapError { $0 as Swift.Error }
            .flatMap { _ in self.logic.obtainUpcomingMovies() }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
