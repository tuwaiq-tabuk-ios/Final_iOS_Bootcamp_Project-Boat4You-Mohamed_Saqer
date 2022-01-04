//
//  EditOwnerInfoVC.swift
//  Boat4You
//
//  Created by Mohammed on 29/05/1443 AH.
//

import UIKit
import PhotosUI
import Firebase
import FirebaseStorage



class EditOwnerInfoVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,PHPickerViewControllerDelegate {
 
  
 
  
 
  

  @IBOutlet weak var editNameTextField: UITextField!
  @IBOutlet weak var editPriceTextField: UITextField!
  @IBOutlet weak var editTitleTextField: UITextField!
  @IBOutlet weak var editLocationTextField: UITextField!
  @IBOutlet weak var editTypeTextField: UITextField!
  @IBOutlet weak var editDescriptionTextField: UITextField!
  @IBOutlet weak var logoImage: UIImageView!
  
//  @IBOutlet weak var editCollectionImage: UIImageView!
  
  var logo: Bool!
  var storeImages:[UIImage] = [UIImage]()
  var store: Store!
  var id: String!
  
  override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

 
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return storeImages.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! imageCollectionViewCell
    
    cell.collectionImage.image = storeImages[indexPath.row]
    cell.removeImageButton.tag = indexPath.row
    return cell
  }
  
  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    if logo {
      if let result = results.first,result.itemProvider.canLoadObject(ofClass: UIImage.self) {
        result.itemProvider.loadObject(ofClass: UIImage.self) {
          (image,error) in if let image = image as? UIImage {
            DispatchQueue.main.async {
              self.logoImage.image = image
            }
          }
        }
      }
    } else {
    
    for result in results {
      result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in DispatchQueue.main.async {
//        self.logoImage.append(image)
//        self.editCollectionImage.reloadData()
      }
        
      }
    }
  }
}
}

