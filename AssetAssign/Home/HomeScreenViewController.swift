//
//  HomeScreenViewController.swift
//  AssetAssign
//
//  Created by Moin Janjua on 19/08/2024.
//

import UIKit

class HomeScreenViewController: UIViewController {

    @IBOutlet weak var SideMenu: UIView!
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var TimeLbl: UILabel!
    @IBOutlet weak var sideMenuTB: UITableView!
    @IBOutlet weak var vesion_Label: UILabel!
    
    var emp_Detail: [eDetails] = []
    var sideMenuList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableView.delegate = self
        TableView.dataSource = self
        
        sideMenuList = ["Home","Share Your Thoughts","Who We Are","Privacy Notice","Share App"]
        sideMenuTB.delegate = self
        sideMenuTB.dataSource = self
        SideMenu.isHidden = true
        
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? "N/A"
       let build = Bundle.main.infoDictionary?["CFBundleVersion"] ?? "N/A"
        vesion_Label.text = "Version \(version) (\(build))"
        
        setGreetingMessage()
    }
    override func viewWillAppear(_ animated: Bool) {
        // Load data from UserDefaults
        // Retrieve stored medication records from UserDefaults
        if let savedData = UserDefaults.standard.array(forKey: "employees") as? [Data] {
            let decoder = JSONDecoder()
            emp_Detail = savedData.compactMap { data in
                do {
                    let medication = try decoder.decode(eDetails.self, from: data)
                    return medication
                } catch {
                    print("Error decoding medication: \(error.localizedDescription)")
                    return nil
                }
            }
        }
        TableView.reloadData()
    }
    private func setGreetingMessage() {
           let hour = Calendar.current.component(.hour, from: Date())
           var greeting: String
           
           switch hour {
           case 5..<12:
               greeting = "Good Morning"
           case 12..<17:
               greeting = "Good Afternoon"
           case 17..<21:
               greeting = "Good Evening"
           default:
               greeting = "Good Night"
           }
        TimeLbl.text = greeting
       }
    @IBAction func AddDetailButton(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func MenuButton(_ sender: Any) {
        SideMenu.isHidden = false
    }
    @IBAction func cancelButton(_ sender: Any) {
        SideMenu.isHidden = true
    }
    
}
extension HomeScreenViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == TableView {
            return emp_Detail.count
          } 
       else if tableView == sideMenuTB {
              // Return the number of rows for the second table view
              return sideMenuList.count
          }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == TableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EmployeesTableViewCell
            
            let empData = emp_Detail[indexPath.row]
            
            cell.nameLbl?.text = empData.name
            cell.designationLbl?.text = empData.Designation
            
            if let image = empData.pic {
                cell.ImageView.image = image
            } else {
                cell.ImageView.image = UIImage(named: "") // Set a placeholder image if no image is available
            }
            // Add target action for the button
            cell.additems_btn.tag = indexPath.row // Set tag to identify the row
            cell.additems_btn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            
            cell.downArrow_btn.tag = indexPath.row // Set tag to identify the row
            cell.downArrow_btn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            
            return cell
        }
        else if tableView == sideMenuTB {
                let cell = tableView.dequeueReusableCell(withIdentifier: "sidemenuCell", for: indexPath) as! SideMenuTableViewCell
                // Configure the cell for the second table view
            cell.sidemenu_label.text = sideMenuList[indexPath.row]
                return cell
            }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == TableView {
               // Return the height for rows in the first table view
               return 90
           }
        else  if tableView == sideMenuTB {
               // Return the height for rows in the second table view
               return 70
           }
        return 90
    }
    @objc func buttonTapped(_ sender: UIButton) {
        let rowIndex = sender.tag
        print("Button tapped in row \(rowIndex)")
        let empData = emp_Detail[sender.tag]
        let id = emp_Detail[sender.tag].id
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "UserAssignedItemsViewController") as! UserAssignedItemsViewController
        newViewController.tittleName = empData.name
        newViewController.userId = id
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            emp_Detail.remove(at: indexPath.row)
            
            let encoder = JSONEncoder()
            do {
                let encodedData = try emp_Detail.map { try encoder.encode($0) }
                UserDefaults.standard.set(encodedData, forKey: "employees")
            } catch {
                print("Error encoding medications: \(error.localizedDescription)")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == TableView {
            let empData = emp_Detail[indexPath.row]
            let id = emp_Detail[indexPath.row].id
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            if let newViewController = storyBoard.instantiateViewController(withIdentifier: "UserAllDataViewController") as? UserAllDataViewController {
                newViewController.selectedEmpDetail = empData
                newViewController.userID = id
                newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                newViewController.modalTransitionStyle = .crossDissolve
                self.present(newViewController, animated: true, completion: nil)
    }
           }
        else  if tableView == sideMenuTB {
            if indexPath.item == 0 {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
                newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                newViewController.modalTransitionStyle = .crossDissolve
                self.present(newViewController, animated: true, completion: nil)
                
            } else if indexPath.item == 1 {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "FeedbackViewController") as! FeedbackViewController
                newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                newViewController.modalTransitionStyle = .crossDissolve
                self.present(newViewController, animated: true, completion: nil)
                
            }
            else if indexPath.item == 2 {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
                newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                newViewController.modalTransitionStyle = .crossDissolve
                self.present(newViewController, animated: true, completion: nil)
            }
            else if indexPath.item == 3 {
                // Open Privacy Policy Link
                if let url = URL(string: "https://jtechapps.pages.dev/privacy") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            else if indexPath.item == 4 {
                let appID = "AssetAssign" // Replace with your actual App ID
                let appURL = URL(string: "https://apps.apple.com/app/id\(appID)")!
                let activityViewController = UIActivityViewController(activityItems: [appURL], applicationActivities: nil)
                present(activityViewController, animated: true, completion: nil)
            }
           }
    }
}
