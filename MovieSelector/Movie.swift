//
//  Movie.swift
//  MovieSelector
//
//  Created by Vamshi Krishna on 01/12/17.
//  Copyright © 2017 Vamshi Krishna. All rights reserved.
//

import Foundation
import UIKit
import MovieSelectorBridge

public struct Movie{
    
    static let APIKEY = "b82545af48c8683f2ada024bc306d2b8"
    private static let imageBaseURL = "https://image.tmdb.org/t/p/w500"
    
    var title:String!
    var imagePath:String!
    var description:String!
    
    init(title:String, imagePath:String, description:String){
        self.title = title
        self.imagePath = imagePath
        self.description = description
    }
    
    private static func getMovies(with completion: @escaping (_ success:Bool, _ object:AnyObject?) -> ()){
        let session = URLSession(configuration: .default)
        let request = URLRequest(url: URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(APIKEY)")!)
        session.dataTask(with: request) { (data:Data?,response:URLResponse?, error:Error?) in
            if let data = data{
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode{
                completion(true, json as AnyObject?)
            }else{
                completion(false, json as AnyObject?)
            }
            }
        }.resume()
    }
    
    public static func getImage(forMovie movie:Movie) -> UIImage?{
        if let imagePath = checkForImageData(withMovieObject: movie){
            if let imageData = FileManager.default.contents(atPath: imagePath){
                return UIImage(data:imageData)
            }
        }
            return nil
    }
    
    public static func nowPlaying(with completion:@escaping(_ success: Bool, _ object: [Movie]?) -> ()){
        getMovies { (success, object) in
            if success {
                var movieArray = [Movie]()
                if let movieResults = object?["results"] as? [Dictionary<String, AnyObject>]{
                    for movie in movieResults{
                        let title = movie["original_title"] as! String
                        let description = movie["overview"] as! String
                        guard let posterPath = movie["poster_path"] as? String else {continue}
                        
                        let movieObject = Movie(title: title, imagePath: posterPath, description: description)
                        movieArray.append(movieObject)
                    }
                }
                completion(true, movieArray)
            } else{
                completion(false, nil)
            }
        
        }
    }
    
    private static func getDocumentsDirectory() -> String?{
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        guard let documents:String = paths.first else {return nil}
        return documents
    }
    
    
    private static func checkForImageData(withMovieObject movie:Movie) -> String?{
        if let documents = getDocumentsDirectory(){
            let movieImagePath = documents + "/\(movie.title)"
            let escapedImagePath = movieImagePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if FileManager.default.fileExists(atPath: escapedImagePath!){
                return escapedImagePath
            }
        }
        return nil
    }
    
    public static func getImage(forCell cell:AnyObject, withMovieObject movie:Movie) {
        if let imagePath = checkForImageData(withMovieObject: movie){ //Image exitst
        if let imageData = FileManager.default.contents(atPath: imagePath){
            if cell is UITableViewCell{
                let tableViewCell = cell as! UITableViewCell
                tableViewCell.imageView?.image = UIImage(data:imageData)
                tableViewCell.setNeedsLayout()
            }
            else{
                let collectionViewCell = cell as! MovieCollectionViewCell
                collectionViewCell.movieImageView.image = UIImage(data:imageData)
                collectionViewCell.setNeedsLayout()
            }
        }
        } else{//download Image and save to disk
            
            let imageURL = URL(string:imageBaseURL + movie.imagePath)
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                do {
                    let data = try Data(contentsOf:imageURL!)
                    let documents = getDocumentsDirectory()
                    let imageFilePath = documents! + "/\(movie.title)"
                    let escapedImagePath = imageFilePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    if FileManager.default.createFile(atPath: escapedImagePath!, contents: data, attributes: nil){
                        print("Image Saved")
                    }
                    DispatchQueue.main.async(execute: {
                        if cell is UITableViewCell{
                            let tableViewCell = cell as! UITableViewCell
                            tableViewCell.imageView?.image = UIImage(data:data)
                            tableViewCell.setNeedsLayout()
                        }else{
                            let collectionViewCell = cell as! MovieCollectionViewCell
                            collectionViewCell.movieImageView.image = UIImage(data:data)
                            collectionViewCell.setNeedsLayout()
                        }
                    })
                }catch{
                    print("No Image at sepcified location")
                }
            }
            
            
            
            
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
