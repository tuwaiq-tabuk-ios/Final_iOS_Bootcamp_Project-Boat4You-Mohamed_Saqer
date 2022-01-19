//
//  ForgotPassVC.swift
//  Boat4You
//
//  Created by Mohammed on 23/05/1443 AH.
//

import UIKit
import Firebase
class ForgotPassVC: UIViewController {
  
  //MARK: - IBOutlet
  @IBOutlet weak var email: UITextField!
  
  
  //MARK: -
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  //MARK: - IBAction
  @IBAction func forgotPassTapped(_ sender: UIButton) {
    let auth = Auth.auth()
    auth.sendPasswordReset(withEmail: email.text!) { (error) in
      
      if let error = error {
        let alert = UIAlertController(title: "Error",
                                      message: error.localizedDescription,
                                      preferredStyle: UIAlertController.Style.alert)
        self.present(alert,
                     animated: true,
                     completion: nil)
        
        return
      }
      
      let alert = UIAlertController(title: "Succesfully",
                                      message: "A password reset email has been sent!",
                                      preferredStyle: UIAlertController.Style.alert)
      
      alert.addAction((UIAlertAction(  title: "Ok",
                                       style: .default,
                                       handler: nil)))
      self.present(alert,
                   animated: true,
                   completion: nil)
    }
  }
}
