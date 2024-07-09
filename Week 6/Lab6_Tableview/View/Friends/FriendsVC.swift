//
//  FriendsVC.swift
//  Lab6_Tableview
//
//  Created by Adeesh on 2024-07-07.
//

import UIKit

class FriendsVC: UIViewController {

    @IBOutlet weak var tblFriends: UITableView!
    var arrFriends = [Friend]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureNavigation()
        self.configureStaticDataSource()
        self.configureTableview()
    }
    
    private func configureNavigation() {
        self.title = "Friends List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFriends))
                
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditMode))
    }
    
    private func configureStaticDataSource() {
        self.arrFriends.append(Friend(name: "Amanda", email: "Amanda@gmail.com", phone: "2229876789", images: [UIImage(named: "user1") ?? UIImage(), UIImage(named: "user2") ?? UIImage(), UIImage(named: "user3") ?? UIImage()]))
        
        self.arrFriends.append(Friend(name: "Kevin", email: "kevin@gmail.com", phone: "2229876526", images: [UIImage(named: "user4") ?? UIImage(), UIImage(named: "user5") ?? UIImage(), UIImage(named: "user6") ?? UIImage()]))
        
        self.arrFriends.append(Friend(name: "John", email: "john@gmail.com", phone: "2229871234", images: [UIImage(named: "user1") ?? UIImage(), UIImage(named: "user5") ?? UIImage(), UIImage(named: "user3") ?? UIImage()]))
        
        self.arrFriends.append(Friend(name: "Lila", email: "lia@gmail.com", phone: "2229879876", images: [UIImage(named: "user1") ?? UIImage(), UIImage(named: "user5") ?? UIImage(), UIImage(named: "user3") ?? UIImage()]))
        
        self.arrFriends.append(Friend(name: "David", email: "david@gmail.com", phone: "2229874592", images: [UIImage(named: "user3") ?? UIImage(), UIImage(named: "user4") ?? UIImage(), UIImage(named: "user2") ?? UIImage()]))
        
        self.arrFriends.append(Friend(name: "Michel", email: "michel@gmail.com", phone: "2229874592", images: [UIImage(named: "user2") ?? UIImage(), UIImage(named: "user6") ?? UIImage(), UIImage(named: "user1") ?? UIImage()]))
        
        self.arrFriends.append(Friend(name: "Kate", email: "kate@gmail.com", phone: "2229872635", images: [UIImage(named: "user1") ?? UIImage(), UIImage(named: "user4") ?? UIImage(), UIImage(named: "user3") ?? UIImage()]))
        
        self.arrFriends.append(Friend(name: "Peter", email: "Peter@gmail.com", phone: "2229872094", images: [UIImage(named: "user5") ?? UIImage(), UIImage(named: "user6") ?? UIImage(), UIImage(named: "user2") ?? UIImage()]))
        
    }
    
    private func configureTableview() {
        self.tblFriends.delegate = self
        self.tblFriends.dataSource = self
        self.tblFriends.register(UINib(nibName: FriendsTBLCell.identifier, bundle: nil), forCellReuseIdentifier: FriendsTBLCell.identifier)
    }

    @objc func addFriends() {
        let alert = UIAlertController(title: "New Friend", message: "Enter friend details", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Name"
        }
        alert.addTextField { textField in
            textField.placeholder = "Email"
            textField.keyboardType = .emailAddress
        }
        alert.addTextField { textField in
            textField.placeholder = "Phone"
            textField.keyboardType = .numberPad
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let firstName = alert.textFields?[0].text,
               let email = alert.textFields?[1].text,
               let phone = alert.textFields?[2].text,
               !firstName.isEmpty, !email.isEmpty, !phone.isEmpty {
                if self.isValidEmail(email: email) {
                    if self.isValidPhone(phone: phone) {
                        let newFriend = Friend(name: firstName, email: email, phone: phone, images: [UIImage(named: "user1")!, UIImage(named: "user2")!, UIImage(named: "user3")!])
                        self.arrFriends.append(newFriend)
                        self.tblFriends.reloadData()
                        self.showSimpleAlert(title: "Friend details added successfully... ")
                    } else {
                        self.showSimpleAlert(title: "Please enter valid phone number") {
                            self.addFriends()
                        }
                    }
                } else {
                    self.showSimpleAlert(title: "Please enter valid email") {
                        self.addFriends()
                    }
                }
            } else {
                self.showSimpleAlert(title: "Please enter all details") {
                    self.addFriends()
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func toggleEditMode() {
        self.tblFriends.isEditing = !self.tblFriends.isEditing
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPhone(phone: String) -> Bool {
        let phoneRegEx = "[0-9]{0,10}"

        let phonePred = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return phonePred.evaluate(with: phone)
    }
}

extension FriendsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendsTBLCell.identifier, for: indexPath) as? FriendsTBLCell else { return UITableViewCell() }
        cell.configureCell(value: self.arrFriends[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.arrFriends.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedCar = self.arrFriends.remove(at: sourceIndexPath.row)
        self.arrFriends.insert(movedCar, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
    
}
