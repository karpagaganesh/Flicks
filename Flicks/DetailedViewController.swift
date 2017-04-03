import UIKit

class DetailedViewController: UIViewController {
    
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var detailedImageView: UIImageView!
    @IBOutlet weak var movieDescriptionTextField: UITextView!
    
    var url: String?
    var movieTitle: String?
    var movieDescription: String?
    var popularity: Float?;
    var voteCount: Int?;
    var voteAverage: Float?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = movieTitle;
        movieDescriptionTextField.isEditable = false;
        movieDescriptionTextField.text = movieDescription!;
        voteCountLabel.text = String(describing: voteCount!);
        popularityLabel.text = String(describing: popularity!);
        voteAverageLabel.text = String(describing: voteAverage!);
        
        if let imageUrl = URL(string: url!) {
            detailedImageView.setImageWith(imageUrl)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
