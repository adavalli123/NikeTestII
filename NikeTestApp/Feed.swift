
struct Feed: Codable {
    var title = ""
    var results = [Results.init()]
    
}

struct Results: Codable {
    var artistName = ""
    var name = ""
    var artistUrl = ""
    var artworkUrl100 = ""
    var copyright = ""
    var releaseDate = ""
    var genres = [Genres.init()]
    var url = ""
}

struct Genres: Codable {
    var name = ""
    var url = ""
}
