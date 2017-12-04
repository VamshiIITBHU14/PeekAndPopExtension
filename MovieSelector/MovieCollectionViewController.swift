//
//  MovieCollectionViewController.swift
//  MovieSelector
//
//  Created by Vamshi Krishna on 03/12/17.
//  Copyright © 2017 Vamshi Krishna. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MovieCollectionViewController: UICollectionViewController , UIViewControllerPreviewingDelegate {
    
    //MARK: PEEK
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = collectionView?.indexPathForItem(at: location),
        let cell = collectionView?.cellForItem(at: indexPath) else {return nil}
        previewingContext.sourceRect = cell.frame
        let overlayVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Overlay") as! OverlayViewController
        overlayVC.preferredContentSize = CGSize(width: 0, height: 200)
        selectedMovieByPeek = movieArray[indexPath.item]
        overlayVC.movieItem = selectedMovieByPeek
        return overlayVC
        
    }
    
    //MARK: POP
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        let movieDetailVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetail") as! MovieDetailViewController
        if let availableMovie = selectedMovieByPeek{
            movieDetailVC.movieObect = availableMovie
            show(movieDetailVC, sender: self)
        }
    }
    

    var movieArray = [Movie]()
    var selectedMovieByPeek : Movie?
    
    let movieTransitonDelegate = MovieTransitionDelegate()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        if traitCollection.forceTouchCapability == .available{
            registerForPreviewing(with: self, sourceView: collectionView!)
        }
    }
    
    func loadData(){
        Movie.nowPlaying { (success:Bool, response:[Movie]?) in
            if success{
                self.movieArray = response!
                DispatchQueue.main.async(execute: {
                    self.collectionView?.reloadData()
                })
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MovieCollectionViewCell
        let movie = movieArray[indexPath.item]
        cell.movieTitleLabel.text = movie.title
        Movie.getImage(forCell: cell, withMovieObject: movie)
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = collectionView?.indexPathsForSelectedItems?.first{
            let movieObject = movieArray[indexPath.item]
            if segue.identifier == "showDetail"{
                let detailVC = segue.destination as! MovieDetailViewController
                detailVC.movieObect = movieObject
            }
        }
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        //showOverLay(forIndexPath: indexPath)
    }
    
    func showOverLay(forIndexPath indexPath:IndexPath){
        let overlayVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Overlay") as! OverlayViewController
        transitioningDelegate = movieTransitonDelegate
        overlayVC.transitioningDelegate = movieTransitonDelegate
        overlayVC.modalPresentationStyle = .custom
        
        let movie = movieArray[indexPath.item]
        present(overlayVC, animated: true, completion: nil)
        overlayVC.movieItem = movie
        
        
    }
   

}
