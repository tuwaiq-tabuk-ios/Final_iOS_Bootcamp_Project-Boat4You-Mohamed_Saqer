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
  @IBOutlet weak var errorLabel: UILabel!
  
  //MARK: -
 
  override func viewDidLoad() {
    super.viewDidLoad()
    self.hideKeyboardWhenTappedAround()
    errorLabel.isHidden = true
  }
  
  
  //MARK: - IBAction
 
  @IBAction func loginPressed(_ sender: UIButton) {
    validateFields()
    let email = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    ownerLogin(email: email, password: password)
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
      errorLabel.isHidden = false
      errorLabel.text = "Please enter your email".localize()
      return
    }
    
    if passwordField.text? .isEmpty == true {
      print("No Password Text")
      errorLabel.isHidden = false
      errorLabel.text = "Please enter your password".localize()
      return
    }
  }
  
  
  func ownerLogin(email: String , password: String) {
    
    Auth.auth().signIn(withEmail: email,
                       password: password,
                       completion:{
                        (authResult,error) in
                        if error != nil {
                          self.errorLabel.isHidden = false
                          self.errorLabel.text = error?.localizedDescription
                          
                        }else{
                          let db = Firestore.firestore()
                          let documentRF = db.collection("users").document((authResult?.user.uid)!)
                          documentRF.getDocument { snapchpot,error in
                            if error != nil{
                              print("error get user data: \(String(describing: error?.localizedDescription))")
                            } else {
                              
                              UserDefaults.standard.setValue(email,
                                                             forKey: "email")
                              UserDefaults.standard.setValue(password,
                                                             forKey: "password")
                              UserDefaults.standard.synchronize()
                              
                              let data = snapchpot!.data()!
                              let type = data["type"] as! String
                              let storybord =  UIStoryboard(name: "Main",
                                                            bundle: nil)
                              if type == "Owner"{
                                let vc = storybord.instantiateViewController(withIdentifier: "OwnerMainHome")
                                vc.modalPresentationStyle = .overFullScreen
                                self.present(vc, animated: true)
                                
                              }else {
                                self.errorLabel.isHidden = false
                                self.errorLabel.text = "You have an user account!".localize()
                                do {
                                  try Auth.auth().signOut()
                          } catch {
                      }
                  }
                }
              }
          }
      })
  }
  
  
  
  
  
  @IBAction func forgotPassTapped(_ sender: UIButton) {
    self.performSegue(withIdentifier: "forgotOwnerPassSegue", sender: nil)
  }
}
