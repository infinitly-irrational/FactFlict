
import UIKit

class QuoteViewController: UIViewController {
    
    @IBOutlet weak var addToFavoritesButton: UIButton!
    @IBOutlet weak var quotesLabel: UILabel!
    
    @IBAction func addToFavorited(_ sender: UIButton) {
        let currentQuote = quotesLabel.text ?? ""
        let isFavorite = favoritesManager.isFavorite(currentQuote)
           
        if isFavorite {
            favoritesManager.removeFavorite(currentQuote)
            sender.isSelected = false
            
            let configuration = UIImage.SymbolConfiguration(scale: .large)
            let unfilledBookmarkImage = UIImage(systemName: "bookmark", withConfiguration: configuration)
            sender.setImage(unfilledBookmarkImage, for: .normal)
        } else {
            favoritesManager.addFavorite(currentQuote)
            sender.isSelected = true
            
            let configuration = UIImage.SymbolConfiguration(scale: .large)
            let filledBookmarkImage = UIImage(systemName: "bookmark.fill", withConfiguration: configuration)
            sender.setImage(filledBookmarkImage, for: .normal)
        }
    }
    
    var favoritesManager = FavoritesManager()
    var quotes: [Quote] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchQuotes()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(quotesLabelTapped))
        quotesLabel.isUserInteractionEnabled = true
        quotesLabel.addGestureRecognizer(tapGesture)
    }
    
    func fetchQuotes() {
        guard let url = URL(string: "https://api.quotable.io/quotes/random?limit=10") else {
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
                let quoteResponse = try decoder.decode([Quote].self, from: data)
                self.quotes = quoteResponse
                DispatchQueue.main.async {
                    self.updateQuotesLabel()
                }
            } catch {
                print("Error decoding: \(error)")
            }
        }
        task.resume()
    }
    
    func updateQuotesLabel() {
        if quotes.isEmpty{
            fetchQuotes()
        }
        else {
            let randomQuote = quotes.randomElement()
            quotesLabel.text = "\"\(randomQuote?.content ?? "")\"\n- \(randomQuote?.author ?? "")"
            }
        
        addToFavoritesButton.isSelected = false

        let configuration = UIImage.SymbolConfiguration(scale: .large)
        let unfilledBookmarkImage = UIImage(systemName: "bookmark", withConfiguration: configuration)
        addToFavoritesButton.setImage(unfilledBookmarkImage, for: .normal)
    }
    
    @objc func quotesLabelTapped() {

           updateQuotesLabel()
       }
    
    
}
