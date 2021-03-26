//
//  TMDBManager.swift
//  TheMovieDB
//
//  Created by Jhonatan A. on 25/03/21.
//

import Foundation
import Combine
import SDWebImage

struct TMDBURL {
    private static let API_KEY = "003cbc01df91e2bb621b3203bf18ed53"
    
    static func configuration() -> URL  {
        var components = URLComponents(string: "https://api.themoviedb.org/3/configuration")!
        components.queryItems = [
            "api_key" : API_KEY
        ].map { URLQueryItem(name: $0, value: $1) }
        return components.url!
    }
    
    static func upcoming(at page: Int) -> URL  {
        var components = URLComponents(string: "https://api.themoviedb.org/3/movie/upcoming")!
        components.queryItems = [
            "api_key" : API_KEY,
            "page" : "\(page)"
        ].map { URLQueryItem(name: $0, value: $1) }
        return components.url!
    }
    
    static func poster(with path: String) -> URL {
        // TODO: Use /configuration API
        URL(string: "https://image.tmdb.org/t/p/w154\(path)")!
    }
}

class TMDBManager {
    let urlSession = URLSession.shared
    
    func obtainUpcomingMovies(at page: Int) -> AnyPublisher<UpcomingMoviesResult, Swift.Error> {
        urlSession.dataTaskPublisher(for: TMDBURL.upcoming(at: page))
            .map { $0.data }
            .decode(type: UpcomingMoviesResult.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func obtainMoviePoster(with path: String) -> AnyPublisher<Data, Swift.Error> {
        let publisher = PassthroughSubject<Data, Swift.Error>()
        let cancelable = SDWebImageManager.shared.loadImage(
            with: TMDBURL.poster(with: path),
            options: [],
            progress: nil
        ) { (_, data, error, _, _, _) in
            if let data = data {
                publisher.send(data)
                publisher.send(completion: .finished)
            } else if let error = error {
                publisher.send(completion: .failure(error))
            }
        }
        let handledPublisher = publisher.handleEvents(
            receiveSubscription: nil,
            receiveOutput: nil,
            receiveCompletion: nil,
            receiveCancel: {
                cancelable?.cancel()
            },
            receiveRequest: nil
        )

        return handledPublisher.eraseToAnyPublisher()
    }
}
