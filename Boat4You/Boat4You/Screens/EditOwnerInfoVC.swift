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


class EditOwnerInfoVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,PHPickerViewControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationBarDelegate, UINavigationControllerDelegate {
 

  @IBOutlet weak var uploadedPicsCollection: UICollectionView!
  @IBOutlet weak var editNameTextField: UITextField!
  @IBOutlet weak var editPriceTextField: UITextField!
  @IBOutlet weak var editTitleTextField: UITextField!
  @IBOutlet weak var editLocationTextField: UITextField!
  @IBOutlet weak var editTypeTextField: UITextField!
  @IBOutlet weak var editDescriptionTextField: UITextField!
  @IBOutlet weak var logoImage: UIImageView!
  
  @IBOutlet weak var progressBar: UIProgressView!
  
  
//  @IBOutlet weak var editCollectionImage: UIImageView!
  
  let cityPicker = UIPickerView()
  let typePicker = UIPickerView()
  var citiesArr = ["Duba","Umlaj","Alwajeh","Jeddah"]
  var typeArr = ["Craft","Boat"]
  var arryPhoto = [UIImage]()
  var currentIndex = 0
  var oldType:String!
  
  var store:Store!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    cityPicker.delegate = self
    cityPicker.delegate = self
    
    typePicker.delegate = self
    typePicker.delegate = self
    
    uploadedPicsCollection.delegate = self
    uploadedPicsCollection.dataSource = self
    
    
    let toolBarCity = UIToolbar()
    let cityDoneButon = UIBarButtonItem(title: "Done",
                                     style: .plain,
                                     target: self,
                                     action: #selector(closeCityPicker))
    toolBarCity.setItems([cityDoneButon], animated: true)
    toolBarCity.isUserInteractionEnabled = true
    
    editLocationTextField.inputView = cityPicker
    editLocationTextField.inputAccessoryView = toolBarCity
    
    
    
    
    let toolBarType = UIToolbar()
    toolBarType.barStyle = UIBarStyle.default
    toolBarType.isTranslucent = true
    toolBarType.sizeToFit()
    
    let typeDoneButon = UIBarButtonItem(title: "Done",
                                     style: .plain,
                                     target: self,
                                     action: #selector(closeTypePicker))
    toolBarType.setItems([typeDoneButon], animated: true)
    toolBarType.isUserInteractionEnabled = true
    editTypeTextField.inputView = typePicker
    editTypeTextField.inputAccessoryView = toolBarType
    
    progressBar.progress = 0.0
    
    
  }
  
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    editNameTextField.text = store!.productName
    editPriceTextField.text = store!.price
    editTitleTextField.text = store!.title
    editLocationTextField.text = store!.selectCity
    editTypeTextField.text = store!.selectType
    editDescriptionTextField.text = store!.productDescription
    oldType = store!.selectType.lowercased()
    
    let imageView = UIImageView()
    imageView.sd_setImage(with: URL(string: store.logo), placeholderImage: UIImage(named: ""))
    
    logoImage.image = imageView.image
    getImages()
    
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    getImages()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    store = nil
    arryPhoto.removeAll()
    print("~~ I'm here")
  }
  
  func getImages() {
    self.arryPhoto.removeAll()
    print("~~ \(store.images.count)")
    if store.images.count >= 1 {
    for images in store.images {
      print("~~ \(store.images.count)")
      let imageView = UIImageView()
      imageView.sd_setImage(with: URL(string: images), placeholderImage: UIImage(named: "")) { image, error, _, _ in
        self.arryPhoto.append(image!)
        self.uploadedPicsCollection.reloadData()
        print("~~ \(self.arryPhoto.count )")
      }
      
    }
    }
  }
  
  @IBAction func deletImagePressed(_ sender: UIButton) {
    let index = sender.tag
    arryPhoto.remove(at: index)
    uploadedPicsCollection.reloadData()
  
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
    
    self.view.isUserInteractionEnabled = false;
    self.navigationController?.navigationBar.isUserInteractionEnabled = false;
    
    
    
    
    let db = Firestore.firestore()
    let auth = Auth.auth().currentUser
    let storage = Storage.storage()
    
    //        var documentID = ""
    //        if documentID == "" {
    //            documentID = UUID().uuidString
    //        }
    
    var imageID = UUID().uuidString
    let imageFolderID = store!.id
    
    let uploadMetadata = StorageMetadata()
    uploadMetadata.contentType = "image/jpeg"
    
    let type = self.editTypeTextField.text?.lowercased()
    
    if oldType != type {
      let document = db.collection("sections").document(oldType)
            
       document.updateData([
        self.store.id: FieldValue.delete()
       ])
      

    }
    
    let database = db.collection("sections").document(type!)
//    let id = database.documentID
    
    
    imageID = UUID().uuidString
    
    
    database.setData(
      ["\(imageFolderID)" : [
        "title":self.editTitleTextField.text!,
        "productName":self.editNameTextField.text!,
        "price":self.editPriceTextField.text!,
        "selectCity":self.editLocationTextField.text!,
        "selectType":self.editTypeTextField.text!,
        "productDescription":self.editDescriptionTextField.text!,
        "images":[""],
        "logo":""]
      ],
      merge: true) { error in
        guard error == nil else {
          return
        }
        
        self.progressBar.progress = 0.2
        db.collection("stores")
          .document(auth!.uid)
          .collection("store")
          .document(imageFolderID)
          .setData(["id":imageFolderID, "type":type!,
                   ]) {error in
            guard error == nil else {
              return
            }
            self.progressBar.progress = 0.4
            let logoImage = self.logoImage.image?.jpegData(compressionQuality: 0.5)
            let storageRf = storage.reference().child(auth!.uid).child(imageFolderID).child(imageID)
            storageRf.putData(logoImage!,
                              metadata: uploadMetadata) { metadata, error in
              guard error == nil else {
                return
              }
              
              storageRf.downloadURL { [self] url, error in
                if error != nil {
                } else {
                  self.progressBar.progress = 0.6
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
                      self.progressBar.progress = 0.8
                      storageRf.downloadURL { url, error in
                        if error != nil {
                        } else {
                          imageURL.append(url!.absoluteString)
                          
                          //                        database
                          
                          db.collection("sections").document(type!).setData(["\(imageFolderID)" : [
                            "productName":self.editNameTextField.text!,
                            "price":self.editPriceTextField.text!,
                            "selectCity":self.editLocationTextField.text!,
                            "selectType":self.editTypeTextField.text!,
                            "productDescription":self.editDescriptionTextField.text!,
                            "images":imageURL,
                            
                            
                          ]],merge: true, completion: {
                            error in
                            guard error == nil else {
                              print("~~ error: \(error?.localizedDescription)")
                              return
                            }
                            print("~~ Done")
                            self.view.isUserInteractionEnabled = true;
                            self.navigationController?.navigationBar.isUserInteractionEnabled = true;
                            self.progressBar.progress = 1.0
                            self.navigationController?.popViewController(animated: true)
                            
                          })
                          
                        }
                      }
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
      editLocationTextField.text = citiesArr[row]
    } else {
      editTypeTextField.text = typeArr[row]
    }
  }
  
  @objc func closeCityPicker () {
    editLocationTextField.text = citiesArr[currentIndex]
    editLocationTextField.resignFirstResponder()
  }
  
  
  @objc func closeTypePicker () {
    editTypeTextField.text = typeArr[currentIndex]
    editTypeTextField.resignFirstResponder()
  }
  
  
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return arryPhoto.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = uploadedPicsCollection.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! ImageEditingCVCell
    cell.collectionImage.image = arryPhoto[indexPath.row]
    
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

