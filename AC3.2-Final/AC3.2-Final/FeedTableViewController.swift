//
//  FeedTableViewController.swift
//  AC3.2-Final
//
//  Created by Jermaine Kelly on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import FirebaseDatabase


class FeedTableViewController: UITableViewController,LoginProtocol {
    var isLoggedIn: Bool = false
    private var delegate: LoginProtocol?
    private var databaseRef: FIRDatabaseReference?
    private var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Feed"
        self.view.backgroundColor = .white
        setUptableview()
        self.databaseRef =  FIRDatabase.database().reference().child("posts")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isLoggedIn{
            print("Logged in")
            getAllPosts()
        }else{
            showLogin()
        }
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
      
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.cellIdentifer, for: indexPath) as! FeedTableViewCell
//        cell.alpha = 0
//        
//        UIView.animate(withDuration: 0.5) { 
//            cell.alpha = 1
//        }
        cell.post = posts[indexPath.row]
        
        return cell
    }
    
    //MARK:- Utitlities
    
    private func getAllPosts(){
        databaseRef?.observeSingleEvent(of: .value, with: { (snapshot) in
            var upDatedPosts: [Post] = []
            for child in snapshot.children{
                dump(child)
                if let snap = child as? FIRDataSnapshot,
                    let valueDict = snap.value as? [String:String]{
                    print(valueDict)
                    
                    let post = Post(key: snap.key, dict: valueDict)
                    upDatedPosts.append(post)
                }
            }
            self.posts = upDatedPosts
            self.tableView.reloadData()
        })
    }
    
    private func setUptableview(){
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: FeedTableViewCell.cellIdentifer)
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
    }
    
    private func showLogin(){
        let loginVC: LoginViewController = LoginViewController()
        loginVC.loginDelegate = self
        present(loginVC, animated: true, completion: nil)
    }
}
