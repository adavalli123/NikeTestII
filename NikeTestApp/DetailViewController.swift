import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var copyRightLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    var result: Results = Results.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpImage()
        setUpLabels()
    }
    
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        guard let url = URL.init(string: result.url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

extension DetailViewController {
    fileprivate func setUpLabels() {
        copyRightLabel.text = result.copyright
        albumNameLabel.text = "Album: \(result.name)"
        artistLabel.text = "Artist: \(result.artistName)"
        releaseDateLabel.text = "Release date: \(result.releaseDate)"
    }
    
    fileprivate func setUpImage() {
        guard let url = URL.init(string: result.artworkUrl100) else { return }
        NetworkRequest.getImageFrom(url: url) { (data, error) in
            if let data = data {
                DispatchQueue.main.sync {
                    
                    if let image = UIImage.init(data: data) {
                        self.albumImageView.image = image
                    }
                }
            }
        }
    }
}
