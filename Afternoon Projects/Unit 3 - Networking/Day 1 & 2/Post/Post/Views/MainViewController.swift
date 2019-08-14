//
//  MainViewController.swift
//  Post
//
//  Created by Jackson Tubbs on 8/12/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var postTableView: UITableView!
    
    
    // MARK: - Properteis
    
    var postController = PostController()
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshControl.addTarget(self, action: #selector(refreshControlPulled), for: .valueChanged)
        
        postTableView.refreshControl = refreshControl
        postTableView.estimatedRowHeight = 45
        postTableView.rowHeight = UITableView.automaticDimension
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        postController.fetchPosts{
            self.reloadTableView()
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func addPostButtonTapped(_ sender: Any) {
        presentNewPostAlert()
    }
    
    
    // MARK: - Custom Functions
    
    func presentNewPostAlert() {
        let alertController = UIAlertController(title: "New Post", message: "Enter Information", preferredStyle: .alert)
        alertController.addTextField { (usernameTextField) in
            
        }
        alertController.addTextField { (messageTextField) in
            
        }
        alertController.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
            guard let username = alertController.textFields?[0].text, let message = alertController.textFields?[1].text else {return}
            if username.isEmpty || message.isEmpty {
                self.presentMissingInfo()
                return
            }
            self.postController.addNewPostWith(username: username, text: message, completion: {
                DispatchQueue.main.async {
                    self.postTableView.reloadData()
                }
            })
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentMissingInfo() {
        let alertController = UIAlertController(title: "Please Fill Out Fields", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func refreshControlPulled() {
        postController.fetchPosts {
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.reloadTableView()
            }
        }
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.postTableView.reloadData()
        }
    }

    // MARK: - Table View Protocol Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postController.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postTableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        
        let post = postController.posts[indexPath.row]
        
        cell.textLabel?.text = post.text
        if let postDate = post.date {
            cell.detailTextLabel?.text = "\(post.username) - " + postDate
        } else {
            cell.detailTextLabel?.text = "\(post.username)"
        }
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
