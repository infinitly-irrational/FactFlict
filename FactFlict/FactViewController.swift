
import UIKit

class FactViewController: UIViewController {
    
    var facts:[Fact] = []
    let api_key = "b45RF732saJ+cHNSYApPJA==SpDC0gC3PMtcoiPQ"
    var favoritesManager = FavoritesManager()
    
 
    @IBOutlet weak var addToFavorites: UIButton!
    @IBOutlet weak var factLabel: UILabel!
    
    @IBAction func addToFavorites(_ sender: UIButton) {
        
        let currentFact = factLabel.text ?? ""
        let isFavorite = favoritesManager.isFavorite(currentFact)

        if isFavorite {
            favoritesManager.removeFavorite(currentFact)
            sender.isSelected = false
            
            let configuration = UIImage.SymbolConfiguration(scale: .large)
            let unfilledBookmarkImage = UIImage(systemName: "bookmark", withConfiguration: configuration)
            sender.setImage(unfilledBookmarkImage, for: .normal)
        } else {
            favoritesManager.addFavorite(currentFact)
            sender.isSelected = true
            
            let configuration = UIImage.SymbolConfiguration(scale: .large)
            let filledBookmarkImage = UIImage(systemName: "bookmark.fill", withConfiguration: configuration)
            sender.setImage(filledBookmarkImage, for: .normal)
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFacts()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(factLabelTapped))
        factLabel.isUserInteractionEnabled = true
        factLabel.addGestureRecognizer(tapGesture)
    }
  
    func fetchFacts(){
        let url = URL(string: "https://api.api-ninjas.com/v1/facts?limit=30")!
        var request = URLRequest(url: url)
        request.setValue(api_key, forHTTPHeaderField: "X-Api-Key")
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let factResponse = try decoder.decode([Fact].self, from:data)
                self.facts = factResponse
                DispatchQueue.main.async{
                    self.updateFactLabel()
                }
                
            }
            catch{
                print("Error decoding: \(error)")
            }
        }
        task.resume()
        
    }
    func updateFactLabel() {
        if facts.isEmpty{
            fetchFacts()
        }
        else{
            factLabel.text = facts.removeFirst().fact
        }
        let configuration = UIImage.SymbolConfiguration(scale: .large)
        let unfilledBookmarkImage = UIImage(systemName: "bookmark", withConfiguration: configuration)
        addToFavorites.setImage(unfilledBookmarkImage, for: .normal)
    }
    
    @objc func factLabelTapped() {

        updateFactLabel()
       }
    
    

}
