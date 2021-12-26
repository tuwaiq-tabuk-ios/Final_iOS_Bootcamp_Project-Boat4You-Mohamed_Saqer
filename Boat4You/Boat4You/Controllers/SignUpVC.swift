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

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        if email.text? .isEmpty == true {
            print("No email in text field")
            return
        }
        
        if password.text? .isEmpty ==  true {
            print("No password in text field")
            return
        }
        
        signUp()
    }
    @IBAction func alredyHaveAnAccountTapped(_ sender: UIButton) {
    
        let storyBoard = UIStoryboard (name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "Login")
            vc.modalPresentationStyle = .overFullScreen
            present(vc ,animated: true)
    
    }
    
    
    func signUp () {
    Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (authResult, error) in
        let db = Firestore.firestore()
        
        let fistname = self.firstName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastname = self.lastName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        db.collection("users").document((authResult?.user.uid)!).setData([
            "firstName":fistname,
            "lastName":lastname,
            "type":"User"
        ]) { error in
            if error != nil {
                print("error: \(error?.localizedDescription)")
            }
        }
        
        
        guard let user = authResult?.user , error == nil else {
            print("Error \(error?.localizedDescription)")
            return
        }
        
        let storyBoard = UIStoryboard (name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "MainHome")
            vc.modalPresentationStyle = .overFullScreen
        self.present(vc ,animated: true)
        }
    }
}
