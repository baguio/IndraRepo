//
//  MovieListTest.swift
//  TheMovieDBTests
//
//  Created by Jhonatan A. on 26/03/21.
//

import XCTest
import Combine
@testable import TheMovieDB

class MovieListTest: XCTestCase {
    private struct MockedLogic: MovieListLogicProtocol {
        let sessionSuccess: Bool
        let upcomingMoviesSuccess: Bool
        
        func obtainSession() -> AnyPublisher<Session, SessionManager.PersistedSessionError> {
            buildPublisher(
                success: sessionSuccess,
                value: Session(),
                error: SessionManager.PersistedSessionError.notAvailable
            )
        }
        
        func obtainUpcomingMovies(atPage page: Int) -> AnyPublisher<[Movie], Error> {
            buildPublisher(
                success: upcomingMoviesSuccess,
                value: [],
                error: SessionManager.PersistedSessionError.notAvailable
            )
        }
    }
    
    func testViewModel() throws {
        let viewModel = MovieListViewModel()
        viewModel.logic = MockedLogic(
            sessionSuccess: true, upcomingMoviesSuccess: true
        )
        
        do {
            _ = try await(viewModel.obtainUpcomingMovies())
        } catch {
            XCTFail()
        }
    }
}
