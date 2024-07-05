//
//  Ext-FileManager.swift
//  ContactAppWithCoreData
//
//  Created by Vijay Sharma on 05/07/24.
//

import Foundation


extension FileManager {
    func getDocumentDirectoryFileURL(for imageName: String, withExtension fileExtension: String = "png") -> URL {
        let documentsDirectory = self.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsDirectory.appendingPathComponent(imageName).appendingPathExtension(fileExtension)
    }
}
