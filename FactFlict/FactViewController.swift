//
//  FactViewController.swift
//  FactFlict
//
//  Created by Haitham Alnajar on 11/6/23.
//

import UIKit

class FactViewController: UIViewController {

    //#rgb:51,51,51
//Fact API: https://uselessfacts.jsph.pl/
// https://uselessfacts.jsph.pl/
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var FavoriteButton: UIButton!
    
    @IBAction func CopyTextToClipboard(_ sender: UIButton) {
        if let copiedText = textLabel.text {
            UIPasteboard.general.string = copiedText
            print("Copied text , \(copiedText)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FavoriteButton.layer.cornerRadius = FavoriteButton.frame.width / 2
    }
    
    
    

}
