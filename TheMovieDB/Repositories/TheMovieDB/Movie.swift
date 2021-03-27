//
//  Movie.swift
//  TheMovieDB
//
//  Created by Jhonatan A. on 25/03/21.
//

import Foundation

struct Movie: Codable {
    let overview: String
    let poster_path: String
    let release_date: String // Date "2021-03-03"
    let title: String
    let vote_average: Double
}

extension Movie {
    static func fromLocal(_ movie: LocalMovie) -> Movie? {
        let vote_average = movie.vote_average
        guard
            let title = movie.title,
            let overview = movie.overview,
            let poster_path = movie.poster_path,
            let release_date = movie.release_date
        else {
            assertionFailure("Should not be empty")
            return nil
        }
        
        return Movie(
            overview: overview,
            poster_path: poster_path,
            release_date: release_date,
            title: title,
            vote_average: vote_average
        )
    }
}
