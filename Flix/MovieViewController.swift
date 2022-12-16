//
//  ViewController.swift
//  Flix
//
//  Created by Jay on 10/24/22.
//

import UIKit
import AlamofireImage

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var movies=[[String:Any]]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource=self
        tableView.delegate=self
        tableView.rowHeight = 166
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    // Convert JSON
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    // Store the movies in an array
                    self.movies=dataDictionary["results"] as! [[String:Any]]
                    // Reload table view data
                    self.tableView.reloadData()
             }
        }
        
        task.resume()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return movies.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create the cell
        let cell=tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        // Get the info of the corresponding movie
        let movie=movies[indexPath.row]
        
        let title=movie["title"] as! String
        let synopsis=movie["overview"] as! String
        
        let baseUrl="https://image.tmdb.org/t/p/w185"
        
        if let posterPath=movie["poster_path"] as? String {
            let posterUrl=URL(string:baseUrl+posterPath)
            cell.posterView.af.setImage(withURL: posterUrl!)
        }
        else {
           cell.posterView.image = nil
        }
        
        cell.titleLabel.text=title
        cell.synopsisLabel.text=synopsis
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //find the selected movie
        let cell=sender as! UITableViewCell
        let indexPath=tableView.indexPath(for: cell)!
        let movie=movies[indexPath.row]
        
        //pass the select movie to the details view controller
        let detailsViewController=segue.destination as! MovieDetailsViewController
        detailsViewController.movie=movie
        tableView.deselectRow(at:indexPath, animated: true)
    }

}

