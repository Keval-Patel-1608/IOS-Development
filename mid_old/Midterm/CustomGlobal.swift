//
//  UserDefault.swift
//  Midterm
//
//  Created by Adeesh on 2024-06-28.
//

import Foundation
import UIKit


class CustomGlobal {
    
    static let shared = CustomGlobal()

    private init(){}
    
    func convertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    
    func convertBase64StringToImage (imageBase64String:String) -> UIImage {
        let imageData = Data(base64Encoded: imageBase64String)
        let image = UIImage(data: imageData!)
        return image!
    }
    
    func storingItemsInPreferences(arrayValue: [Task]) {
        if let encodedData = try? JSONEncoder().encode(arrayValue) {
            UserDefaults.standard.set(encodedData, forKey: "StudentTask")
            UserDefaults.standard.synchronize()
        }
    }
    
    func retriveItemsFromPreference() -> [Task]? {
        if let savedData = UserDefaults.standard.data(forKey: "StudentTask"),
           let decodedItems = try? JSONDecoder().decode([Task].self, from: savedData) {
            return decodedItems
        }
        return nil
    }
}
