//
//  SignUpVC.swift
//  Boat4You
//
//  Created by Mohammed on 19/05/1443 AH.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpVC: UIViewController {
  
  //MARK: -IBOutlets
  @IBOutlet weak var emailField           : UITextField!
  @IBOutlet weak var passwordField        : UITextField!
  @IBOutlet weak var firstNameField       : UITextField!
  @IBOutlet weak var lastNameField        : UITextField!
  @IBOutlet weak var confirmPasswordField : UITextField!
  @IBOutlet weak var errorLabel           : UILabel!
  
  //MARK: -
  override func viewDidLoad() {
    super.viewDidLoad()
    errorLabel.isHidden = true
    hideKeyboardWhenTappedAround()
  }
  
  
  //MARK: -IBAction
  @IBAction func signUpTapped(_ sender: UIButton) {
    
    guard let email = emailField.text,
          email.isEmpty == false else {
            errorLabel.isHidden = false
            errorLabel.text = "Fill in the email"
            return
          }
    
    guard let password = passwordField.text,
          password.isEmpty == false else {
            errorLabel.isHidden = false
            errorLabel.text = "Enter the password"
            return
          }
    
    guard let confirmPassword = confirmPasswordField.text,
          confirmPassword.isEmpty == false else {
            errorLabel.isHidden = false
            errorLabel.text = "Enter the password"
            return
          }
    
    guard let firstName = firstNameField.text,
          firstName.isEmpty == false else {
            errorLabel.isHidden = false
            errorLabel.text = "Fill in the first name"
            return
          }
    
    guard let lastName = lastNameField.text,
          lastName.isEmpty == false else {
            errorLabel.isHidden = false
            errorLabel.text = "Fill in the last name"
            return
          }
    
    if password == confirmPassword {
      
      FSUserManager
        .shared
        .signUpUserWith(email: email,
                        password: password,
                        confirmPassword:confirmPassword,
                        firstName: firstName,
                        lastName: lastName,
                        type: "User") { error in
          if error == nil {
            
            let storybord =  UIStoryboard(name: "Main", bundle: nil)
            let vc = storybord
              .instantiateViewController(identifier: "MainHome")
            
            vc.modalPresentationStyle = .overFullScreen
            
            self.present(vc, animated: true)
          } else {
            self.errorLabel.isHidden = false
            self.errorLabel.text = error?.localizedDescription
          }
        }
      
    } else {
      errorLabel.isHidden = false
      errorLabel.text = "Passwords don't match"
    }
    
  }
  
  
  @IBAction func alredyHaveAnAccountPressed(_ sender: UIButton) {
    
    let storyBoard = UIStoryboard (name: "Main", bundle: nil)
    let vc = storyBoard.instantiateViewController(withIdentifier: "Login")
    vc.modalPresentationStyle = .overFullScreen
    present(vc ,animated: true)
  }
  
  
}
