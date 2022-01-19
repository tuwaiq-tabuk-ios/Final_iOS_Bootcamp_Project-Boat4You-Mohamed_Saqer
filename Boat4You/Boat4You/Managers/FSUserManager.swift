//
//  FSUserManager.swift
//  Boat4You
//
//  Created by Mohammed on 14/06/1443 AH.
//

import Foundation
import Firebase




  class FSUserManager {
    static let shared = FSUserManager()
    
    private init() {}
    
    var firstName = ""
    var lastName = ""
    
    
    // MARK: - Register
    
    func signUpUserWith(
      email: String,
      password: String,
      confirmPassword: String,
      firstName: String,
      lastName: String,
      type:String,
      completion: @escaping (_ error: Error?) -> Void
    ) {
      self.firstName = firstName
      self.lastName = lastName
      
      Auth
        .auth()
        .createUser(withEmail: email,
                    password: password) { (authDataResult, error) in
          
          completion(error)
          
          guard let user = authDataResult?.user ,
                error == nil else {
                  completion(error)
                  return
                }
          
          getFSCollectionReference(.users)
            .document((user.uid)).setData([
              "firstName":firstName,
              "lastName":lastName,
              "type":type
            ]) { error in
              if error != nil {
                completion(error)
              }
            }
        }
    }
  }
