import Foundation

struct JokeResponse: Codable {
    let jokes: [Joke]
}

struct Joke: Codable {
    let joke: String
}


struct Quote: Codable {
    let content: String
    let author: String
}


struct Fact: Codable {
    let fact: String
}


struct FavoritedQuote {
    let text: String
}
