//
//  MovieTableViewController.swift
//  MovieSelector
//
//  Created by Vamshi Krishna on 01/12/17.
//  Copyright © 2017 Vamshi Krishna. All rights reserved.
//

import UIKit

class MovieTableViewController: UITableViewController {
    
    var nowPlaying = [Movie]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData(){
        Movie.nowPlaying { (success:Bool, movieArray:[Movie]?) in
            if success{
                self.nowPlaying = movieArray!
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nowPlaying.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let movie = nowPlaying[indexPath.row]
        cell.textLabel?.text = movie.title
        Movie.getImage(forCell: cell, withMovieObject: movie)
        return cell
    }
    
    
 
}
