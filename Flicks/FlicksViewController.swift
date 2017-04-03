import UIKit
import AFNetworking

class FlicksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var movies: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self;
        tableView.delegate = self;
        initiateNetworkRequest();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let movies = movies {
            return movies.count;
        }
        else{
            return 0;
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell;
        let movie = movies![indexPath.row];
        let title = movie["title"] as! String;
        let overview = movie["overview"] as! String;
        let posterPath = movie["poster_path"] as! String;
        let posterBaseUrl = "http://image.tmdb.org/t/p/w500";
        let posterUrl = NSURL(string: posterBaseUrl + posterPath)
        cell.posterView.setImageWith(posterUrl! as URL)
        cell.titleLabel.text = title;
        cell.overviewLabel.text = overview;
        return cell;
    }
    
    private func initiateNetworkRequest(){
        let api_key = "a07e22bc18f5cb106bfe4cc1f83ad8ed";
        let urlString = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(api_key)");
        let request = NSURLRequest(url: urlString! as URL);
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request as URLRequest,completionHandler: { (dataOrNill, response, error) in
            if let data = dataOrNill {
                if let responseDictionary = try! JSONSerialization.jsonObject(
                    with: data, options:[]) as? NSDictionary{
                                                                                NSLog("response: \(responseDictionary)")
                    self.movies = (responseDictionary["results"] as! [NSDictionary]);
                    self.tableView.reloadData();
                                                                            }
                                                                        }
        });
        task.resume();
    }

}
