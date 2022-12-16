//
//  MovieDetailsViewController.swift
//  Flix
//
//  Created by Jay on 10/24/22.
//

import UIKit
import AlamofireImage

class MovieDetailsViewController: UIViewController {

    var movie:[String:Any]!
    
    @IBOutlet weak var backdropView: UIImageView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //add border
        posterView.layer.masksToBounds = true
        posterView.layer.borderWidth = 1.5
        posterView.layer.borderColor = UIColor.white.cgColor
        
        //add label text
        titleLabel.text=movie["title"] as? String
        synopsisLabel.text=movie["overview"] as? String
        
        //download and add image
        let baseUrl="https://image.tmdb.org/t/p/w185"
        if let posterPath=movie["poster_path"] as? String {
            let posterUrl=URL(string:baseUrl+posterPath)
            posterView.af.setImage(withURL: posterUrl!)
        }
        else {
           posterView.image = nil
        }
        if let backdropPath=movie["backdrop_path"] as? String {
            let backdropUrl=URL(string:"https://image.tmdb.org/t/p/w780"+backdropPath)
            backdropView.af.setImage(withURL: backdropUrl!)
        }
        else {
           backdropView.image = nil
        }
        
        //add gesture recognizer
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTap))
        posterView.isUserInteractionEnabled = true
        posterView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTap() {
        self.performSegue(withIdentifier: "modalSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let TrailerViewController=segue.destination as! TrailerViewController
        TrailerViewController.movieId=movie["id"] as? Int
    }
    

    

}
