//
//  ImageViewVC.swift
//  Boaty
//
//  Created by Mohammed on 16/05/1443 AH.
//

import UIKit

class WelcomeVC: UIViewController {
  @IBOutlet weak var animatedLabel: UILabel!
  @IBOutlet weak var onwerButton: UIButton!
  @IBOutlet weak var mainImage: UIImageView!
  @IBOutlet weak var userButton: UIButton!
  let radius: CGFloat = 8
 
  override func viewDidLoad() {
    super.viewDidLoad()
    
    UIView.animate(withDuration:2.0, animations: {
      self.mainImage.transform = CGAffineTransform(rotationAngle: CGFloat(0))
    })
    
    animatedLabel.animate(newText: animatedLabel.text ?? "", characterDelay: 0.5)
    
    onwerButton.dropShadow(radius: radius, opacity: 0.8, color: .black)
    userButton.dropShadow(radius: radius, opacity: 0.8, color: .black)
    hideKeyboardWhenTappedAround()
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
