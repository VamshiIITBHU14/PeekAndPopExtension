//
//  MovieDetailViewController.swift
//  MovieSelector
//
//  Created by Vamshi Krishna on 03/12/17.
//  Copyright © 2017 Vamshi Krishna. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDescriptionTextView: UITextView!
    var movieObect:Movie!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureView()
    }
    
    func configureView(){
        movieTitleLabel.text = movieObect.title
        movieDescriptionTextView.text = movieObect.description
        
        if let availableImage = Movie.getImage(forMovie: movieObect){
            movieImageView.image = availableImage
        }
    }
}
