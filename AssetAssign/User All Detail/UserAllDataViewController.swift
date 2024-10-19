//
//  UserAllDataViewController.swift
//  AssetAssign
//
//  Created by Moin Janjua on 20/08/2024.
//

import UIKit

class UserAllDataViewController: UIViewController {
    
    @IBOutlet weak var userPicture: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userDesignation: UILabel!
    @IBOutlet weak var userContact: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var userEducation: UILabel!
    @IBOutlet weak var TableView: UITableView!
    
    var selectedEmpDetail: eDetails?
    var selectedEmpAssignedThings: AssignItems?
    var tasks = [String]()
    var userID = String()
    var assignedItems: [AssignItems] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableView.delegate = self
        TableView.dataSource = self
   
        if let empDetail = selectedEmpDetail {
            userPicture.image = empDetail.pic
            userName.text = empDetail.name
            userDesignation.text = empDetail.Designation
            userEmail.text = empDetail.email
            userContact.text = empDetail.contact
            genderLbl.text = empDetail.gender
            userEducation.text = empDetail.education
        }
        makeImageViewCircular(imageView: userPicture)
     
    }
    override func viewWillAppear(_ animated: Bool) {
        loadAssignedItems(for: userID)
        TableView.reloadData()
    }
    func makeImageViewCircular(imageView: UIImageView) {
           // Ensure the UIImageView is square
           imageView.layer.cornerRadius = imageView.frame.size.width / 2
           imageView.clipsToBounds = true
       }
    func convertDateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Adjust to the desired format
        return dateFormatter.string(from: date)
    }
    
    func loadAssignedItems(for userID: String) {
        if let savedItemsData = UserDefaults.standard.array(forKey: "emp_Assignitem") as? [Data] {
            let decoder = JSONDecoder()
            assignedItems = savedItemsData.compactMap { data in
                do {
                    let assignItem = try decoder.decode(AssignItems.self, from: data)
                    // Filter by employeeID
                    if userID == assignItem.employeeID {
                        print("Loaded Assigned Item: \(assignItem)") // Debugging print
                        return assignItem
                    } else {
                        return nil
                    }
                } catch {
                    print("Error decoding assigned items: \(error.localizedDescription)")
                    return nil
                }
            }
            TableView.reloadData()
        } else {
            print("No saved items found in UserDefaults")
        }
    }
    func calculateRemainingDays(from startDateString: String, to endDateString: String) -> Int? {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "dd-MMM-yyyy" // Format of your stored date strings

         guard let startDate = dateFormatter.date(from: startDateString),
               let endDate = dateFormatter.date(from: endDateString) else {
             return nil
         }

         let remainingDays = Calendar.current.dateComponents([.day], from: Date(), to: endDate).day
         return remainingDays
     }

    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
extension UserAllDataViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignedItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AssignCell", for: indexPath) as! TableViewCell
            let assignedItem = assignedItems[indexPath.row]

            // Calculate remaining days
            if let remainingDays = calculateRemainingDays(from: assignedItem.startDate, to: assignedItem.endtDate) {
                cell.remainDayLabel.text = "\(remainingDays) days remaining"
            } else {
                cell.remainDayLabel.text = "Invalid dates"
            }
          cell.taskLabel?.text = assignedItem.tasks
        cell.itemLabe?.text = assignedItem.items
        cell.endDateLabel?.text = "End Date: \(assignedItem.endtDate)"
            return cell
        }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            assignedItems.remove(at: indexPath.row)
            
            let encoder = JSONEncoder()
            do {
                let encodedData = try assignedItems.map { try encoder.encode($0) }
                UserDefaults.standard.set(encodedData, forKey: "emp_Assignitem")
            } catch {
                print("Error encoding medications: \(error.localizedDescription)")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
}
