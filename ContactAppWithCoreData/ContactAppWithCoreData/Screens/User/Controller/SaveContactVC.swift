//
//  SaveContactVC.swift
//  ContactAppWithCoreData
//
//  Created by Vijay Sharma on 23/05/24.
//

import UIKit

class SaveContactVC: UIViewController {
    
    @IBOutlet weak var firstNameTxtFld: UITextField!
    @IBOutlet weak var lastNameTxtFld: UITextField!
    @IBOutlet weak var contactTxtFld: UITextField!
    
    
    private let dataBaseManager = DataBaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveContactBtn(_ sender: UIButton) {
        if saveUser() {
            clearTextFields()
            navigationController?.popViewController(animated: true)
        }
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
        dataBaseManager.addUser(UserModel(id: "",
                                          contact: contactNumber,
                                          firstName: firstName,
                                          lastName: lastName))
        return true
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
}

