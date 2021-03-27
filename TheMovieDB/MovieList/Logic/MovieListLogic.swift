//
//  MovieListLogic.swift
//  TheMovieDB
//
//  Created by Jhonatan A. on 25/03/21.
//

import Foundation
import Combine

protocol MovieListLogicProtocol {
    func obtainSession(
    ) -> AnyPublisher<Session, SessionManager.PersistedSessionError>
    
    func obtainUpcomingMovies(
        atPage page: Int
    ) -> AnyPublisher<[Movie], Swift.Error>
}

extension MovieListLogicProtocol {
    func obtainUpcomingMovies() -> AnyPublisher<[Movie], Swift.Error> {
        obtainUpcomingMovies(atPage: 1)
    }
}

class MovieListLogic: MovieListLogicProtocol {
    let remoteManager = TMDBRemoteManager()
    let sessionManager = SessionManager()
    
    func obtainSession() -> AnyPublisher<Session, SessionManager.ContinuousSessionError> {
        SessionManager().obtainPersistedSession()
    }
    
    func obtainUpcomingMovies(atPage page: Int = 1) -> AnyPublisher<[Movie], Swift.Error> {
        remoteManager.obtainUpcomingMovies(at: page)
            .map { $0.results }
            .eraseToAnyPublisher()
    }
}
