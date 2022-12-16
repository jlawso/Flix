//
//  GridDetailsViewController.swift
//  Flix
//
//  Created by Jay on 11/06/22.
//

import UIKit

class GridDetailsViewController: UIViewController {
    var movie:[String:Any]!
    
    @IBOutlet weak var backdropView: UIImageView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        posterView.layer.masksToBounds = true
        posterView.layer.borderWidth = 1.5
        posterView.layer.borderColor = UIColor.black.cgColor
        
        titleLabel.text=movie["title"] as? String
        synopsisLabel.text=movie["overview"] as? String
        
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
    }
    

}
