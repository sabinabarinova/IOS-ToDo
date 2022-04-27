
import UIKit
import RealmSwift
import SwiftUI


class ViewController: UITableViewController {
    
    let realm = try! Realm()
    var toDo: Results<ToDo>{
        get {
            return realm.objects(ToDo.self)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func addTask(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New task",
                                      message: "Please input your task to do",
                                      preferredStyle: .alert)
        alert.addTextField {(UITextField) in
            
        }
        
        let cancelButton = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)
        let addButtonn = UIAlertAction(title: "Add",
                                       style: .default) { (UIAlertAction) -> Void in
            let taskText = (alert.textFields?.first) as! UITextField
            let newTask = ToDo()
            newTask.Description = taskText.text!
            newTask.isDone = false
            
            try! self.realm.write({
                self.realm.add(newTask)
                self.tableView.insertRows(at: [IndexPath.init(row: self.toDo.count - 1, section: 0)], with: .automatic)
            })
        }
        
        alert.addAction(cancelButton)
        alert.addAction(addButtonn)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return toDo.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = toDo[indexPath.row]
        cell.textLabel?.text = task.Description
        cell.accessoryType = task.isDone == true ? .checkmark: .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let task = toDo[indexPath.row]
        
        try! self.realm.write({
            task.isDone = !task.isDone
        })
        
        tableView.reloadRows(at: [indexPath], with: .automatic)

    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete) {
            let task = toDo[indexPath.row]
            
            try! self.realm.write({
                self.realm.delete(task)
            })
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}


