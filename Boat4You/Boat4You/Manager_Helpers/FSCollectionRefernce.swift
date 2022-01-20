//
//  FSCollectionRefernce.swift
//  Boat4You
//
//  Created by Mohammed on 14/06/1443 AH.
//

import Firebase
import FirebaseFirestore

enum FSCollectionReference: String {
  case users
}

func getFSCollectionReference(
_ collectionReference: FSCollectionReference
) -> CollectionReference {
  return Firestore.firestore()
    .collection(collectionReference.rawValue)
}
