//
//  ForgotOwnerPassVC.swift
//  Boat4You
//
//  Created by Mohammed on 29/05/1443 AH.
//

import UIKit
import Firebase
import FirebaseAuth
class ForgotOwnerPassVC: UIViewController {

  @IBOutlet weak var emailTextField: UITextField!
 
  override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    

  @IBAction func resetPasswordPressed(_ sender: UIButton) {
  
  
    let auth = Auth.auth()
    auth.sendPasswordReset(withEmail: emailTextField.text!) { (error) in
        if let error = error {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
            self.present(alert, animated: true, completion: nil)
            return
        }
        let alert = UIAlertController(title: "Succesfully", message: "A password reset email has been sent!", preferredStyle: UIAlertController.Style.alert)
        self.present(alert, animated: true, completion: nil)
    }
  }
  

}
