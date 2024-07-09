import UIKit

class CarVC: UIViewController {
    
    @IBOutlet weak var tblCars: UITableView!
    
    var arrCars = [Car]()
    
    private var editSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureStaticDataSource()
        configureTableview()
    }
    
    private func configureNavigation() {
        title = "Cars Catalogue"
        
        editSwitch = UISwitch()
        editSwitch.addTarget(self, action: #selector(toggleEditMode(_:)), for: .valueChanged)
        
        let switchItem = UIBarButtonItem(customView: editSwitch)
        navigationItem.leftBarButtonItem = switchItem
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCar))
    }
    
    private func configureStaticDataSource() {
        arrCars.append(Car(image: UIImage(named: "car"), make: "Porche", model: "911"))
        arrCars.append(Car(image: UIImage(named: "car"), make: "Audi", model: "R8"))
        arrCars.append(Car(image: UIImage(named: "car"), make: "Ram", model: "CVx"))
        arrCars.append(Car(image: UIImage(named: "car"), make: "BMW", model: "Q6"))
        arrCars.append(Car(image: UIImage(named: "car"), make: "Ford", model: "Mustang"))
        arrCars.append(Car(image: UIImage(named: "car"), make: "Mazda", model: "X60"))
    }
    
    private func configureTableview() {
        tblCars.delegate = self
        tblCars.dataSource = self
        tblCars.register(UINib(nibName: "CarTBL", bundle: nil), forCellReuseIdentifier: "CarTBL")
    }
    
    @objc private func addCar() {
        let alert = UIAlertController(title: "New Car", message: "Enter car details", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Car Make"
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Car Model"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            guard let carMake = alert.textFields?.first?.text,
                  let carModel = alert.textFields?.last?.text else {
                return
            }
            
            self.arrCars.append(Car(image: UIImage(named: "car"), make: carMake, model: carModel))
            self.tblCars.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func toggleEditMode(_ sender: UISwitch) {
        tblCars.isEditing = sender.isOn
    }
    
}

extension CarVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CarTBL", for: indexPath) as? CarTBL else {
            return UITableViewCell()
        }
        
        cell.configureCell(value: arrCars[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            arrCars.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedCar = arrCars.remove(at: sourceIndexPath.row)
        arrCars.insert(movedCar, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
