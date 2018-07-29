import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    
    func configure(albumName: String, artistName: String, thumbNailUrl: String) {
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        setImageFromURL(thumbNailUrl: thumbNailUrl)
        setUpCell(albumName: albumName, artistName: artistName)
    }
    
    func configureSkeleton() {
        self.albumName.backgroundColor = UIColor.lightGray
        self.albumName.textColor = UIColor.lightGray
        self.artistName.backgroundColor = UIColor.lightGray
        self.artistName.textColor = UIColor.lightGray
        self.albumImageView.backgroundColor = UIColor.lightGray
        
        self.alpha = 0.1
        UIView.animate(withDuration: 5, delay: 0.0, options: [.curveLinear, .repeat, .autoreverse], animations: {self.alpha = 1.0}, completion: nil)
    }
}

extension TableViewCell {
    fileprivate func setImageFromURL(thumbNailUrl: String) {

        if let url = URL.init(string: thumbNailUrl) {
            NetworkRequest.getImageFrom(url: url) { [weak self] (data, error) in
                
                DispatchQueue.global().async {
                    DispatchQueue.main.sync {
                        if let data = data {
                            if let image = UIImage.init(data: data) {
                                self?.albumImageView?.image = image
                            }
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func setUpCell(albumName: String, artistName: String) {
        self.albumName.text = albumName
        self.artistName.text = artistName
        self.albumName.backgroundColor = UIColor.white
        self.artistName.backgroundColor = UIColor.white
        self.albumName.textColor = UIColor.darkGray
        self.artistName.textColor =  UIColor.darkGray
    }
}
