//
//  OwnerSignUpVC.swift
//  Boat4You
//
//  Created by Mohammed on 19/05/1443 AH.
//

import UIKit
import FirebaseAuth
import Firebase
class OwnerSignUpVC: UIViewController {
  
  
  //MARK: - IBOutlet
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var firstNameField: UITextField!
  @IBOutlet weak var lastNameField: UITextField!
  @IBOutlet weak var confirmPasswordField: UITextField!
  
  @IBOutlet weak var errorLabel: UILabel!
  //MARK: -
  override func viewDidLoad() {
    super.viewDidLoad()
    errorLabel.isHidden = true
    hideKeyboardWhenTappedAround()
  }
  
  
  //MARK: - IBAction
  @IBAction func signUpTapped(_ sender: UIButton) {
    
    guard let email = emailField.text,
                email.isEmpty == false else {
                  errorLabel.isHidden = false
                  errorLabel.text = "You didn't write your email"
                  return
                }
           
          guard let password = passwordField.text,
                password.isEmpty == false else {
                  errorLabel.isHidden = false
                  errorLabel.text = "You didn't write your password"
                  return
                }
           guard let confirmPassword = confirmPasswordField.text,
                 confirmPassword.isEmpty == false else {
                   errorLabel.isHidden = false
                   errorLabel.text = "Confirm your password"
                   return
                 }
           guard let firstName = firstNameField.text,
                    firstName.isEmpty == false else {
                      errorLabel.isHidden = false
                      errorLabel.text = "Write your first name"
                      return
                    }
               
              guard let lastName = lastNameField.text,
                    lastName.isEmpty == false else {
                      errorLabel.isHidden = false
                      errorLabel.text = "Write your last name"
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
                                 type: "Owner") { error in
                   if error == nil {
                     
                     let storybord =  UIStoryboard(name: "Main", bundle: nil)
                     let vc = storybord
                       .instantiateViewController(identifier: "OwnerMainHome")
                      
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
      
  
  
  
  @IBAction func alredyHaveAnAccountTapped(_ sender: UIButton) {
    
    let storyBoard = UIStoryboard (name: "Main", bundle: nil)
    let vc = storyBoard.instantiateViewController(withIdentifier: "OwnerLogin")
    vc.modalPresentationStyle = .overFullScreen
    present(vc ,animated: true)
  }
  
  //MARK: - Methods
  func signUp(email: String,
              password: String,
              confirmPassword: String) {
    
    guard let firstName = self.firstNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
          let lastName  = self.lastNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return
          }
    
    FSUserManager.shared.signUpUserWith(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      firstName: firstName,
      lastName: lastName,
      type: "Owner") { error in
        print("------------- error: \(String(describing: error))")
        
        if error == nil {
          let storyBoard = UIStoryboard(name: K.OwnerStoryboard.mainStoryboard,
                                        bundle: nil)
          let vc = storyBoard.instantiateViewController(
            withIdentifier: K.OwnerStoryboard.mainHomeVCIdentifier
          )
          vc.modalPresentationStyle = .automatic
          
          self.present(vc ,animated: true)
        } else {
          self.showAlertMessage(title: "ERROR",
                                message: "Error authenticating")
        }
      }
  }
}

