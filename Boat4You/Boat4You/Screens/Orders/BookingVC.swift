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
  
  let storage = Storage.storage()
  var dataRequested: Store!
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  
  @IBAction func bookingTapped(_ sender: UIButton) {
    sendBook()
  }
  
  
  func sendBook() {
    let db = Firestore.firestore()
      let ref = db.collection("orders").document()
      ref.setData([
       "phoneNumber": self.phoneNumber.text!,
       "dateTextField": self.dateTextField.text!,
        "docID": ref.documentID,
       "id": dataRequested.id
      ], merge: true) { err in
        if let err = err {
          print("Error writing document: \(err)")
        } else {
          print("Successfully Added!")
          DispatchQueue.main.async {
            let alert = UIAlertController(title: "Done!", message: "Job created sucessfully.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
             self.phoneNumber.text = ""
             self.dateTextField.text = ""
              self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
          }
        }
      }
    }
}


