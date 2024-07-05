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
    
    func addUserContact(_ user: UserModel) {
        let contactEntity = ContactEntity(context: context) //Contact is the Entity name what we create
        updateContactEntity(contactEntity, with: user)
        
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
    //Date:: 05, Jul 2024 - delete the contact
    func updateUserContact(contact: UserModel, contactEntity: ContactEntity) {
        updateContactEntity(contactEntity, with: contact)
    }
    
    func deleteContact(contactEntity: ContactEntity) {
        
        deleteImage(named: contactEntity.imageName)
        context.delete(contactEntity)
        saveContext()
    }
    
    private func updateContactEntity(_ contactEntity: ContactEntity, with user: UserModel) {
        contactEntity.contactNumber = user.contact
        contactEntity.firstName = user.firstName
        contactEntity.lastName = user.lastName
        contactEntity.imageName = user.imageName
        saveContext()
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
    }
    private func deleteImage(named imageName: String?) {
        guard let imageName = imageName else { return }
        //let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = FileManager.default.getDocumentDirectoryFileURL(for: imageName, withExtension: "png")
        
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print("Error deleting image: \(error.localizedDescription)")
        }
    }
    //End
}
