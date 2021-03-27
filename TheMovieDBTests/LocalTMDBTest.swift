//
//  LocalTMDBTest.swift
//  TheMovieDBTests
//
//  Created by Jhonatan A. on 26/03/21.
//

import XCTest
@testable import TheMovieDB

class LocalTMDBTest: XCTestCase {
    func testEntities() throws {
        // Are entities available? (Properly setup on CoreData and TMDBLocalManager)
        let helpers = TMDBLocalManager.helpers()
        XCTAssertNotNil(helpers)
        
        // Can helpers build entities?
        do {
            _ = try helpers?.moviesHelper.query()
            _ = try helpers?.upcomingMoviesPageHelper.query()
            _ = try helpers?.upcomingMoviesDataHelper.query()
        } catch {
            XCTFail()
        }
    }
    
    func testRetrieving() {
        let manager = TMDBLocalManager()
        
        // According to TMDB's API
        // There's should never be a page 0
        do {
            _ = try await(manager.retrieveMovies(forPage: 0))
            XCTFail()
        } catch TMDBLocalManager.Error.pageNotAvailable {
        } catch {
            XCTFail()
        }
        
        
        // There could be a page 1 saved
        // TODO: CoreDataHelper mocking
        do {
            _ = try await(manager.retrieveMovies(forPage: 1))
        } catch TMDBLocalManager.Error.pageNotAvailable {
        } catch {
            XCTFail()
        }
    }
}
