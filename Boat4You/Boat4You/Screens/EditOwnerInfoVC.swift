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
import FirebaseFirestore

class EditOwnerInfoVC: UIViewController,
                       UINavigationBarDelegate,
                       UINavigationControllerDelegate {
  
  //MARK: - IBOutlet
 
  @IBOutlet weak var uploadedImagesCV    : UICollectionView!
  @IBOutlet weak var editNameField       : UITextField!
  @IBOutlet weak var editPriceField      : UITextField!
  @IBOutlet weak var editTitleField      : UITextField!
  @IBOutlet weak var editLocationField   : UITextField!
  @IBOutlet weak var editTypeField       : UITextField!
  @IBOutlet weak var editDescriptionField: UITextField!
  @IBOutlet weak var logoImage           : UIImageView!
  @IBOutlet weak var progressBar         : UIProgressView!
  
  
  //MARK: - Properties
  
  let cityPicker = UIPickerView()
  let typePicker = UIPickerView()
  var citiesList = ["Duba","Umlaj","Alwajeh","Jeddah"]
  var typeList = ["Craft","Boat"]
  var imagesArray = [UIImage]()
  var currentIndex = 0
  var oldType:String!
  var stores:Store!
  
  
  //MARK: - View Controller Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    cityPicker.delegate = self
    cityPicker.delegate = self
    
    typePicker.delegate = self
    typePicker.delegate = self
    
    uploadedImagesCV.delegate = self
    uploadedImagesCV.dataSource = self
    
    progressBar.progress = 0.0
  
    typePicking ()
    cityPicking ()
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    editNameField.text        = stores!.captainName
    editPriceField.text       = stores!.price
    editTitleField.text       = stores!.title
    editLocationField.text    = stores!.selectCity
    editTypeField.text        = stores!.selectType
    editDescriptionField.text = stores!.offerDescription
    oldType                   = stores!.selectType.lowercased()
    
    let imageView = UIImageView()
    imageView.sd_setImage(with: URL(string: stores.logo),
                          placeholderImage: UIImage(named: ""))
    
    logoImage.image = imageView.image
    getImages()
  }
  
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    getImages()
  }
  
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    stores = nil
    imagesArray.removeAll()
  }
  
  
  //MARK: - IBAction
 
  @IBAction func deletImagePressed(_ sender: UIButton) {
    let index = sender.tag
    imagesArray.remove(at: index)
    uploadedImagesCV.reloadData()
  }
  
  
  @IBAction func uploadImages(_ sender: UIButton) {
    getPhotos()
  }
  
  
  @IBAction func uploadLogo(_ sender: UIButton) {
    showPhotoAlert()
  }
  
  
  @IBAction func sendDataPressed(_ sender: UIButton) {
    sendUpdatedDataToFireStore ()
  }
 
  
  //MARK: - Methods
  
  func sendUpdatedDataToFireStore () {
    
    self.navigationController?.navigationBar.isUserInteractionEnabled = false;
   
    let db = Firestore.firestore()
    let auth = Auth.auth().currentUser
    let storage = Storage.storage()
    var imageID = UUID().uuidString
    let imageFolderID = stores!.id
    
    let uploadMetadata = StorageMetadata()
    uploadMetadata.contentType = "image/jpeg"
    let type = self.editTypeField.text?.lowercased()
    
    if oldType != type {
      let document = db.collection("sections").document(oldType)
      
      document.updateData([
        self.stores.id: FieldValue.delete()
      ])
    }
    
    let database = db.collection("sections").document(type!)
   
    imageID = UUID().uuidString
    
    database.setData(
      ["\(imageFolderID)"   : [
        "title"             :self.editTitleField.text!,
        "captainName"       :self.editNameField.text!,
        "price"             :self.editPriceField.text!,
        "selectCity"        :self.editLocationField.text!,
        "selectType"        :self.editTypeField.text!,
        "productDescription":self.editDescriptionField.text!,
        "images"            :[""],
        "logo"              :""]
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
            .setData(["id":imageFolderID,
                      "type":type!,
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
                  print("~~ error: \(String(describing: error?.localizedDescription))")
                        return
                      }
                  print("--- Done")
                    })
                  
                  var imageData = [Data]()
                  
                  for image in imagesArray {
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
                          
                          //Database
                          
                          db.collection("sections").document(type!).setData(["\(imageFolderID)" : [
                            "captainName"       :self.editNameField.text!,
                            "price"             :self.editPriceField.text!,
                            "selectCity"        :self.editLocationField.text!,
                            "selectType"        :self.editTypeField.text!,
                            "productDescription":self.editDescriptionField.text!,
                            "images"            :imageURL,
                            
                          ]],merge: true, completion: {
                            error in
                            guard error == nil else {
                              print("~~ error: \(String(describing: error?.localizedDescription))")
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
  
  
  //MARK: - Upload Images
 
  func getImages() {
    self.imagesArray.removeAll()
    if stores.images.count >= 1 {
      for images in stores.images {
        let imageView = UIImageView()
        imageView.sd_setImage(with: URL(string: images),
                              placeholderImage: UIImage(named: "")) { image, error, _, _ in
          self.imagesArray.append(image!)
          self.uploadedImagesCV.reloadData()
        }
      }
    }
  }
  
  
  func getLogo(type: UIImagePickerController.SourceType){
    let pickerCont = UIImagePickerController()
    pickerCont.sourceType = type
    pickerCont.allowsEditing = false
    pickerCont.delegate = self
    present(pickerCont, animated: true, completion: nil)
  }
  
  
  //MARK: - Pickers
 
  func cityPicking () {
    
    let toolBarCity = UIToolbar()
    toolBarCity.barStyle = UIBarStyle.default
    toolBarCity.isTranslucent = true
    toolBarCity.sizeToFit()
    
    let cityDoneButon = UIBarButtonItem(title: "Done",
                                        style: .plain,
                                        target: self,
                                        action: #selector(closeCityPicker))
    toolBarCity.setItems([cityDoneButon], animated: true)
    toolBarCity.isUserInteractionEnabled = true
    
    editLocationField.inputView = cityPicker
    editLocationField.inputAccessoryView = toolBarCity
  }
  
  
  func typePicking () {
    
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
    editTypeField.inputView = typePicker
    editTypeField.inputAccessoryView = toolBarType
  }
  
  
  @objc func closeCityPicker () {
    editLocationField.text = citiesList[currentIndex]
    editLocationField.resignFirstResponder()
  }
  
  
  @objc func closeTypePicker () {
    editTypeField.text = typeList[currentIndex]
    editTypeField.resignFirstResponder()
  }
  
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
  }
  
  
  func getPhotos(){
    var config = PHPickerConfiguration()
    config.filter = .images
    config.selectionLimit = 5
    
    let phPickre = PHPickerViewController(configuration: config)
    phPickre.delegate = self
    present(phPickre, animated: true, completion: nil)
  }
  
  
  func showPhotoAlert(){
    let alert = UIAlertController(title: "Take Photo From:", message: nil, preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "Camera",
                                  style: .default,
                                  handler: { action in
      self.getLogo(type: .camera)
    }))
    alert.addAction(UIAlertAction(title: "Photo Library",
                                  style: .default,
                                  handler: { action in
      self.getLogo(type: .photoLibrary)
    }))
    alert.addAction(UIAlertAction(title:
                                    "Cancel",
                                  style: .cancel,
                                  handler: nil))
    present(alert, animated: true, completion: nil)
  }
}


//MARK: - UICollectionView
 
extension EditOwnerInfoVC: UICollectionViewDelegate,
                           UICollectionViewDataSource{
  
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return imagesArray.count
  }
  
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = uploadedImagesCV.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! ImageEditingCVCell
    cell.collectionImage.image = imagesArray[indexPath.row]
    
    return cell
  }
}


//MARK: - Upload Image

extension EditOwnerInfoVC:  UIPickerViewDelegate,
                            UIPickerViewDataSource{
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if (pickerView == cityPicker) {
      return citiesList.count
    } else {
      return typeList.count
    }
  }
  
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if (pickerView == cityPicker) {
      return citiesList[row]
    } else {
      return typeList[row]
    }
  }
  
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    currentIndex = row
    if (pickerView == cityPicker){
      editLocationField.text = citiesList[row]
    } else {
      editTypeField.text = typeList[row]
    }
  }
}


//MARK: - Upload Image

extension EditOwnerInfoVC: PHPickerViewControllerDelegate,
                           UIImagePickerControllerDelegate {
  
  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    dismiss(animated: true, completion: nil)
    for resulr in results{
      print("\(results.count)")
      resulr.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: {
        (imagePic,error) in
        if let imagePice = imagePic as? UIImage {
          DispatchQueue.main.async{
            self.imagesArray.append(imagePice)
            self.uploadedImagesCV.reloadData()
          }
        } else {
          
        }
      }
      )
    }
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
