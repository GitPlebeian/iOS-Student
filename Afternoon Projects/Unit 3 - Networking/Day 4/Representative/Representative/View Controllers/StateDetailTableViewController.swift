//
//  StateDetailTableViewController.swift
//  Representative
//
//  Created by Jackson Tubbs on 8/14/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import UIKit

class StateDetailTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var reps: [Representative] = []
    
    // Landing Pad
    var stateString: String?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        loadViewIfNeeded()
        guard let stateString = stateString else {return}
        self.title = stateString
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        RepresentativeController.searchRepresentatives(forState: stateString) { (reps) in
            guard let reps = reps else {return}
            
            DispatchQueue.main.async {
                self.reps = reps
                self.tableView.reloadData()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reps.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "repCell", for: indexPath) as? RepTableViewCell else {return UITableViewCell()}

        let rep = reps[indexPath.row]
        
        cell.nameLabel.text = rep.name
        cell.linkLabel.text = rep.link
        cell.districtLabel.text = rep.district
        cell.officeLabel.text = rep.office
        cell.partyLabel.text = rep.party
        cell.phoneLabel.text = rep.phone
        cell.stateLabel.text = rep.state

        return cell
    }
} // End Of Class
