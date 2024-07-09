import UIKit

class CarVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tblCars: UITableView! // Table view to display cars
    
    // MARK: - Properties
    
    var arrCars = [Car]() // Array to store Car objects
    
    private var editSwitch: UISwitch! // Switch for toggling edit mode
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure navigation items
        configureNavigation()
        
        // Configure initial data source (static data)
        configureStaticDataSource()
        
        // Configure table view
        configureTableview()
    }
    
    // MARK: - UI Setup
    
    private func configureNavigation() {
        // Set title for navigation bar
        title = "Cars Catalogue"
        
        // Create edit mode switch
        editSwitch = UISwitch()
        editSwitch.addTarget(self, action: #selector(toggleEditMode(_:)), for: .valueChanged)
        
        // Add switch to left bar button item
        let switchItem = UIBarButtonItem(customView: editSwitch)
        navigationItem.leftBarButtonItem = switchItem
        
        // Add "Add" button to right bar button item
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCar))
    }
    
    // MARK: - Data Initialization
    
    private func configureStaticDataSource() {
        // Initialize static data for cars
        arrCars.append(Car(image: UIImage(named: "car"), make: "Porche", model: "911"))
        arrCars.append(Car(image: UIImage(named: "car"), make: "Audi", model: "R8"))
        arrCars.append(Car(image: UIImage(named: "car"), make: "Ram", model: "CVx"))
        arrCars.append(Car(image: UIImage(named: "car"), make: "BMW", model: "Q6"))
        arrCars.append(Car(image: UIImage(named: "car"), make: "Ford", model: "Mustang"))
        arrCars.append(Car(image: UIImage(named: "car"), make: "Mazda", model: "X60"))
        arrCars.append(Car(image: UIImage(named: "car"), make: "Ferrari", model: "RV"))
        arrCars.append(Car(image: UIImage(named: "car"), make: "Tesla", model: "D9"))
    }
    
    // MARK: - Table View Setup
    
    private func configureTableview() {
        // Set delegate and data source for table view
        tblCars.delegate = self
        tblCars.dataSource = self
        
        // Register custom table view cell
        tblCars.register(UINib(nibName: "CarTBL", bundle: nil), forCellReuseIdentifier: "CarTBL")
    }
    
    // MARK: - Actions
    
    @objc private func addCar() {
        // Show alert to add a new car
        let alert = UIAlertController(title: "New Car", message: "Enter car details", preferredStyle: .alert)
        
        // Text fields for car make and model
        alert.addTextField { textField in
            textField.placeholder = "Car Make"
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Car Model"
        }
        
        // Action to add new car to the array and reload table view
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            guard let carMake = alert.textFields?.first?.text,
                  let carModel = alert.textFields?.last?.text else {
                return
            }
            
            self.arrCars.append(Car(image: UIImage(named: "car"), make: carMake, model: carModel))
            self.tblCars.reloadData()
        }
        
        // Cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Add actions to alert controller
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        // Present alert controller
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func toggleEditMode(_ sender: UISwitch) {
        // Toggle edit mode for table view
        tblCars.isEditing = sender.isOn
    }
    
}

// MARK: - Table View Delegate and Data Source

extension CarVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return number of cars in the array
        return arrCars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue reusable cell and configure it with Car object
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CarTBL", for: indexPath) as? CarTBL else {
            return UITableViewCell()
        }
        
        cell.configureCell(value: arrCars[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Handle deletion of a car
        if editingStyle == .delete {
            arrCars.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Handle reordering of cars
        let movedCar = arrCars.remove(at: sourceIndexPath.row)
        arrCars.insert(movedCar, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Set height for table view rows
        return 100
    }
    
}
