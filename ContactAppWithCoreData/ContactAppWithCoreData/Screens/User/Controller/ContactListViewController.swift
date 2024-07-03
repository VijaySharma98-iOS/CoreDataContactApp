//
//  ContactListViewController.swift
//  ContactAppWithCoreData
//
//  Created by Vijay Sharma on 03/07/24.
//

import UIKit

class ContactListViewController: UIViewController {
    
    private var userContact: [ContactEntity] = []
    private let dataBaseManager = DataBaseManager()
    private let contactCellIdentifier = "ContactCell"
    
    @IBOutlet weak var contactListTblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUserContacts()
    }
    @IBAction func addNewContactTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "saveNewContactSegue", sender: nil)
    }
    private func fetchUserContacts() {
        userContact = dataBaseManager.fetchUserContact()
        contactListTblView.reloadData()
    }
    private func setupTableView() {
        contactListTblView.register(UINib(nibName: "ContactListTableViewCell", bundle: nil), forCellReuseIdentifier: contactCellIdentifier)
        contactListTblView.delegate = self
        contactListTblView.dataSource = self
    }
}
extension ContactListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userContact.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let contactListCell = tableView.dequeueReusableCell(withIdentifier: contactCellIdentifier, for: indexPath) as? ContactListTableViewCell else {
            return UITableViewCell()
        }
        contactListCell.userContact = userContact[indexPath.row]
        
        return contactListCell
    }
}
