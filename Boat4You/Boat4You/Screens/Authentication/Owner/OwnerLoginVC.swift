//
//  OwnerLoginVC.swift
//  Boat4You
//
//  Created by Mohammed on 19/05/1443 AH.
//

import UIKit
import FirebaseAuth
import Firebase
class OwnerLoginVC: UIViewController {
  
  
  //MARK: -IBOutlet
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  
  //MARK: -
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  
  //MARK: - IBAction
  @IBAction func loginPressed(_ sender: UIButton) {
    validateFields()
    ownerLogin()
  }
  
  
  @IBAction func createAccountTapped(_ sender: UIButton) {
    let storyBoard = UIStoryboard (name: "Main", bundle: nil)
    let vc = storyBoard.instantiateViewController(withIdentifier: "OwnerSignUp")
    vc.modalPresentationStyle = .overFullScreen
    present(vc,animated: true)
  }
  
  //MARK: - Login
  func validateFields() {
    if emailField.text? .isEmpty == true {
      print("No Email Text")
      return
    }
    
    if passwordField.text? .isEmpty == true {
      print("No Password Text")
      return
    }
  }
  
  
  func ownerLogin() {
    
    Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { [weak self] authoResult,error in
      guard let strongSelf = self else {return}
      if let error = error {
      print(error.localizedDescription)
      }
      
      
      self!.checkUserInfo()
    }
  }
  
  
  func checkUserInfo () {
    
    if let user = Auth.auth().currentUser {
    let db = Firestore.firestore()
      
    var type:String = ""
    db.collection("users")
        .document(user.uid)
        .getDocument { userResult, error in
        
        if error != nil {
          print("Error \(String(describing: error?.localizedDescription))")
        
        } else {
          let data = userResult?.data()
          type = data!["type"] as! String
          
          if type == "Owner" {
            let storyBoard = UIStoryboard (name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "OwnerMainHome")
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc,animated: true)
         
          } else {
            
            let alert = UIAlertController(title: "Error",
                                          message: "Error",
                                          preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Ok",
                                       style: .cancel,
                                       handler: nil)
            alert.addAction(action)
            
            
            do {
              try Auth.auth().signOut()
            } catch {
           }
            
            self.present(alert, animated: true, completion: nil)
          }
        }
      }
    }
  }
  
  @IBAction func forgotPassTapped(_ sender: UIButton) {
    self.performSegue(withIdentifier: "forgotOwnerPassSegue", sender: nil)
  }
}