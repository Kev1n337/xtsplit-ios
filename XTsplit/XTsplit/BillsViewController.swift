//
//  BillsViewController.swift
//  XTsplit
//
//  Created by Kevin Linne on 09.10.16.
//  Copyright © 2016 Kevin Linne. All rights reserved.
//

import UIKit

class BillsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddBillDelegate, UINavigationControllerDelegate {

    var group: Group?
    var bills = [Bill]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tabCon = self.tabBarController as! GroupTabBarController
        group = tabCon.group

        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.delegate = self
        
        if let groupBills = group?.bills {
            bills = groupBills
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(BillsViewController.addTapped(sender:))), animated: true)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bills.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.performSegue(withIdentifier: "groupDetail", sender: self.tableView.cellForRow(at: indexPath))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bill = bills[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BillCell") as? BillCell {
            cell.configureCell(bill: bill, color: (group?.color)!)
            return cell
        } else {
            return BillCell()
        }
    }
    
    func addTapped(sender: UIButton!) {
        self.performSegue(withIdentifier: "addBill", sender: sender)
    }
    
    func billAddedResponse(bill:Bill) {
        bills.append(bill)
        tableView.reloadData()
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? GroupsTableViewController {
            controller.groups = []
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let identifier = segue.identifier {
            switch identifier {
                case "addBill":
                    let addBilllVC = segue.destination as? AddBillViewController
                    
                    addBilllVC?.delegate = self
                    addBilllVC?.groupKey = group?.groupKey
            default: break
            }
        }
    }
 

}
