//
//  BookingVC.swift
//  Boat4You
//
//  Created by Mohammed on 02/06/1443 AH.
//

import UIKit
import Firebase
import FirebaseAuth

class BookingVC: UIViewController {
  
  @IBOutlet weak var phoneNumber: UITextField!
  @IBOutlet weak var dateTextField: UITextField!
  
  var dataRequested: Store!
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  
  @IBAction func bookingTapped(_ sender: UIButton) {
    sendBook()
  }
  
  
  func sendBook() {
    let db = Firestore.firestore()
    let auth = Auth.auth().currentUser!
    
    db.collection("orders")
      .document(dataRequested.id)
      .setData([auth.uid:["phoneNumber" : self.phoneNumber.text!,
                          "dateTextField": self.dateTextField.text!
                         ]],merge: true)
  }
}
