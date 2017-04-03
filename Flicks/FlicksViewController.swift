import UIKit
import AFNetworking
import KVLoading

class FlicksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var networkErrorView: UIView!
    
    var movies: [NSDictionary]?
    let refreshControl = UIRefreshControl();
    let API_KEY = "a07e22bc18f5cb106bfe4cc1f83ad8ed";
    let posterBaseUrl = "http://image.tmdb.org/t/p/w500";
    
    override func viewDidLoad() {
        super.viewDidLoad();
        tableView.dataSource = self;
        tableView.delegate = self;
        networkErrorView.alpha = 0;
        networkErrorView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.8)

        initiateNetworkRequestForNowPlaying();
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged);
        tableView.insertSubview(refreshControl, at: 0);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailedViewController = segue.destination as! DetailedViewController
        let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
        tableView.deselectRow(at: indexPath, animated:true)
        
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String;
        let backdropPath = movie["backdrop_path"] as! String;
        let overview = movie["overview"] as! String;
        let popularity = movie["popularity"] as! Float;
        let voteCount = movie["vote_count"] as! Int;
        let voteAverage = movie["vote_average"] as! Float;
        let posterUrl = posterBaseUrl + backdropPath;
        detailedViewController.url = posterUrl;
        detailedViewController.movieTitle = title;
        detailedViewController.movieDescription = overview;
        detailedViewController.popularity = popularity;
        detailedViewController.voteCount = voteCount;
        detailedViewController.voteAverage = voteAverage;
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
        let posterUrl = NSURL(string: posterBaseUrl + posterPath)
        cell.posterView.setImageWith(posterUrl! as URL)
        cell.titleLabel.text = title;
        cell.overviewLabel.text = overview;
        return cell;
    }
    
    private func initiateNetworkRequestForNowPlaying(){
        KVLoading.show()
        let urlString = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(API_KEY)");
        let request = NSURLRequest(url: urlString! as URL);
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request as URLRequest,completionHandler: { (dataOrNill, response, error) in
            self.movies = []
            
            if error == nil {
                if let data = dataOrNill {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary{
                        self.movies = (responseDictionary["results"] as! [NSDictionary]);
                        self.tableView.reloadData();
                        self.refreshControl.endRefreshing();
                    }
                }
            }
            else{
                self.networkErrorView.alpha = 1;
                let offset = 3.0;
                UIView.animate(withDuration: offset, animations: {
                    self.networkErrorView.alpha = 0
                })
                self.refreshControl.endRefreshing();
            }
            KVLoading.hide()
        });
        task.resume();
    }
    
    @objc private func refreshControlAction(_ refreshControl: UIRefreshControl) {
        initiateNetworkRequestForNowPlaying();
    }

}
