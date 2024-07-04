//
//  DataBaseManger.swift
//  ContactAppWithCoreData
//
//  Created by Vijay Sharma on 03/07/24.
//

import UIKit
import CoreData

class DataBaseManager {
    
    private var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func addUser(_ user: UserModel) {
        let contactEntity = ContactEntity(context: context) //Contact is the Entity name what we create
        contactEntity.contactNumber = user.contact
        contactEntity.firstName = user.firstName
        contactEntity.lastName = user.lastName
        
        do {
            try context.save()
        } catch {
            print("Error saving user: \(error.localizedDescription)")
        }
    }
    func fetchUserContact() -> [ContactEntity] {
        //var userContact: [ContactEntity] = []
        let fetchRequest: NSFetchRequest<ContactEntity> = ContactEntity.fetchRequest()
        
        do {
            let userContacts = try context.fetch(fetchRequest)
            return userContacts
        } catch {
            print("Error fetching user contacts: \(error.localizedDescription)")
            return []
        }
    }
    
}
