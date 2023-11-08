
import UIKit

class JokeViewController: UIViewController {
    
    var jokesList:[Joke] = []
    
    @IBAction func addToFavorites(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
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
        }
    
    @objc func jokeLabelTapped() {
            updateJokeLabel()
        }
}
