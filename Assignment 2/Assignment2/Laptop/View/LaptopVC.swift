//
//  LaptopVC.swift
//  Assignment2
//
//  Created by Keval on 2024-06-21.
//

import UIKit

class LaptopVC: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tblLaptop: UITableView!
    
    //MARK: - Variable
    var arrLaptopList = [LaptopModel]() {
        didSet {
            self.tblLaptop.reloadData()
        }
    }
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigation()
        self.configureTableView()
    }
    
    private func configureNavigation() {
        self.title = "Laptop"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Futura-Medium", size: 15)!, NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Futura-Medium", size: 20)!, NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)]
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.sizeToFit()
        
        let plusImage = UIImage(named: "plus")?.withRenderingMode(.alwaysOriginal)
        navigationController?.navigationBar.backIndicatorImage = plusImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = plusImage
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: plusImage, style: .plain, target: self, action: #selector(addItemsClicked))
        
        let backImage = UIImage(named: "back-button")?.withRenderingMode(.alwaysOriginal)
        navigationController?.navigationBar.backIndicatorImage = backImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(back))

    }
    
    private func configureTableView() {
        self.tblLaptop.delegate = self
        self.tblLaptop.dataSource = self
        self.tblLaptop.contentInsetAdjustmentBehavior = .never
        self.arrLaptopList.append(LaptopModel(title: "HP", details: "2.1Ghz", price: 1599.99, isStatic: false))
        self.arrLaptopList.append(LaptopModel(title: "Lenovo", details: "1.8Ghz", price: 1259.99, isStatic: false))
        self.arrLaptopList.append(LaptopModel(title: "Acer", details: "2.7Ghz", price: 2099.99, isStatic: false))
    }
    
    
    func showAlert() {
        self.showAlertWithInputDialog(title: "Add New Item", subtitle: "", actionTitle: "Ok", cancelTitle: "Cancel") { cancel in
        } actionHandler: { objLaptop, success in
            if success {
                if let objLaptop = objLaptop {
                    self.arrLaptopList.append(objLaptop)
                    self.addIBMLaptopIfNecessary()
                }
            } else {
                self.showSimpleAlert(title: "Please enter all the details!", actionTitle: "Close", alertStyle: .actionSheet) {
                    self.showAlert()
                }
            }
        }
    }
    
    func addIBMLaptopIfNecessary() {
        let studentNumber = "9009797"
        let fifthDigitIndex = studentNumber.index(studentNumber.startIndex, offsetBy: 4)
        guard let fifthDigit = Int(String(studentNumber[fifthDigitIndex])) else {
            return
        }
        
        let index = self.arrLaptopList.firstIndex(where: { $0.isStatic == true})
        if index == nil {
            if fifthDigit-1 < self.arrLaptopList.count {
                self.arrLaptopList.insert(LaptopModel(title: "IBM Tablet (#9009797)", details: "", price: 999.99, isStatic: true), at: fifthDigit-1)
            }
        }
    }
}

//MARK: - Button Action
extension LaptopVC {
    
    @objc func back() {
        self.navigationController?.popViewController(animated:true)
    }
    
    @objc func addItemsClicked() {
        self.showAlert()
    }
}

extension LaptopVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.tblLaptop{
            if self.tblLaptop.contentOffset.y > 3.0 {
                self.navigationController?.navigationBar.prefersLargeTitles = false
            }
            
            if self.tblLaptop.contentOffset.y == 0.0 {
                self.navigationController?.navigationBar.prefersLargeTitles = true
                self.navigationItem.largeTitleDisplayMode = .automatic
                self.navigationController?.navigationBar.sizeToFit()
            }
        }
    }
}

//MARK: - Table View Delegate and DataSource
extension LaptopVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.arrLaptopList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.arrLaptopList[indexPath.row].isStatic == true {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "staticCell", for: indexPath) as? StaticCell else { return UITableViewCell()}
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "laptopCell", for: indexPath) as? LaptopCell else { return UITableViewCell()}
            
            cell.confgiureCell(object: self.arrLaptopList[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.arrLaptopList[indexPath.row].isStatic == true {
            return 70
        } else {
            return 100
        }
    }
}

