//
//  FriendModel.swift
//  Lab6_Tableview
//
//  Created by Adeesh on 2024-07-07.
//

import UIKit

class Friend {
    var name: String
    var email: String
    var phone: String
    var images: [UIImage]
    
    init(name: String, email: String, phone: String, images: [UIImage]) {
        self.name = name
        self.email = email
        self.phone = phone
        self.images = images
    }
}
