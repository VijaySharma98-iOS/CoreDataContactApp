//
//  ContactListViewController.swift
//  ContactAppWithCoreData
//
//  Created by Vijay Sharma on 03/07/24.
//

import UIKit

class ContactListViewController: UIViewController {
    
    private var userContact: [ContactEntity] = []
    private var filterUserContact: [ContactEntity] = []
    private let dataBaseManager = DataBaseManager()
    private let contactCellIdentifier = "ContactCell"
    private var isSearching: Bool = false
    
        
    @IBOutlet weak var contactListTblView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        navigationItem.title = "Contact List"
        searchBar.delegate = self
        
        
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
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        contactListTblView.reloadData()
        searchBar.resignFirstResponder()
    }
}
extension ContactListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filterUserContact.count : userContact.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let contactListCell = tableView.dequeueReusableCell(withIdentifier: contactCellIdentifier, for: indexPath) as? ContactListTableViewCell else {
            return UITableViewCell()
        }
        let contact = isSearching ? filterUserContact[indexPath.row] : userContact[indexPath.row]
        contactListCell.userContact = contact
        
        return contactListCell
    }
    
}
extension ContactListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            isSearching = false
            filterUserContact.removeAll()
            contactListTblView.reloadData()
            return
        }
        
        isSearching = true
        
        filterUserContact = userContact.filter({ contact in
            let fullName = "\(contact.firstName ?? "") \(contact.lastName ?? "")"
            
            return fullName.lowercased().contains(searchText.lowercased())
        })
        contactListTblView.reloadData()
    }
    
}
