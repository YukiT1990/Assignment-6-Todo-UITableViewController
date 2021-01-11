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
    var selectedRowsForEdit: IndexPath = [-1, -1]
    
    
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
        [Task(title: "Study Chinese", todoDescription: "To study Chinese vocabularies", priorityNumber: 1, isCompleted: false),
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
    
    // add and edit task
    @IBSegueAction func addTask(_ coder: NSCoder, sender: Any?) -> AddEditTaskTableViewController? {
        selectedRowsForEdit = [-1, -1]
        if let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            // for editing
            selectedRowsForEdit = indexPath
            let taskToEdit = tasks[indexPath.section][indexPath.row]
            return AddEditTaskTableViewController(coder: coder, task: taskToEdit, selectedPriority: indexPath.section)
        } else {
            // for adding
            return AddEditTaskTableViewController(coder: coder, task: nil, selectedPriority: 0)
        }
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
        // for checking task contents
//        print("\(task.title) \(task.todoDescription) \(task.priorityNumber) \(task.isCompleted)")
        
        // for fripping isCompleted state
        if underEditingMode == false {
            if task.isCompleted == true {
                task.isCompleted = false
                tasks[indexPath.section][indexPath.row] = task
            } else {
                task.isCompleted = true
                tasks[indexPath.section][indexPath.row] = task
            }
            tableView.reloadRows(at: [indexPath], with: .none)
        // for multiple delete
        } else {
            // for checking selected task
//            print(task)
            selectedRows.append([indexPath.section, indexPath.row])
        }
    }
    
    // to avoid deselected rows to be deleted
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // for checking selectedRows
//        print(selectedRows)
        while let idx = selectedRows.firstIndex(of: [indexPath.section, indexPath.row]) {
            selectedRows.remove(at: idx)
        }
        // for checking selectedRows
//        print(selectedRows)
    }
    
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        tableView.allowsMultipleSelection = true
        tableView.allowsMultipleSelectionDuringEditing = true
        let tableViewEditingMode = tableView.isEditing
        
        // check editing mode state
//        print("Editing mode is ")
//        print(tableView.isEditing)
        
        tableView.setEditing(!tableViewEditingMode, animated: true)
        
        // check editing mode state
//        print("Editing mode is ")
//        print(tableView.isEditing)
        underEditingMode = tableView.isEditing
    }
    
    
    @IBAction func deleteButtonTapped(_ sender: UIBarButtonItem) {
        // for checking selectedRows contents
//        print(selectedRows)
        let sortedSelectedRows = selectedRows.sorted { $0[1] > $1[1] }
        // for checking sortedSelectedRows contents
//        print(sortedSelectedRows)

        for indexPathList in sortedSelectedRows {
            tasks[indexPathList[0]].remove(at: indexPathList[1])
        }
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        // .none .delete .insert
        return .none
    }

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        tableView.allowsMultipleSelection = false
        tableView.allowsMultipleSelectionDuringEditing = false
        
        let movedTask = tasks[fromIndexPath.section].remove(at: fromIndexPath.row)
        tasks[to.section].insert(movedTask, at: to.row)
    }
    
    
    // update editted or new task
    @IBAction func unwindToEmojiTableView(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind",
              let sourceViewController = segue.source as? AddEditTaskTableViewController,
              let task = sourceViewController.task else { return }
        var temporaryPath: IndexPath?
        if selectedRowsForEdit != [-1, -1] {
            temporaryPath = selectedRowsForEdit
        }
        if let selectedIndexPath = temporaryPath {
            // for checking selectedIndexPath
//            print(selectedIndexPath)
            tasks[selectedIndexPath.section][selectedIndexPath.row] = task
            tableView.reloadRows(at: [selectedIndexPath], with: UITableView.RowAnimation.none)
        } else {
            // new
            let newIndexPath = IndexPath(row: tasks[task.priorityNumber].count, section: task.priorityNumber)
            tasks[newIndexPath.section].append(task)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }

}
