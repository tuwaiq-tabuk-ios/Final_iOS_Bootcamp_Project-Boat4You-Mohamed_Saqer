//
//  String+Ext.swift
//  Boat4You
//
//  Created by Mohammed on 18/06/1443 AH.
//

import UIKit

extension String {
  
  func localize() -> String {
    return NSLocalizedString(self,
                      tableName: "Localizable",
                      bundle: .main,
                      value: self,
                      comment: self)
  }
}

