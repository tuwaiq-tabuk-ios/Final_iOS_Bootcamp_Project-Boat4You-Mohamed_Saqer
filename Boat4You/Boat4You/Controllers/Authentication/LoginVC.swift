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
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func loginTapped(_ sender: UIButton) {
        validateFields()
        login()
    }
    
    @IBAction func createAccountTapped(_ sender: UIButton) {
        let storyBoard = UIStoryboard (name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "SignUp")
        vc.modalPresentationStyle = .overFullScreen
        present(vc,animated: true)
    }
    
    
    func validateFields() {
        if email.text? .isEmpty == true {
            print("No Email Text")
            return
        }
        
        if password.text? .isEmpty == true {
            print("No Password Text")
            return
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { [weak self] authoResult,error in
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
                    print("Error \(error?.localizedDescription)")
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
                        
                        let alert = UIAlertController(title: "Ops!", message: "You have an owner account its not the right place ", preferredStyle: .alert)
                        
                        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
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
        self.performSegue(withIdentifier: "forgotPassSegue", sender: nil)
    }
    
    

    
//    func finishLogging () {
//        let rootViewController = UIApplication.shared.keyWindow? .rootViewController
//        guard let mainNavigationController = rootViewController as?
//                MainViewController else {return}
//    }
}
