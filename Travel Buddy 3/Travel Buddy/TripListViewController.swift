import UIKit
import CoreData

class TripListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tripsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var trips: [Trip] = []
    var filteredTrips: [Trip] = []
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tripsTableView.delegate = self
        tripsTableView.dataSource = self
        searchBar.delegate = self
        
        // Register the custom cell NIB
//        let nib = UINib(nibName: "TripTableViewCell", bundle: nil)
//        tripsTableView.register(nib, forCellReuseIdentifier: "tripCell")
        
        fetchTrips()
    }
    
    func fetchTrips() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Trip> = Trip.fetchRequest()
        
        do {
            trips = try context.fetch(fetchRequest)
            filteredTrips = trips
            tripsTableView.reloadData()
        } catch {
            print("Error fetching trips: \(error)")
        }
    }
    
    // MARK: - TableView DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredTrips.count : trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath)
        
        let trip = isSearching ? filteredTrips[indexPath.row] : trips[indexPath.row]
        cell.textLabel?.text = trip.name
        cell.detailTextLabel?.text = trip.destination
        
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        performSegue(withIdentifier: "TripDetail", sender: indexPath)
            let selectedTrip = isSearching ? filteredTrips[indexPath.row] : trips[indexPath.row]
            redirectToTripDetail(tripValue: selectedTrip)
        }
    
    // MARK: - Deleting a Trip
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let tripToDelete = isSearching ? filteredTrips[indexPath.row] : trips[indexPath.row]
            confirmDeletion(for: tripToDelete, at: indexPath)
        }
    }
    
    func confirmDeletion(for trip: Trip, at indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete Trip", message: "Are you sure you want to delete this trip?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.deleteTrip(trip, at: indexPath)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func deleteTrip(_ trip: Trip, at indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(trip)
        
        do {
            try context.save()
            trips.removeAll { $0 == trip }
            filteredTrips.removeAll { $0 == trip }
            tripsTableView.deleteRows(at: [indexPath], with: .fade)
        } catch {
            print("Error deleting trip: \(error)")
        }
    }
    
    // MARK: - Search Bar Delegate Methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredTrips = trips
        } else {
            isSearching = true
            filteredTrips = trips.filter { $0.name?.lowercased().contains(searchText.lowercased()) == true }
        }
        tripsTableView.reloadData()
    }
    
    // MARK: - Navigation
    func redirectToTripDetail(tripValue: Trip) {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "TripDetailViewController") as! TripDetailViewController
            viewController.trip = tripValue
            self.navigationController?.pushViewController(viewController, animated: true)
        }
}
