import Foundation

typealias NetworkRequesterCompletionHandler = () -> (Data?, URLResponse?, Error?)

class NetworkRequest {

    static func networkRequest(url: URL, handler: @escaping (Feed?, Error?) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let feedHandler = NetworkParser.parser(data: data, response: response, error: error)
            handler(feedHandler.0, feedHandler.1)
        }
        
        dataTask.resume()
    }
    
    static func getImageFrom(url: URL, imageHandler: @escaping (Data?, Error?) -> ()) {
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            imageHandler(data, error)
        }
        
        dataTask.resume()
    }
}
