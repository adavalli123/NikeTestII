import UIKit

class ViewController: UIViewController {
    var feed: Feed = Feed.init()
    var error: Error?
    var isResponseSuccess: Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Constants.Titles.album
        self.dynamicTableView()
        self.registerTableViewCell()
        self.setTableViewFooter()
        
        feedNetworkCall()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isResponseSuccess ? feed.results.count : 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let tableCell = self.tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.imageLabel, for: indexPath) as? TableViewCell {
            if isResponseSuccess {
                let result = feed.results[indexPath.row]
                tableCell.configure(albumName: result.name, artistName: result.artistName, thumbNailUrl: result.artworkUrl100)
            } else {
                tableCell.configureSkeleton()
            }
            
            return tableCell
        }
        
        return UITableViewCell()
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Constants.StoryboardIdentifiers.main, bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: Constants.ViewControllerIdentifiers.detail) as? DetailViewController {
            detailVC.result = self.feed.results[indexPath.row]
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

extension ViewController {
    fileprivate func feedNetworkCall() {
        if let url = URL.init(string: Constants.Urls.base) {
            NetworkRequest.networkRequest(url: url, handler: { [weak self] (feed, error) in
                if let feed = feed {
                    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                        self?.feed = feed
                        DispatchQueue.main.sync {
                            self?.isResponseSuccess = true
                            
                            UIView.animate(withDuration: 0.5, animations: {
                                self?.tableView.reloadData()
                            })
                        }
                    }
                }
                
                if let error = error {
                    self?.error = error
                }
            })
        }
    }
    
    fileprivate func registerTableViewCell() {
        self.tableView.registerTableViewCell(withNibClass: TableViewCell.self, withIdentifier: Constants.Identifiers.imageLabel)
    }
    
    
    fileprivate func dynamicTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    fileprivate func setTableViewFooter() {
        tableView.tableFooterView = UIView()
    }
}

extension UITableView {
    func registerTableViewCell(withNibClass nibClass: AnyClass, withIdentifier identifier: String) {
        let nib: UINib = UINib.init(nibName: String(describing: nibClass.self), bundle: nil)
        self.register(nib, forCellReuseIdentifier: identifier)
    }
}

