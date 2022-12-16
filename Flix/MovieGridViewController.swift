//
//  MovieGridViewController.swift
//  Flix
//
//  Created by Jay on 11/06/22.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    
    var movies=[[String:Any]]()

    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        collectionView.delegate=self
        collectionView.dataSource=self
        
        //customize collectionView layout
        let layout=collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing=0
        layout.minimumInteritemSpacing=0
        let width=view.frame.size.width/3 //width of the device
        layout.itemSize=CGSize(width:width,height:(width-2*layout.minimumInteritemSpacing)*3/2)
        
        //API request
        let url = URL(string: "https://api.themoviedb.org/3/movie/634649/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    
        let task = session.dataTask(with: request) { (data, response, error) in
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    self.movies=dataDictionary["results"] as! [[String:Any]]
                    self.collectionView.reloadData()
             }
        }
        task.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        let baseUrl="https://image.tmdb.org/t/p/w185"
        let movie=movies[indexPath.item]
        if let posterPath=movie["poster_path"] as? String {
            let posterUrl=URL(string:baseUrl+posterPath)
            cell.posterView.af.setImage(withURL: posterUrl!)
        }
        else {
           cell.posterView.image = nil
        }
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            //find the selected movie
            let cell=sender as! UICollectionViewCell
            let indexPath=collectionView.indexPath(for: cell)!
            let movie=movies[indexPath.item]
            
            //pass the select movie to the details view controller
            let detailsViewController=segue.destination as! GridDetailsViewController
            detailsViewController.movie=movie
            collectionView.deselectItem(at: indexPath, animated: true)
        
        }

}
