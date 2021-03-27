//
//  MovieDetailTest.swift
//  TheMovieDBTests
//
//  Created by Jhonatan A. on 26/03/21.
//

import XCTest
import Combine
@testable import TheMovieDB

class MovieDetailTest: XCTestCase {
    private struct MockedLogic: MovieDetailLogicProtocol {
        enum Error: Swift.Error { case mock }
        let posterSuccess: Bool
        
        func obtainPoster(for movie: Movie) -> AnyPublisher<Data, Swift.Error> {
            buildPublisher(
                success: posterSuccess,
                value: Data(),
                error: Error.mock
            )
        }
    }
    

    func testViewModel() throws {
        let viewModel = MovieDetailViewModel(movie: Movie(
            overview: "",
            poster_path: "",
            release_date: "",
            title: "",
            vote_average: 0
        ))
        viewModel.logic = MockedLogic(
            posterSuccess: true
        )
        
        do {
            let data = try await(viewModel.obtainPoster())
            XCTAssertEqual(data, Data())
        } catch {
            XCTFail()
        }
    }
}
