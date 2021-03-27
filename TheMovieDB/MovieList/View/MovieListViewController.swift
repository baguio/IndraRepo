//
//  MovieListViewController.swift
//  TheMovieDB
//
//  Created by Jhonatan A. on 25/03/21.
//

import UIKit
import Combine

class MovieListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.movies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        guard let movie = movies?[indexPath.row] else {
            return cell
        }
        
        cell.textLabel?.text = movie.title
        return cell
    }
    
    @IBOutlet weak var tableView: UITableView! {
        willSet {
            newValue.register(MovieListCell.self, forCellReuseIdentifier: "cell")
            newValue.dataSource = self
            newValue.delegate = self
        }
    }
    
    let viewModel = MovieListViewModel()
    var obtainMoviesSink: AnyCancellable?
    var movies: [Movie]?
    
    override func viewDidAppear(_ animated: Bool) {
        obtainMoviesSink = viewModel.obtainUpcomingMovies()
            .sink(receiveCompletion: { (result) in
                if case .failure(let error) = result, error is SessionManager.PersistedSessionError {
                    self.performSegue(withIdentifier: "signIn", sender: nil)
                }
            }, receiveValue: { (movies) in
                self.movies = movies
                self.tableView.reloadData()
            })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "detail":
            guard
                let destination = segue.destination as? MovieDetailViewController,
                let indexPath = sender as? IndexPath,
                let movie = movies?[indexPath.row]
            else {
                return
            }
            
            destination.viewModel = MovieDetailViewModel(movie: movie)
        default: return
        }
    }
}
