//
//  TodayViewController.swift
//  MovieSelectorExtension
//
//  Created by Vamshi Krishna on 03/12/17.
//  Copyright © 2017 Vamshi Krishna. All rights reserved.
//

import UIKit
import NotificationCenter
import MovieSelectorBridge

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var movieTableView: UITableView!
    var compact = true
    
    var nowPlaying = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        movieTableView.separatorStyle = .none
        movieTableView.delegate = self
        movieTableView.dataSource = self
        
        loadData()
    }
    
    func loadData(){
        Movie.nowPlaying { (success:Bool, movieList:[Movie]?) in
            if success {
                self.nowPlaying = movieList!
                DispatchQueue.main.async {
                    self.movieTableView.reloadData()
                }
            }
        }
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .compact {
            compact = true
            self.preferredContentSize = CGSize(width: 0, height: 120)
        }else{
            compact = false
            self.preferredContentSize = CGSize(width: 0, height: 240) 
        }
        
        movieTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if compact {
            return 2
        }else{
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        
        if nowPlaying.count > 0 {
            let movie = nowPlaying[indexPath.row]
            
            cell.textLabel?.textColor = UIColor.white
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            cell.textLabel?.text = movie.title
            
            Movie.getImage(forCell: cell, withMovieObject: movie)
        }
        
        
        return cell
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        loadData()
        completionHandler(NCUpdateResult.newData)
    }
    
}
