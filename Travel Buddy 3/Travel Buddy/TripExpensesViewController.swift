//
//  TripExpensesViewController.swift
//  Travel Buddy
//
//  Created by Admin on 2024-08-17.
//
import UIKit
import CoreData

class TripExpensesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var expenseNameTextField: UITextField!
    @IBOutlet weak var expenseAmountTextField: UITextField!
    @IBOutlet weak var addExpenseButton: UIButton!
    @IBOutlet weak var expensesTableView: UITableView!
    @IBOutlet weak var totalExpensesLabel: UILabel!
    
    var selectedTrip: Trip? // This should be set before navigating to this view
    var expenses: [Expense] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        expensesTableView.delegate = self
        expensesTableView.dataSource = self
        fetchExpenses()
    }
    
    @IBAction func addExpenseButtonPressed(_ sender: UIButton) {
        saveExpense()
    }
    
    func saveExpense() {
        guard let expenseName = expenseNameTextField.text, !expenseName.isEmpty,
              let expenseAmountText = expenseAmountTextField.text, let expenseAmount = Double(expenseAmountText),
              let trip = selectedTrip else {
            showAlert(message: "Please fill in all fields.")
            return
        }
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newExpense = Expense(context: context)
        newExpense.name = expenseName
        newExpense.amount = expenseAmount
        newExpense.trip = trip
        
        do {
            try context.save()
            fetchExpenses()
            updateTotalExpenses()
        } catch {
            print("Error saving expense: \(error)")
        }
    }
    
    func fetchExpenses() {
        guard let trip = selectedTrip else { return }
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "trip == %@", trip)
        
        do {
            expenses = try context.fetch(fetchRequest)
            expensesTableView.reloadData()
        } catch {
            print("Error fetching expenses: \(error)")
        }
    }
    
    func updateTotalExpenses() {
        let total = expenses.reduce(0) { $0 + $1.amount }
        totalExpensesLabel.text = "Total: \(total)"
    }
    
    // MARK: - TableView DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expenseCell", for: indexPath)
        let expense = expenses[indexPath.row]
        cell.textLabel?.text = expense.name
        cell.detailTextLabel?.text = "\(expense.amount)"
        return cell
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
