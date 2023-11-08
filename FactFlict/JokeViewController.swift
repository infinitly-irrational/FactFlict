
import UIKit

class JokeViewController: UIViewController {
    
    var jokesList:[Joke] = []
    var favoritesManager = FavoritesManager()
    @IBOutlet weak var addToFavoritesButton: UIButton!
    
    @IBAction func addToFavorites(_ sender: UIButton) {
        
        let currentJoke = jokeLabel.text ?? ""
        let isFavorite = favoritesManager.isFavorite(currentJoke)

            
            if isFavorite {
                favoritesManager.removeFavorite(currentJoke)
                sender.isSelected = false
                
                let configuration = UIImage.SymbolConfiguration(scale: .large)
                let unfilledBookmarkImage = UIImage(systemName: "bookmark", withConfiguration: configuration)
                sender.setImage(unfilledBookmarkImage, for: .normal)
            } else {
                favoritesManager.addFavorite(currentJoke)
                sender.isSelected = true
                
                let configuration = UIImage.SymbolConfiguration(scale: .large)
                let filledBookmarkImage = UIImage(systemName: "bookmark.fill", withConfiguration: configuration)
                sender.setImage(filledBookmarkImage, for: .normal)
            }
        
  
    }
    
    @IBOutlet weak var jokeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchJokes()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(jokeLabelTapped))
        jokeLabel.isUserInteractionEnabled = true
        jokeLabel.addGestureRecognizer(tapGesture)
        
    }
    
    func fetchJokes() {
           guard let url = URL(string: "https://v2.jokeapi.dev/joke/Any?safe-mode&type=single&amount=10") else {
               print("Invalid URL")
               return
           }

           let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
               if let error = error {
                   print("Request failed: \(error)")
                   return
               }

               guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                   print("Server error: response: \(String(describing: response))")
                   return
               }

               guard let data = data else {
                   print("🚨 No data returned from request")
                   return
               }

               do {
                   let decoder = JSONDecoder()
                   let jokeResponse = try decoder.decode(JokeResponse.self, from: data)
                   self.jokesList = jokeResponse.jokes
                   DispatchQueue.main.async {
                       self.updateJokeLabel()
                   }
               } catch {
                   print("Error decoding: \(error)")
               }
           }
           task.resume()
        
    }
    func updateJokeLabel() {
        if jokesList.isEmpty {
            fetchJokes()
        }
        else {
            jokeLabel.text = jokesList.removeFirst().joke
        }
        
            addToFavoritesButton.isSelected = false

            let configuration = UIImage.SymbolConfiguration(scale: .large)
            let unfilledBookmarkImage = UIImage(systemName: "bookmark", withConfiguration: configuration)
            addToFavoritesButton.setImage(unfilledBookmarkImage, for: .normal)
        }
    
    @objc func jokeLabelTapped() {
            updateJokeLabel()
        }
}
