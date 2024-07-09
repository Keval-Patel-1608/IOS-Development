//
//  UserDefault.swift
//  Midterm
//
//  Created by Admin on 2024-06-28.
//

import Foundation
import UIKit


class CustomGlobal {
    
    static let shared = CustomGlobal()

    private init(){}
    
    // Convert UIImage to base64-encoded string
    func convertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    
    // Convert base64-encoded string to UIImage
    func convertBase64StringToImage (imageBase64String:String) -> UIImage {
        let imageData = Data(base64Encoded: imageBase64String)
        let image = UIImage(data: imageData!)
        return image!
    }
    
    // Store array of Task objects in UserDefaults
    func storingItemsInPreferences(arrayValue: [Task]) {
        if let encodedData = try? JSONEncoder().encode(arrayValue) {
            UserDefaults.standard.set(encodedData, forKey: "StudentTask")
            UserDefaults.standard.synchronize()
        }
    }
    
    // Retrieve array of Task objects from UserDefaults
    func retriveItemsFromPreference() -> [Task]? {
        if let savedData = UserDefaults.standard.data(forKey: "StudentTask"),
           let decodedItems = try? JSONDecoder().decode([Task].self, from: savedData) {
            return decodedItems
        }
        return nil
    }
}
