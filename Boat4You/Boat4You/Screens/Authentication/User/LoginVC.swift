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
  @IBOutlet weak var signInButton: UIButton!
  
  
  //MARK: -
  override func viewDidLoad() {
    super.viewDidLoad()
    errorLabel.isHidden = true
    hideKeyboardWhenTappedAround()
    emailField.dropShadow(radius: 8, opacity: 0.3, color: .black)
    passwordField.dropShadow(radius: 8, opacity: 0.3, color: .black)
    signInButton.dropShadow(radius: 8, opacity: 0.3, color: .black)
    
  }
  
  
  //MARK: -IBAction
  @IBAction func loginTapped(_ sender: UIButton) {
    validateFields()
    let email = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    login(email: email, password: password)
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
            errorLabel.text = "You didn't write your email!".localize()
            return
          }
    
    guard let password = passwordField.text,
          password.isEmpty == false else {
            errorLabel.isHidden = false
            errorLabel.text = "You didn't write your password!".localize()
            return
          }
  }
  
  
  func login(email:String,
               password:String ) {
      Auth.auth().signIn(withEmail: email,
                         password: password,
                         completion:{
                          (authResult,error) in
                          if error != nil {
                            self.errorLabel.isHidden = false
                            self.errorLabel.text = "Password or email is wrong".localize()
                            
                            
                            
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
                                if type == "User"{
                                  let vc = storybord.instantiateViewController(withIdentifier: "MainHome")
                                  vc.modalPresentationStyle = .overFullScreen
                                  self.present(vc, animated: true)
                                  
                                }else {
                                  self.errorLabel.isHidden = false
                                  self.errorLabel.text = "You have an owner account!".localize()
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
    self.performSegue(withIdentifier: "forgotPassSegue", sender: nil)
  }
}
