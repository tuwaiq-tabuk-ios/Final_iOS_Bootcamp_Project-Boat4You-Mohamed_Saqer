//
//  ImageViewVC.swift
//  Boaty
//
//  Created by Mohammed on 16/05/1443 AH.
//

import UIKit

class welcomePageVC: UIViewController {
    @IBOutlet weak var animatedLabel: UILabel!
    @IBOutlet weak var onwerButton: UIButton!
    
    @IBOutlet weak var userButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        animatedLabel.animate(newText: animatedLabel.text ?? "", characterDelay: 0.5)
        
        
        onwerButton.layer.shadowColor = UIColor.black.cgColor
        onwerButton.layer.shadowOpacity = 1
        onwerButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        
        onwerButton.layer.shadowRadius = 1.0
        onwerButton.clipsToBounds = false
        
        
        userButton.layer.shadowColor = UIColor.black.cgColor
        userButton.layer.shadowOpacity = 1
        userButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        
        userButton.layer.shadowRadius = 1.0
        userButton.clipsToBounds = false
        
    }
}

extension UILabel {
    
    func animate(newText: String, characterDelay: TimeInterval) {
        
        DispatchQueue.main.async {
            
            self.text = ""
            
            for (index, character) in newText.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + characterDelay * Double(index)) {
                    self.text?.append(character)
                }
            }
        }
    }
    
}
