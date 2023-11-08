//
//  DetailedFavoritesViewController.swift
//  FactFlict
//
//  Created by Haitham Alnajar on 11/8/23.
//

import UIKit

class DetailedFavoritesViewController: UIViewController {

    
    @IBOutlet weak var favoritedQuote: UILabel!
    var selectedQuote: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedQuote = selectedQuote{
            favoritedQuote.text = selectedQuote
        }

    }


}
