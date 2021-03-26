//
//  MovieDetailViewController.swift
//  TheMovieDB
//
//  Created by Jhonatan A. on 25/03/21.
//

import UIKit
import UICircularProgressRingLegacy
import Combine

class MovieDetailViewController: UIViewController {
    var viewModel: MovieDetailViewModel!
    
    @IBOutlet weak var circleViewHolder: UIView! {
        willSet {
            let circleView = UICircularProgressRing()
            newValue.translatesAutoresizingMaskIntoConstraints = false
            circleView.translatesAutoresizingMaskIntoConstraints = false
            newValue.addSubview(circleView)
            NSLayoutConstraint.activate([
                circleView.topAnchor.constraint(equalTo: newValue.topAnchor),
                circleView.leftAnchor.constraint(equalTo: newValue.leftAnchor),
                circleView.rightAnchor.constraint(equalTo: newValue.rightAnchor),
                circleView.bottomAnchor.constraint(equalTo: newValue.bottomAnchor)
            ])
            circleView.value = CGFloat(viewModel.movie.vote_average * 10)
            circleView.outerRingWidth = 0
            circleView.innerRingWidth = 16
            circleView.innerRingColor = .systemGreen
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel! {
        willSet {
            newValue.text = viewModel.movie.title
        }
    }
    
    @IBOutlet weak var overviewLabel: UILabel! {
        willSet {
            newValue.text = viewModel.movie.overview
        }
    }
    
    @IBOutlet weak var releaseDateLabel: UILabel! {
        willSet {
            newValue.text = viewModel.movie.release_date
        }
    }
    
    var imageLoadSink: AnyCancellable?
    @IBOutlet weak var posterImageView: UIImageView! {
        willSet {
            imageLoadSink = viewModel.obtainPoster().sink { (completion) in
                print(completion)
            } receiveValue: { (data) in
                newValue.image = UIImage(data: data)
            }
        }
    }
    
    @IBAction func closeButtonTriggered(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
