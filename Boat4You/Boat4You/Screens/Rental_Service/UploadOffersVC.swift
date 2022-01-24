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
import FirebaseFirestore
import SwiftUI
class UploadOffersVC: UIViewController,
                      UINavigationControllerDelegate,
                      UITextViewDelegate{
  
  
  // MARK: - IBOutlets
  
  @IBOutlet weak var captainNameField: UITextField!
  @IBOutlet weak var priceField: UITextField!
  @IBOutlet weak var selectCityField: UITextField!
  @IBOutlet weak var selectTypeField: UITextField!
  @IBOutlet weak var OfferDescriptionField: UITextField!
  @IBOutlet weak var uploadImagesCV: UICollectionView!
  @IBOutlet weak var titleField: UITextField!
  @IBOutlet weak var logoImage: UIImageView!
  @IBOutlet weak var errorLabel: UILabel!
  
  
  // MARK: - Properties
  
  let cityPicker = UIPickerView()
  let typePicker = UIPickerView()
  var citiesList = ["Duba".localize(),"Umlaj".localize(),"Alwajeh".localize(),"Jeddah".localize()]
  var typeList = ["Craft".localize(),"Boat".localize()]
  var imagesArray = [UIImage]()
  var currentIndex = 0
  var toolBarCity = UIToolbar()
  var toolBarType = UIToolbar()
  
  
  // MARK: - View Contrller Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    errorLabel.isHidden = true
    
    cityPicker.delegate = self
    cityPicker.delegate = self
    selectCityField.inputView = cityPicker
    
    typePicker.delegate = self
    typePicker.delegate = self
    selectTypeField.inputView = typePicker
    
    uploadImagesCV.delegate = self
    uploadImagesCV.dataSource = self
    
    cityBar ()
    typeBar ()
    
    hideKeyboardWhenTappedAround()
    
  }
  

  // MARK: - IBActions
  
  @IBAction func uploadImages(_ sender: UIButton) {
    getImages()
  }
  
  
  @IBAction func uploadLogo(_ sender: UIButton) {
    showPhotoAlert()
  }
  
  
  @IBAction func sendDataPressed(_ sender: UIButton) {
    
   
    guard let title = titleField.text,
          title.isEmpty == false else {
            errorLabel.isHidden = false
            errorLabel.text = "Fill in the title field".localize()
            return
          }
    
    guard let captainName = captainNameField.text,
          captainName.isEmpty == false else {
            errorLabel.isHidden = false
            errorLabel.text = "Fill in the captain field".localize()
            return
          }
    
    guard let price = priceField.text,
          price.isEmpty == false else {
            errorLabel.isHidden = false
            errorLabel.text = "Fill in the price field".localize()
            return
          }
    
    guard let type = selectCityField.text,
          type.isEmpty == false else {
            errorLabel.isHidden = false
            errorLabel.text = "Fill in the type field".localize()
            return
          }
    
    guard let city = selectCityField.text,
          city.isEmpty == false else {
            errorLabel.isHidden = false
            errorLabel.text = "Fill in the city field".localize()
            return
          }
    
    guard let description = OfferDescriptionField.text,
          description.isEmpty == false else {
            errorLabel.isHidden = false
            errorLabel.text = "Fill in the description field".localize()
            return
          }
    
    
    uploadDataToFireStore()
    showAlertMessage(title: "Successfully", message: "Data uploaded successfully".localize())
            return
  }
  
  
  // MARK: - Pickers
  
  func cityBar () {
    
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
    selectCityField.inputView = cityPicker
    selectCityField.inputAccessoryView = toolBarCity
  }
  
  
  func typeBar () {
    
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
    selectTypeField.inputView = typePicker
    selectTypeField.inputAccessoryView = toolBarType
  }
  
  
  // MARK: - Upload offer method
  
  func uploadDataToFireStore () {
    
    let db = Firestore.firestore()
    let auth = Auth.auth().currentUser
    let storage = Storage.storage()
    
    
    var imageID = UUID().uuidString
    let imageFolderID = UUID().uuidString
    
    let uploadMetadata = StorageMetadata()
    uploadMetadata.contentType = "image/jpeg"
    
    let type = self.selectTypeField.text?.lowercased()
    
    let database = db.collection("sections").document(type!)
//    let id = database.documentID
    
    
    imageID = UUID().uuidString
    
    
    database.setData(
      ["\(imageFolderID)" : [
        "title"             :self.titleField.text            ?? "Nil",
        "captainName"       :self.captainNameField.text      ?? "Nil",
        "price"             :self.priceField.text            ?? "Nil",
        "selectCity"        :self.selectCityField.text       ?? "Nil",
        "selectType"        :self.selectTypeField.text       ?? "Nil",
        "productDescription":self.OfferDescriptionField.text ?? "Nil",
        "images":[""] ,
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
                print("~~ error: \(String(describing: error?.localizedDescription))")
                return
              }
              print("~~ Done")
            })
          
          var imageData = [Data]()
          for image in imagesArray {
            let data = image.jpegData(compressionQuality: 0.5)
            imageData.append(data!)
          }
          var imageURL = [String]()
          for image in imageData {
            imageID = UUID().uuidString
            
            let storageRf = storage
              .reference()
              .child(auth!.uid)
              .child(imageFolderID)
              .child(imageID)
            storageRf.putData(image, metadata: uploadMetadata) { metadata, error in
              guard error == nil else {
                return
              }
              storageRf.downloadURL { url, error in
                if error != nil {
                } else {
                  imageURL.append(url!.absoluteString)
                  
                  //Database
              
                  db.collection("sections")
                    .document(type!)
                    .setData(["\(imageFolderID)" : [
                    "captainName"       :self.captainNameField.text      ?? "Nil" ,
                    "price"             :self.priceField.text            ?? "Nil",
                    "selectCity"        :self.selectCityField.text       ?? "Nil",
                    "selectType"        :self.selectTypeField.text       ?? "Nil",
                    "productDescription":self.OfferDescriptionField.text ?? "Nil",
                    "images":imageURL,
                    
                    
                  ]],merge: true, completion: {
                    error in
                  
                    guard error == nil else {
                      print("~~ error: \(String(describing: error?.localizedDescription))")
                      
                      return
                    }
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

  
  @objc func closeCityPicker () {
    selectCityField.text = citiesList[currentIndex]
    selectCityField.resignFirstResponder()
  }
  
  
  @objc func closeTypePicker () {
    selectTypeField.text = typeList[currentIndex]
    selectTypeField.resignFirstResponder()
  }
 
  
  func getImages(){
    var config = PHPickerConfiguration()
    config.filter = .images
    config.selectionLimit = 5
    
    let phPickre = PHPickerViewController(configuration: config)
    phPickre.delegate = self
    present(phPickre, animated: true, completion: nil)
  }
  
  
  func getLogo(type: UIImagePickerController.SourceType){
    let pickerCont = UIImagePickerController()
    pickerCont.sourceType = type
    pickerCont.allowsEditing = false
    pickerCont.delegate = self
    present(pickerCont, animated: true, completion: nil)
  }
  
  
  func showPhotoAlert(){
    let alert = UIAlertController(title: "Take Photo From:".localize(), message: nil, preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "Camera".localize(),
                                  style: .default,
                                  handler: { action in
      self.getLogo(type: .camera)
    }))
    alert.addAction(UIAlertAction(title: "Photo Library".localize(),
                                  style: .default,
                                  handler: { action in
      self.getLogo(type: .photoLibrary)
    }))
    alert.addAction(UIAlertAction(title:
                                    "Cancel".localize(),
                                  style: .cancel,
                                  handler: nil))
    present(alert, animated: true, completion: nil)
  }
}



// MARK: - UICollectionView

extension UploadOffersVC: UICollectionViewDelegate,
                          UICollectionViewDataSource {
                            
                            
                            
                            func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                              return imagesArray.count
                            }
                            
                            
                            func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                              let cell = uploadImagesCV.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! ImageCVCell
                              cell.imgSelected.image = imagesArray[indexPath.row]
                              
                              return cell
                            }
                          }


// MARK: - Image Pickers

extension UploadOffersVC: UIImagePickerControllerDelegate,
                          PHPickerViewControllerDelegate{
  
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    dismiss(animated: true, completion: nil)
    guard let image = info[.originalImage] as? UIImage else {
      print("Image Not Found")
      return
    }
    logoImage.image = image
  }
  
  
  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    dismiss(animated: true, completion: nil)
    for resulr in results{
      print("\(results.count)")
      resulr.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: {
        (imagePic,error) in
        if let imagePice = imagePic as? UIImage {
          DispatchQueue.main.async{
            self.imagesArray.append(imagePice)
            self.uploadImagesCV.reloadData()
          }
        } else {
        }
      }
      )
    }
  }
}


// MARK: - UIPickerView

extension UploadOffersVC: UIPickerViewDataSource,
                          UIPickerViewDelegate {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  
  func pickerView(_ pickerView: UIPickerView,
                  numberOfRowsInComponent component: Int) -> Int {
    if (pickerView == cityPicker) {
      return citiesList.count
    } else {
      return typeList.count
    }
  }
  
  
  func pickerView(_ pickerView: UIPickerView,
                  titleForRow row: Int,
                  forComponent component: Int) -> String? {
    if (pickerView == cityPicker) {
      return citiesList[row]
    } else {
      return typeList[row]
    }
  }
  
  
  func pickerView(_ pickerView: UIPickerView,
                  didSelectRow row: Int,
                  inComponent component: Int) {
    currentIndex = row
    if (pickerView == cityPicker){
      selectCityField.text = citiesList[row]
    } else {
      selectTypeField.text = typeList[row]
    }
  }
}
