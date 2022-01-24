//
//  BookingVC.swift
//  Boat4You
//
//  Created by Mohammed on 02/06/1443 AH.
//

import UIKit
import Firebase
import FirebaseAuth

class ClientBookVC: UIViewController {
  
  // MARK: - IBOutlet
  @IBOutlet weak var phoneNumber: UITextField!
  @IBOutlet weak var dateTextField: UITextField!
  
  // MARK: - Properties
  let storage = Storage.storage()
  var dataRequested: Store!
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    hideKeyboardWhenTappedAround()
  }
  
  // MARK: - IBAction
  @IBAction func bookingTapped(_ sender: UIButton) {
    sendBook()
  }
  
  
  // MARK: Send Reservation to owner
  func sendBook() {
    let db = Firestore.firestore()
    let ref = db.collection("orders").document()
    
    ref.setData([
      "phoneNumber"  : self.phoneNumber.text!,
      "date": self.dateTextField.text!,
      "docID"        : ref.documentID,
      "id"           : dataRequested.id
    ], merge: true) { error in
      
      if let error = error {
        print("Error writing document: \(error)")
        
      } else {
        print("Successfully Added!")
        DispatchQueue.main.async {
          
          let alert = UIAlertController(title: "Done!".localize(),
                                        message: "Order created sucessfully.".localize(),
                                        preferredStyle: .alert)
          
          alert.addAction(UIAlertAction(title: "OK",
                                        style: .cancel,
                                        handler: { _ in
            self.phoneNumber.text   = ""
            self.dateTextField.text = ""
            self.navigationController?.popViewController(animated: true)
          }))
          self.present(alert, animated: true, completion: nil)
        }
      }
    }
  }
}


