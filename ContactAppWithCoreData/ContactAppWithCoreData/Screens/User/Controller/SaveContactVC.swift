//
//  SaveContactVC.swift
//  ContactAppWithCoreData
//
//  Created by Vijay Sharma on 23/05/24.
//

import UIKit
import PhotosUI

class SaveContactVC: UIViewController {
    
    @IBOutlet weak var firstNameTxtFld: UITextField!
    @IBOutlet weak var lastNameTxtFld: UITextField!
    @IBOutlet weak var contactTxtFld: UITextField!
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var IBSaveContactBtn: UIButton!
    
    private let dataBaseManager = DataBaseManager()
    private var imageSelectedByUser: Bool = false
    
    var userContactDetail: ContactEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configuration()
    }
}
//Action button
extension SaveContactVC {
    @IBAction func saveContactBtn(_ sender: UIButton) {
        if saveUser() {
            clearTextFields()
            navigationController?.popViewController(animated: true)
        }
    }
}

//Functions
extension SaveContactVC {
    
    private func configuration()  {
        setupBackButton()
        addGestureRecognizers()
        configureContactImageView()
        updateUIWithUserDetails()
    }
    
    private func addGestureRecognizers()  {
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(SaveContactVC.openGallery))
        contactImageView.addGestureRecognizer(imageTapGesture)
    }
    //Date:: 05, Jul 2024
    private func configureContactImageView() {
        contactImageView.layer.cornerRadius = 50
        contactImageView.clipsToBounds = true // To ensure the corners are actually rounded
    }
    
    private func updateUIWithUserDetails() {
        guard let userDetail = userContactDetail else {
            return
        }
        print(userDetail)
        IBSaveContactBtn.setTitle("Update Contact", for: .normal)
        navigationItem.title = "Update Contact"
        
        firstNameTxtFld.text = userDetail.firstName
        lastNameTxtFld.text = userDetail.lastName
        contactTxtFld.text = userDetail.contactNumber
        
        
//        let fileURL = getImageURL(imageName: userDetail.imageName ?? "")
//        
//        contactImageView.image = UIImage(contentsOfFile: fileURL.path())
//        
//        imageSelectedByUser = true
        
        if let imageName = userDetail.imageName {
            let fileURL = getImageURL(imageName: imageName)
           
                if let image = UIImage(contentsOfFile: fileURL.path()) {
                    contactImageView.image = image
                } else {
                    contactImageView.image = UIImage(systemName: "person.circle.fill")
                }
        } else {
            contactImageView.image = UIImage(systemName: "person.circle.fill")
        }
        imageSelectedByUser = true
        
    }
    
    private func getImageURL(imageName: String) -> URL {
        let fileURL = FileManager.default.getDocumentDirectoryFileURL(for: imageName, withExtension: "png") // Create the path of image with .png type
        return fileURL
    }
    //End
    
    @objc private func openGallery() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        let imagePicker = PHPickerViewController(configuration: config)
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    @discardableResult // In Swift, the @discardableResult attribute is used to suppress compiler warnings when a function or method returns a value, but the caller does not use that value. This attribute is particularly useful for functions that perform an action but also return a value that is not always necessary for the caller to use.
    private func saveUser() -> Bool   {
        guard let firstName = firstNameTxtFld.text , !firstName.isEmpty else {
            showAlert(alert: "Alert",
                      message: "Please Enter First Name")
            return false
        }
        guard let lastName = lastNameTxtFld.text , !lastName.isEmpty else {
            showAlert(alert: "Alert",
                      message: "Please Enter Last Name")
            return false
        }
        guard let contactNumber = contactTxtFld.text , !contactNumber.isEmpty else {
            showAlert(alert: "Alert",
                      message: "Please Enter First Name")
            return false
        }
        
        let imageName = UUID().uuidString
        if !imageSelectedByUser {
            showAlert(alert: "Alert", message: "Please choose you profile Pic ")
            return false
        }
        
        var newContact = UserModel(contact: contactNumber,
                                   firstName: firstName,
                                   lastName: lastName,
                                   imageName: imageName)
        
        if let userDetail = userContactDetail {
            
            newContact.imageName = userDetail.imageName ?? ""
            
            
            saveImageInDocumentDirectory(imageName: userDetail.imageName ?? "")
            dataBaseManager.updateUserContact(contact: newContact, contactEntity: userDetail)
            
        } else {
            
            saveImageInDocumentDirectory(imageName: imageName)
            dataBaseManager.addUserContact(newContact)
        }
        
        return true
    }
    
    private func saveImageInDocumentDirectory(imageName: String) {
        
        let fileURL = FileManager.default.getDocumentDirectoryFileURL(for: imageName, withExtension: "png")
        
        guard let imageData = contactImageView.image?.pngData() else {
            print("Error: Could not convert image to PNG data.")
            return
        }
        
        do {
            try imageData.write(to: fileURL)
            print("Image saved successfully at \(fileURL)")
        } catch {
            print("Error saving image: \(error.localizedDescription)")
        }
    }
    
    private func clearTextFields() {
        firstNameTxtFld.text = ""
        lastNameTxtFld.text = ""
        contactTxtFld.text = ""
    }
    
    private func showAlert(alert:String, message: String) {
        let alert = UIAlertController(title: alert, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
    
    private func setupBackButton(){
        let backButtonImg = UIButton()
        backButtonImg.setImage(UIImage(named: "ic_blackBackArrow"), for: .normal)
        backButtonImg.addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside) // Back Btn Action
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView:backButtonImg)
    }
    @objc func backBtnTapped(_ sender: UIBarButtonItem) {
        if self.navigationController?.viewControllers.count == 1 {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}
extension SaveContactVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        for result in results {
            let itemProvider = result.itemProvider
            
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                    
                    if let error = error {
                        print("Error loading image: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let image = object as? UIImage else {
                        print("Error: Loaded object is not a UIImage")
                        return
                    }
                    DispatchQueue.main.async {
                        self?.contactImageView.image = image
                        self?.imageSelectedByUser = true
                    }
                    
                }
                
            }
        }
    }
}
