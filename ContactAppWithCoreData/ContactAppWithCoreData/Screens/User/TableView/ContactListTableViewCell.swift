//
//  ContactListTableViewCell.swift
//  ContactAppWithCoreData
//
//  Created by Vijay Sharma on 03/07/24.
//

import UIKit

class ContactListTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var contactNumberLbl: UILabel!
    @IBOutlet weak var contactImageView: UIImageView!
    
    
    var userContact: ContactEntity? {
        didSet {
            setUserData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setUserData() {
        guard let userContact else { return }
        
        let fullName = "\(userContact.firstName ?? "") \(userContact.lastName ?? "")"
        nameLbl.text = fullName
        contactNumberLbl.text = userContact.contactNumber
        
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documents.appendingPathComponent(userContact.imageName ?? "",conformingTo: .png)
        
        contactImageView.image = UIImage(contentsOfFile: fileURL.path())
        //print(fileURL.pathComponents)
        
    }
}
