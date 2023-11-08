
import UIKit

class FactViewController: UIViewController {
    
    var facts:[Fact] = []
    let api_key = "b45RF732saJ+cHNSYApPJA==SpDC0gC3PMtcoiPQ"
    
 
    @IBOutlet weak var factLabel: UILabel!
    @IBOutlet weak var FavoriteButton: UIButton!
    
    
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
            let randomFact = facts.randomElement()
            factLabel.text = randomFact?.fact
        }
    }
    
    @objc func factLabelTapped() {

        updateFactLabel()
       }
    
    

}
