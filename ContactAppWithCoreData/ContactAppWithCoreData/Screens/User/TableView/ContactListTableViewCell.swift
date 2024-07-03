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
        nameLbl.text = "\(userContact.firstName ?? "")\(userContact.lastName ?? "")"
        contactNumberLbl.text = userContact.contactNumber
        
    }
}
