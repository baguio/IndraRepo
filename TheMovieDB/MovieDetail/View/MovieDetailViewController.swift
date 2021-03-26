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
    @IBOutlet weak var circleViewHolder: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    var viewModel: MovieDetailViewModel!
    @IBAction func closeButtonTriggered(_ sender: Any) {
    }
}
