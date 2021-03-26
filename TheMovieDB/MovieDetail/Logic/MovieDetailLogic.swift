//
//  MovieDetailLogic.swift
//  TheMovieDB
//
//  Created by Jhonatan A. on 25/03/21.
//

import Foundation
import Combine
import SDWebImage

class MovieDetailLogic {
    func obtainPoster(for movie: Movie) -> AnyPublisher<Data, Swift.Error> {
        TMDBManager().obtainMoviePoster(with: movie.poster_path)
            .eraseToAnyPublisher()
    }
}
