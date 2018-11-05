
import UIKit
import Firebase
import CoreLocation
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate {

    var db: DatabaseReference!
    var databseHandle: DatabaseHandle!
    
    var date: NSDate!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var searchedString : [Notes] = []
    var notesArray: [Notes] = []
    struct Notes {
        var id = ""
        var title = ""
        var detail = ""
        var date = ""
        var imageUrl = "" //for some test resons
        var location = ""
        //var imageUrl : String?
        var image : UIImage?
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateFromFirebase()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        if searchText.isEmpty {
            searchedString = notesArray
        } else {
            searchedString = notesArray.filter {$0.title.localizedCaseInsensitiveContains(searchText)}
        }
        self.tableView.reloadData()
    }
    
    func updateFromFirebase() {
        
          db = Database.database().reference()
          databseHandle = db.child("Posts").observe(.value, with: { (snapshot) in
            
            //Empting the list first
            self.notesArray.removeAll()
            self.searchedString.removeAll()
            for snap in snapshot.children {
            let snapshot = snap as! DataSnapshot
            var newNote = Notes()
            let value = snapshot.value as? NSDictionary
            newNote.title = value?["title"] as? String ?? ""
            newNote.detail = value?["detail"] as? String ?? ""
            newNote.imageUrl = value?["imageUrl"] as? String ?? ""
            newNote.location = value?["placename"] as? String ?? ""
            newNote.date = value?["time"] as? String ?? ""
            newNote.id = snapshot.key
            self.notesArray.append(newNote)
            self.searchedString.append(newNote)
            }
            self.tableView.reloadData()
         }) {(error) in
            print(error)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "notesCell", for: indexPath) as! notesTableViewCell
        
            let array = searchedString[indexPath.row]
            cell.cellTitle.text = array.title
            cell.cellDate.text = array.date
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedString.count
    }
    
    // Row selection in TableView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let detailPage = segue.destination as? DetailVC {
                if let index = sender as? Int {
                    detailPage.noteID = notesArray[index].id
                    print(index)
                }
            }
        }
        if segue.identifier == "addNewNote" {
            if let addnewForm = segue.destination as? AddFormController {
                if let index = sender as? Int {
                    addnewForm.noteID = notesArray[index].id
                    print(index)
                }
            }
        }
    }
}


extension ViewController {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    // Exiting from detailPage to HomePage
    @IBAction func exitFromCreatingNewNote (segue: UIStoryboardSegue) {
        
    }
}



//        ref = Database.database().reference()
//        databaseH = ref?.child("Posts").observe(.childAdded, with: { (snapshot) in
//            let value = snapshot.value! as? NSDictionary
//            let title = value?["title"] as? String ?? ""
//            self.list.append(title)
//
//            self.tableView.reloadData()
//        }) { (error) in
//            print(error)
//        }

