//
//  AddingProductDetailsVC.swift
//  Boat4You
//
//  Created by Mohammed on 22/05/1443 AH.
//

import UIKit
import PhotosUI
import Firebase
import FirebaseAuth

class AddingProductDetailsVC: UIViewController,
                              UIImagePickerControllerDelegate,
                              UINavigationControllerDelegate,
                              UIPickerViewDataSource,
                              UIPickerViewDelegate,
                              UITextViewDelegate,
                              UICollectionViewDelegate,
                              UICollectionViewDataSource,PHPickerViewControllerDelegate{
  
  @IBOutlet weak var productName: UITextField!
  @IBOutlet weak var price: UITextField!
  @IBOutlet weak var selectCity: UITextField!
  @IBOutlet weak var selectType: UITextField!
  @IBOutlet weak var productDescription: UITextField!
  @IBOutlet weak var uploadedPicsCollection: UICollectionView!
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var logoImage: UIImageView!
  
  
  let cityPicker = UIPickerView()
  let typePicker = UIPickerView()
  var citiesArr = ["Duba","Umlaj","Alwajeh","Jeddah"]
  var typeArr = ["Craft","Boat"]
  var arryPhoto = [UIImage]()
  var currentIndex = 0
  
  var toolBarCity = UIToolbar()
  var toolBarType = UIToolbar()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    cityPicker.delegate = self
    cityPicker.delegate = self
    selectCity.inputView = cityPicker
    
    typePicker.delegate = self
    typePicker.delegate = self
    selectType.inputView = typePicker
    
    uploadedPicsCollection.delegate = self
    uploadedPicsCollection.dataSource = self
    
    
    toolBarCity = UIToolbar()
    toolBarCity.barStyle = UIBarStyle.default
    toolBarCity.isTranslucent = true
    toolBarCity.sizeToFit()
    
    let cityDoneButon = UIBarButtonItem(title: "Done",
                                     style: .plain,
                                     target: self,
                                     action: #selector(closeCityPicker))
    toolBarCity.setItems([cityDoneButon], animated: true)
    toolBarCity.isUserInteractionEnabled = true
    selectCity.inputView = cityPicker
    selectCity.inputAccessoryView = toolBarCity
    
    
    toolBarType = UIToolbar()
    toolBarType.barStyle = UIBarStyle.default
    toolBarType.isTranslucent = true
    toolBarType.sizeToFit()
    
    let typeDoneButon = UIBarButtonItem(title: "Done",
                                     style: .plain,
                                     target: self,
                                     action: #selector(closeTypePicker))
    toolBarType.setItems([typeDoneButon], animated: true)
    toolBarType.isUserInteractionEnabled = true
    selectType.inputView = typePicker
    selectType.inputAccessoryView = toolBarType
    
    
    
  }
  
  
  
  @IBAction func uploadImages(_ sender: UIButton) {
    //        let picker = UIImagePickerController()
    //        picker.sourceType = .photoLibrary
    //        picker.delegate = self
    //        picker.allowsEditing = true
    //        present(picker, animated: true)
    getPhotos()
  }
  
  
  @IBAction func uploadLogo(_ sender: UIButton) {
    showPhotoAlert()
    
  }
  
  
  @IBAction func sendDataPressed(_ sender: UIButton) {
    
    let db = Firestore.firestore()
    let auth = Auth.auth().currentUser
    let storage = Storage.storage()
    
    //        var documentID = ""
    //        if documentID == "" {
    //            documentID = UUID().uuidString
    //        }
    
    var imageID = UUID().uuidString
    let imageFolderID = UUID().uuidString
    
    let uploadMetadata = StorageMetadata()
    uploadMetadata.contentType = "image/jpeg"
    
    let type = self.selectType.text?.lowercased()
    
    let database = db.collection("sections").document(type!)
    let id = database.documentID
    
    
    imageID = UUID().uuidString
    
    
    database.setData(
      ["\(imageFolderID)" : [
        "title":self.titleTextField.text!,
        "productName":self.productName.text!,
        "price":self.price.text!,
        "selectCity":self.selectCity.text!,
        "selectType":self.selectType.text!,
        "productDescription":self.productDescription.text!,
        "images":[""],
        "logo":""]
      ],
      merge: true) { error in
        guard error == nil else {
          return
        }
        
        db.collection("stores")
          .document(auth!.uid)
          .collection("store")
          .document(imageFolderID)
          .setData(["id":imageFolderID, "type":type!,
                   ]) {error in
            guard error == nil else {
              return
            }
          }
      }
    
    
    let logoImage = self.logoImage.image?.jpegData(compressionQuality: 0.5)
    //    imageID = UUID().uuidString
    
    let storageRf = storage.reference().child(auth!.uid).child(imageFolderID).child(imageID)
    storageRf.putData(logoImage!,
                      metadata: uploadMetadata) { metadata, error in
      guard error == nil else {
        return
      }
      
      storageRf.downloadURL { [self] url, error in
        if error != nil {
        } else {
          
          db.collection("sections").document(type!).setData(["\(imageFolderID)" : [
            "logo":url?.absoluteString]],merge: true, completion: { error in
              guard error == nil else {
                print("~~ error: \(error?.localizedDescription)")
                return
              }
              print("~~ Done")
              
            })
          
          var imageData = [Data]()
          for image in arryPhoto {
            let data = image.jpegData(compressionQuality: 0.5)
            imageData.append(data!)
          }
          var imageURL = [String]()
          for image in imageData {
            imageID = UUID().uuidString
            
            let storageRf = storage.reference().child(auth!.uid).child(imageFolderID).child(imageID)
            storageRf.putData(image, metadata: uploadMetadata) { metadata, error in
              guard error == nil else {
                return
              }
              storageRf.downloadURL { url, error in
                if error != nil {
                } else {
                  imageURL.append(url!.absoluteString)
                  
                  //                        database
                  
                  db.collection("sections").document(type!).setData(["\(imageFolderID)" : [
                    "productName":self.productName.text!,
                    "price":self.price.text!,
                    "selectCity":self.selectCity.text!,
                    "selectType":self.selectType.text!,
                    "productDescription":self.productDescription.text!,
                    "images":imageURL,
                    
                    
                  ]],merge: true, completion: {
                    error in
                    guard error == nil else {
                      print("~~ error: \(error?.localizedDescription)")
                      return
                    }
                    print("~~ Done")
                    
                  })
                  
                }
              }
            }
            
          }
        }
      }
    }
  }
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
  }
  
  //    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
  //        picker.dismiss(animated: true, completion: nil)
  //        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
  //            return
  //        }
  //        guard let imageData = image.pngData() else {
  //            return
  //        }
  //    }
  
  
  //    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
  //        picker.dismiss(animated: true, completion: nil)
  //    }
  
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if (pickerView == cityPicker) {
      return citiesArr.count
    } else {
      return typeArr.count
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if (pickerView == cityPicker) {
      return citiesArr[row]
    } else {
      return typeArr[row]
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    currentIndex = row
    if (pickerView == cityPicker){
      selectCity.text = citiesArr[row]
    } else {
      selectType.text = typeArr[row]
    }
  }
  
  @objc func closeCityPicker () {
    selectCity.text = citiesArr[currentIndex]
    selectCity.resignFirstResponder()
  }
  
  @objc func closeTypePicker () {
    selectType.text = typeArr[currentIndex]
    selectType.resignFirstResponder()
  }
  
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return arryPhoto.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = uploadedPicsCollection.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! ImageCVCell
    cell.imgSelected.image = arryPhoto[indexPath.row]
    
    return cell
  }
  
  func getPhotos(){
    var config = PHPickerConfiguration()
    config.filter = .images
    config.selectionLimit = 5
    
    let phPickre = PHPickerViewController(configuration: config)
    phPickre.delegate = self
    present(phPickre, animated: true, completion: nil)
    
  }
  
  
  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    dismiss(animated: true, completion: nil)
    for resulr in results{
      print("\(results.count)")
      resulr.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: {
        (imagePic,error) in
        if let imagePice = imagePic as? UIImage {
          DispatchQueue.main.async{
            self.arryPhoto.append(imagePice)
            self.uploadedPicsCollection.reloadData()
          }
        } else {
          
        }
      }
      )
    }
  }
  
  func showPhotoAlert(){
    let alert = UIAlertController(title: "Take Photo From:", message: nil, preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "Camera",
                                  style: .default,
                                  handler: { action in
      self.getPhoto(type: .camera)
    }))
    alert.addAction(UIAlertAction(title: "Photo Library",
                                  style: .default,
                                  handler: { action in
      self.getPhoto(type: .photoLibrary)
    }))
    alert.addAction(UIAlertAction(title:
                                    "Cancel",
                                  style: .cancel,
                                  handler: nil))
    present(alert, animated: true, completion: nil)
  }
  func getPhoto(type: UIImagePickerController.SourceType){
    let pickerCont = UIImagePickerController()
    pickerCont.sourceType = type
    pickerCont.allowsEditing = false
    pickerCont.delegate = self
    present(pickerCont, animated: true, completion: nil)
  }
  
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    dismiss(animated: true, completion: nil)
    guard let image = info[.originalImage] as? UIImage else {
      print("Image Not Found")
      return
    }
    logoImage.image = image
  }
}
