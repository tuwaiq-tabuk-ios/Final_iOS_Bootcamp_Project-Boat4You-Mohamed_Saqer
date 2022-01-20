//
//  LoginVC.swift
//  Boat4You
//
//  Created by Mohammed on 19/05/1443 AH.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginVC: UIViewController {
  
  //MARK: -IBOutlet
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var errorLabel: UILabel!
  
  //MARK: -
  override func viewDidLoad() {
    super.viewDidLoad()
    errorLabel.isHidden = true
    hideKeyboardWhenTappedAround()
  }
  
  
  //MARK: -IBAction
  @IBAction func loginTapped(_ sender: UIButton) {
    validateFields()
    login()
  }
  
  
  @IBAction func createAccountTapped(_ sender: UIButton) {
    let storyBoard = UIStoryboard (name: "Main", bundle: nil)
    let vc = storyBoard.instantiateViewController(withIdentifier: "SignUp")
    vc.modalPresentationStyle = .automatic
    present(vc,animated: true)
  }
  
  
  //MARK: - Methods
  func validateFields() {
    
    guard let email = emailField.text,
          email.isEmpty == false else {
            errorLabel.isHidden = false
            errorLabel.text = "You didn't write your email!"
            return
          }
    
    guard let password = passwordField.text,
          password.isEmpty == false else {
            errorLabel.isHidden = false
            errorLabel.text = "You didn't write your password!"
            return
          }
  }
  
  
  func login() {
    Auth.auth().signIn(withEmail: emailField.text!,
                       password: passwordField.text!) { [weak self] authoResult,error in
      
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
      db.collection("users").document(user.uid).getDocument { userResult, error in
        
        if error != nil {
          print("Error \(String(describing: error?.localizedDescription))")
        }else {
          let data = userResult?.data()
          type = data!["type"] as! String
          if type == "User" {
            print("Sign in User")
            let storyBoard = UIStoryboard (name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "MainHome")
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc,animated: true)
          } else {
            
            self.errorLabel.isHidden = false
            self.errorLabel.text = "You have an owner account!"
            
            do {
              try Auth.auth().signOut()
            } catch {
              
            }
            
            
          }
        }
        
      }
      
      
    }
    
  }
  
  
  @IBAction func forgotPassTapped(_ sender: UIButton) {
    self.performSegue(withIdentifier: "forgotPassSegue", sender: nil)
  }
  
}
