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
