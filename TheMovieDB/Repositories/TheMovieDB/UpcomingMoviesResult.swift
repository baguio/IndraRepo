//
//  UpcomingMoviesResult.swift
//  TheMovieDB
//
//  Created by Jhonatan A. on 25/03/21.
//

import Foundation

struct UpcomingMoviesResult: Codable {
    let total_pages: Int
    let total_results: Int
    let results : [Movie]
}
