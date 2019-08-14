//
//  StateListTableViewController.swift
//  Representative
//
//  Created by Jackson Tubbs on 8/14/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import UIKit

class StateListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return States.all.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stateCell", for: indexPath)

        cell.textLabel?.text = States.all[indexPath.row]

        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showStateDetail" {
            guard let index = tableView.indexPathForSelectedRow else {return}
            guard let destinationVC = segue.destination as? StateDetailTableViewController else {return}
            let stateString = States.all[index.row]
            destinationVC.stateString = stateString
        }
    }
} // End Of Class
