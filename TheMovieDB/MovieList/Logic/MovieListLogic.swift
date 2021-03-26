//
//  MovieListLogic.swift
//  TheMovieDB
//
//  Created by Jhonatan A. on 25/03/21.
//

import Foundation
import Combine

class MovieListLogic {
    let remoteManager = TMDBManager()
    
    func obtainSession() -> AnyPublisher<Session, SessionManager.ContinuousSessionError> {
        // TODO: Real session holding
        Fail<Session, SessionManager.ContinuousSessionError>(error: .notAvailable).eraseToAnyPublisher()
    }
    
    func obtainUpcomingMovies(atPage page: Int = 1) -> AnyPublisher<[Movie], Swift.Error> {
        remoteManager.obtainUpcomingMovies(at: page)
            .map { $0.results }
            .eraseToAnyPublisher()
    }
}
