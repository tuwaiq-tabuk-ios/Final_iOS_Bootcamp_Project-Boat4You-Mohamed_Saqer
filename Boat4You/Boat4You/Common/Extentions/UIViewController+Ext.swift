//
//  UIViewController+Ext.swift
//  Boat4You
//
//  Created by Mohammed on 14/06/1443 AH.
//

import Foundation
import UIKit


extension UIViewController {
  
  func showAlertMessage(title: String,
                        message: String) {
    let alertController = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .alert
    )
    
    let action = UIAlertAction(title: "Ok",
                      style: .cancel,
                               handler: nil)
   
    alertController.addAction(action)
    
    present(alertController, animated: true)
  }
  
}
