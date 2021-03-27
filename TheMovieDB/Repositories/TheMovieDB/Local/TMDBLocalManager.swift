//
//  TMDBLocalManager.swift
//  TheMovieDB
//
//  Created by Jhonatan A. on 26/03/21.
//

import UIKit
import CoreData
import Combine

final class TMDBLocalManager {
    var upcomingMoviesDataHelper: CoreDataHelper<LocalUpcomingMoviesData>
    var upcomingMoviesPageHelper: CoreDataHelper<LocalUpcomingMoviesPage>
    var moviesHelper: CoreDataHelper<LocalMovie>
    
    private init(helpers: (
        upcomingMoviesDataHelper: CoreDataHelper<LocalUpcomingMoviesData>,
        upcomingMoviesPageHelper: CoreDataHelper<LocalUpcomingMoviesPage>,
        moviesHelper: CoreDataHelper<LocalMovie>
    )) {
        self.upcomingMoviesDataHelper = helpers.upcomingMoviesDataHelper
        self.upcomingMoviesPageHelper = helpers.upcomingMoviesPageHelper
        self.moviesHelper = helpers.moviesHelper
    }
    
    static func helpers() -> (
        upcomingMoviesDataHelper: CoreDataHelper<LocalUpcomingMoviesData>,
        upcomingMoviesPageHelper: CoreDataHelper<LocalUpcomingMoviesPage>,
        moviesHelper: CoreDataHelper<LocalMovie>
    )? {
        guard
            let upcomingMoviesDataHelper = CoreDataHelper<LocalUpcomingMoviesData>(),
            let upcomingMoviesPageHelper = CoreDataHelper<LocalUpcomingMoviesPage>(),
            let moviesHelper = CoreDataHelper<LocalMovie>()
        else {
            return nil
        }
        return (
            upcomingMoviesDataHelper: upcomingMoviesDataHelper,
            upcomingMoviesPageHelper: upcomingMoviesPageHelper,
            moviesHelper: moviesHelper
        )
    }
    
    convenience init() {
        self.init(helpers: Self.helpers()!)
    }
    
    enum Error: Swift.Error {
        case pageNotAvailable
    }
}

// Note: Using Publishers for these methods has proven problematic
// TODO: Skip using Combine altogether
extension TMDBLocalManager {
    func saveUpcomingMovies(
        _ upcomingMovies: UpcomingMoviesResult
    ) -> AnyPublisher<Void, Swift.Error> {
        let publisher = PassthroughSubject<Void, Swift.Error>()
        
        return publisher
            .handleEvents(
                receiveSubscription: { (_) in
                    self.saveUpcomingMovies(data: upcomingMovies, publisher: publisher)
                },
                receiveOutput: nil,
                receiveCompletion: nil,
                receiveCancel: nil,
                receiveRequest: nil
            )
            .eraseToAnyPublisher()
    }
    
    private func saveUpcomingMovies(
        data: UpcomingMoviesResult,
        publisher: PassthroughSubject<Void, Swift.Error>
    ) {
        let newLocalUMData = upcomingMoviesDataHelper.create()
        
        newLocalUMData.query_date = Date()
        newLocalUMData.total_pages = Int16(data.total_pages)
        newLocalUMData.total_movies = Int16(data.total_results)
        
        let newLocalUMPage = upcomingMoviesPageHelper.create()
        newLocalUMPage.page = Int16(data.page)
        
        loop: for movie in data.results {
            let newLocalMovie = moviesHelper.create()
            newLocalMovie.page = Int16(data.page)
            newLocalMovie.title = movie.title
            newLocalMovie.overview = movie.overview
            newLocalMovie.poster_path = movie.poster_path
            newLocalMovie.release_date = movie.release_date
            newLocalMovie.vote_average = movie.vote_average
        }
        
        do {
            try CoreDataHelper.save()
            publisher.send(completion: .finished)
        } catch {
            publisher.send(completion: .failure(error))
        }
    }
}

extension TMDBLocalManager {
    func retrieveMovies(forPage page: Int) -> AnyPublisher<[LocalMovie], Swift.Error> {
        let publisher = PassthroughSubject<[LocalMovie], Swift.Error>()
        
        return publisher
            .handleEvents(
                receiveSubscription: { (_) in
                    self.retrieveMovies(page: page, publisher: publisher)
                },
                receiveOutput: nil,
                receiveCompletion: nil,
                receiveCancel: nil,
                receiveRequest: nil
            )
            .eraseToAnyPublisher()
    }
    
    private func retrieveMovies(
        page: Int,
        publisher: PassthroughSubject<[LocalMovie], Swift.Error>)
    {
        do {
            let results = try upcomingMoviesDataHelper.query()
            
            guard
                let result = results.first,
                result.total_pages > page
            else {
                throw Error.pageNotAvailable
            }
            
            let rawResult = try upcomingMoviesPageHelper.query(predicate: "page = %@", "\(page)")
            guard rawResult.count > 0 else {
                throw Error.pageNotAvailable
            }
        } catch {
            publisher.send(completion: .failure(Error.pageNotAvailable))
            return
        }
        
        do {
            let result = try moviesHelper.query(predicate: "page = %@", "\(page)")
            publisher.send(result)
            publisher.send(completion: .finished)
        } catch {
            publisher.send(completion: .failure(error))
        }
    }
}
