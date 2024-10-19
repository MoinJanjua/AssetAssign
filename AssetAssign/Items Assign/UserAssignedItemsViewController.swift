//
//  UserAssignedItemsViewController.swift
//  AssetAssign
//
//  Created by Moin Janjua on 19/08/2024.
//

import UIKit

class UserAssignedItemsViewController: UIViewController, UITextFieldDelegate {

    
    
    @IBOutlet weak var TittleLabel: UILabel!
    @IBOutlet weak var ItemsTf: DropDown!
    @IBOutlet weak var TaskTF: UITextField!
    @IBOutlet weak var EndDateTF: UITextField!
    @IBOutlet weak var StartDateTF: UITextField!
    
    @IBOutlet weak var hideView: UIView!
    
    var tittleName = String()
    var userId = String()
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the date picker
              datePicker.datePickerMode = .date
              datePicker.preferredDatePickerStyle = .wheels
              datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
              
              // Set up the toolbar
              let toolbar = UIToolbar()
              toolbar.sizeToFit()
              let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
              toolbar.setItems([doneButton], animated: true)
              
              // Assign the toolbar and date picker to the text field
        StartDateTF.inputAccessoryView = toolbar
        StartDateTF.inputView = datePicker
              // Set the current date in the text field
              setDateToTextField()
        
        // items assign Dropdown
        ItemsTf.optionArray = ["Laptop", "Mouse", "Keyboard", "Monitor", "Mac mini", "Headphone", "Table", "Chair", "Printer", "Webcam", "Speakers", "Desk Lamp", "External Hard Drive", "Docking Station", "USB Hub", "Footrest", "Desk Organizer", "Smartphone", "Tablet"]

        ItemsTf.didSelect { (selectedText, index, id) in
               self.ItemsTf.text = selectedText
           }
        ItemsTf.delegate = self
        
        setupDatePicker(for: EndDateTF, target: self, doneAction: #selector(donePressed))
        TittleLabel.text = tittleName
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
                tapGesture.cancelsTouchesInView = false
                view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard()
      {
          view.endEditing(true)
      }
    @objc func donePressed() {
           // Get the date from the picker and set it to the text field
           if let datePicker = EndDateTF.inputView as? UIDatePicker {
               let dateFormatter = DateFormatter()
               dateFormatter.dateStyle = .medium
               dateFormatter.timeStyle = .none
               EndDateTF.text = dateFormatter.string(from: datePicker.date)
           }
           // Dismiss the keyboard
        EndDateTF.resignFirstResponder()
       }
    @objc func dateChanged() {
            setDateToTextField()
        }
        @objc func doneTapped() {
            // Dismiss the date picker
            view.endEditing(true)
        }
        func setDateToTextField() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            StartDateTF.text = dateFormatter.string(from: datePicker.date)
        }
    func clearTextFields() {
        ItemsTf.text = ""
        TaskTF.text = ""
        EndDateTF.text = ""
        }
    func saveEmployeeAssetsAssignData(_ sender: Any) {
        // Check if any of the text fields are empty
        guard
              let item = ItemsTf.text, !item.isEmpty,
              let tasks = TaskTF.text,
              let startDate = StartDateTF.text,
              let enddate = EndDateTF.text
        else {
            showAlert(title: "Error", message: "Please fill the field.")
            return
        }
        let assignThingsDetail = AssignItems(
            employeeID: userId,
            items: item,
            tasks: tasks,
            startDate: startDate,
            endtDate: enddate
        )
        saveEmployeeDetail(assignThingsDetail)
    }
    func convertStringToDate(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY" // Adjust according to your string date format
        return dateFormatter.date(from: dateString)
    }
    func saveEmployeeDetail(_ assignitem: AssignItems) {
        var emp_Assignitem = UserDefaults.standard.object(forKey: "emp_Assignitem") as? [Data] ?? []
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(assignitem)
            emp_Assignitem.append(data)
            UserDefaults.standard.set(emp_Assignitem, forKey: "emp_Assignitem")
            clearTextFields()
           
        } catch {
            print("Error encoding medication: \(error.localizedDescription)")
        }
        showAlert(title: "Done", message: "Details has been Saved successfully.")
    }
 
    @IBAction func SaveItemsdata(_ sender: Any) {
        
        saveEmployeeAssetsAssignData(sender)
    }
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
