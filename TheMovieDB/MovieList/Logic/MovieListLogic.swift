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
    let localManager = TMDBLocalManager()
    let sessionManager = SessionManager()
    
    func obtainSession() -> AnyPublisher<Session, SessionManager.PersistedSessionError> {
        SessionManager().obtainPersistedSession()
    }
    
    func obtainUpcomingMovies(atPage page: Int) -> AnyPublisher<[Movie], Swift.Error> {
        enum RemoteOrLocalMovies {
            case local([LocalMovie])
            case remote([Movie])
        }
        
//        return localManager.retrieveMovies(forPage: page)
//            .map { $0 as [LocalMovie]? }
//            .replaceError(with: nil)
//            .flatMap { localMovies -> AnyPublisher<[Movie], Swift.Error> in
//                if let localMovies = localMovies {
//                    return Just<[Movie]>(
//                        localMovies.compactMap { Movie.fromLocal($0) }
//                    )
//                    .mapError { $0 as Swift.Error }
//                    .eraseToAnyPublisher()
//                } else {
                    return self.remoteManager.obtainUpcomingMovies(at: page)
//                        .flatMap { movies -> AnyPublisher<[Movie], Swift.Error> in
//                            self.localManager.saveUpcomingMovies(movies)
//                        }
                        .map { $0.results }
                        .eraseToAnyPublisher()
//                }
//            }
//            .eraseToAnyPublisher()
    }
}
