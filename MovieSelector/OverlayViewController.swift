//
//  OverlayViewController.swift
//  MovieSelector
//
//  Created by Vamshi Krishna on 03/12/17.
//  Copyright © 2017 Vamshi Krishna. All rights reserved.
//

import UIKit

class OverlayViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var movieItem:Movie!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configureView(){
        if let movie = movieItem{
            self.titleLabel.text = movie.title
            self.descriptionTextView.text = movie.description
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.bounds.size = CGSize(width: UIScreen.main.bounds.size.width - 20, height: 200)
        self.view.layer.cornerRadius = 5
         descriptionTextView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    

}
