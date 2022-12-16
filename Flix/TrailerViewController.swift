//
//  TrailerViewController.swift
//  Flix
//
//  Created by Jay on 10/24/22.
//

import UIKit
import WebKit

class TrailerViewController: UIViewController {
    
    var movie:[String:Any]!
    var movieId:Int!

    @IBOutlet weak var movieView: WKWebView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let id=movieId{
            
            let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US")!
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
            let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
            let task = session.dataTask(with: request) { (data, response, error) in
                 if let error = error {
                        print(error.localizedDescription)
                 } else if let data = data {
                       
                        let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                        let results=dataDictionary["results"] as! [[String:Any]]
              
                         if let k=results[0]["key"] as? String{
                             self.loadTrailer(movieKey: k)
                         }
                        
                 }
            }
            
            task.resume()
        }
        
        
    }
    
 
    func loadTrailer(movieKey:String){
      
        let myURL = URL(string:"https://www.youtube.com/watch?v=\(movieKey)")
        let myRequest = URLRequest(url: myURL!)
        movieView.load(myRequest)
    }
    @IBAction func didPress(_ sender: UIButton) {
        print("test")
        dismiss(animated: true, completion: nil)
    }


}
