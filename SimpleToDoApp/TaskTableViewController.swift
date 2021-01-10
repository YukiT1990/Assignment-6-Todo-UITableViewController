//
//  TaskTableViewController.swift
//  SimpleToDoApp
//
//  Created by Yuki Tsukada on 2021/01/09.
//

import UIKit

class TaskTableViewController: UITableViewController {
    
    var sectionTitles: [String] = ["High Priority", "Medium Priority", "Low Priority"]
    var underEditingMode: Bool = false
    var selectedRows: [IndexPath] = []
    
    
    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet var deleteButton: UIBarButtonItem!
    @IBOutlet var addButton: UIBarButtonItem!
    
    
    
    var tasks: [[Task]] = [
        // section 0
        [Task(title: "Update CV", todoDescription: "To append recent job", priorityNumber: 0, isCompleted: false),
         Task(title: "Search internship", todoDescription: "To look for internship opportunity", priorityNumber: 0, isCompleted: false),
         Task(title: "Water banana tree", todoDescription: "To water the banana tree", priorityNumber: 0, isCompleted: true),
         Task(title: "Pickup cake", todoDescription: "To pickup the birthdaycake for my mother", priorityNumber: 0, isCompleted: false)],
        // section 1
        [Task(title: "Study Chinese", todoDescription: "To study Chinese vocavularies", priorityNumber: 1, isCompleted: false),
         Task(title: "Study Swift", todoDescription: "To revise swift grammer", priorityNumber: 1, isCompleted: true)],
        // section 2
        [Task(title: "Practice piano", todoDescription: "Plactice playing the piano", priorityNumber: 2, isCompleted: true),
         Task(title: "Bird watching", todoDescription: "To watch birds coming to the garden", priorityNumber: 2, isCompleted: false)]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    
    @IBSegueAction func addTask(_ coder: NSCoder, sender: Any?) -> AddEditTaskTableViewController? {
        // for adding
        return AddEditTaskTableViewController(coder: coder, task: nil, selectedPriority: 0)
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Step 1: Dequeue cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskTableViewCell

        // Configure the cell...
        // Step 2: Fetch model object to display
        let task = tasks[indexPath.section][indexPath.row]
        
        // Step 3: Configure cell
        cell.update(with: task)
        cell.showsReorderControl = true
        
        // Step 4: Return cell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var task = tasks[indexPath.section][indexPath.row]
//        print("\(task.title) \(task.todoDescription) \(task.priorityNumber) \(task.isCompleted)")
        
        // change "isCompleted"
        // the display not updated yet
        
        // for fripping isCompleted state
        if underEditingMode == false {
            if task.isCompleted == true {
                task.isCompleted = false
                tasks[indexPath.section][indexPath.row] = task
            } else {
                task.isCompleted = true
                tasks[indexPath.section][indexPath.row] = task
            }
            print("\(task.title) \(task.todoDescription) \(task.priorityNumber) \(task.isCompleted)")
    //        tableView.reloadData()
            tableView.reloadRows(at: [indexPath], with: .none)
        } else {

            print(task)
            selectedRows.append([indexPath.section, indexPath.row])
            
        }
        
    }
    
    // for editing task
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath ) {
        let taskToEdit = tasks[indexPath.section][indexPath.row]
        print(taskToEdit)
//        let nextViewController = AddEditTaskTableViewController(coder: NSCoder, task: taskToEdit, selectedPriority: 0)
//        navigationController!.pushViewController(nextViewController!, animated: true)
        
    }
    
    
    
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        tableView.allowsMultipleSelection = true
        tableView.allowsMultipleSelectionDuringEditing = true
        let tableViewEditingMode = tableView.isEditing
        
        print("Editing mode is ")
        print(tableView.isEditing)
        
        tableView.setEditing(!tableViewEditingMode, animated: true)
        
        print("Editing mode is ")
        print(tableView.isEditing)
        underEditingMode = tableView.isEditing
    }
    
    
    @IBAction func deleteButtonTapped(_ sender: UIBarButtonItem) {
        print(selectedRows)
        let sortedSelectedRows = selectedRows.sorted { $0[1] > $1[1] }
        print(sortedSelectedRows)

        for indexPathList in sortedSelectedRows {
            tasks[indexPathList[0]].remove(at: indexPathList[1])
        }
        tableView.reloadData()
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        // .none .delete .insert
        return .none
    }

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

        let movedTask = tasks[fromIndexPath.section].remove(at: fromIndexPath.row)
        tasks[to.section].insert(movedTask, at: to.row)
    }
    
    
    // priority -> section
    @IBAction func unwindToEmojiTableView(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind",
              let sourceViewController = segue.source as? AddEditTaskTableViewController,
              let task = sourceViewController.task else { return }
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tasks[selectedIndexPath.section][selectedIndexPath.row] = task
            tableView.reloadRows(at: [selectedIndexPath], with: UITableView.RowAnimation.none)
        } else {
            // new
            let newIndexPath = IndexPath(row: tasks[task.priorityNumber].count, section: task.priorityNumber)
//            tasks.append(task)
            tasks[newIndexPath.section].append(task)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
