import Foundation

class NetworkParser {
    class func parser(data: Data?, response: URLResponse?, error: Error?) -> (Feed?, Error?) {
        do {
            guard let data =  data else { return (nil, error) }
            let decoder = JSONDecoder.init()
            let jsonObject = try decoder.decode([String: Feed].self, from: data)
            if let feedObject = jsonObject["feed"] {
                let feed = Feed.init(title: feedObject.title, results: feedObject.results)
                return (feed, nil)
            } else {
                return (nil, error)
            }
        }
            
        catch {
            return (nil, error)
        }
    }
}
