//
//  UpdateOwnerProfileVC.swift
//  Boat4You
//
//  Created by Mohammed on 02/06/1443 AH.
//

import UIKit
import Firebase
import FirebaseAuth

class UpdateOwnerInfoVC: UIViewController {
  
  
  // MARK: -IBOutlet
 
  @IBOutlet weak var firstNameField: UITextField!
  @IBOutlet weak var lastNameField: UITextField!
  @IBOutlet weak var emailField: UITextField!
  
  
  // MARK: -  View Controller lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    hideKeyboardWhenTappedAround()
  }
 
  
  //MARK: - Action
 
  @IBAction func save(_ sender: Any) {
    let db = Firestore.firestore()
    let userID = Auth.auth().currentUser?.uid
    Auth.auth().currentUser?.updateEmail(to: emailField.text!,
                                         completion: { error in
    if error != nil {
        print("Error Update Email: \(String(describing: error?.localizedDescription))")
    
    } else {
        UserDefaults.standard.setValue(self.emailField.text!, forKey: "email")
        UserDefaults.standard.synchronize()
        db.collection("users").document(userID!).setData([
        "firstName":self.firstNameField.text!,
        "lastName" :self.lastNameField.text!
        ], merge: true)
      }
    })
  }
  
  
  //MARK: - Methods
 
  func updateOwnerProfile () {
    
    let db = Firestore.firestore()
    if let user = Auth.auth().currentUser{
      let id = user.uid
      db.collection("users")
        .document(id)
        .getDocument(completion: { result, error in
        if error != nil{
          print("--- Error:\(String(describing: error?.localizedDescription))")
        }else{
          if let data = result?.data(){
            self.firstNameField.text = data["firstName"] as? String
            self.lastNameField.text = data["lastName"] as? String
          }
        }
      })
      emailField.text = user.email
    }
  }
}
