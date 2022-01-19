//
//  personalDataVC.swift
//  Boat4You
//
//  Created by Mohammed on 23/05/1443 AH.
//

import UIKit
import Firebase
class ClientProfileVC: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logOutButtonTapped(_ sender: UIButton) {
        let auth = Auth.auth()
        
        do {
            try auth.signOut()
            self.dismiss(animated: true, completion:nil)
            
        } catch let signOutError {
            let alert = UIAlertController(title: "Error", message: signOutError.localizedDescription, preferredStyle: UIAlertController.Style.alert)
            self.present(alert, animated: true, completion: nil)
        }
    
    }
  
}
