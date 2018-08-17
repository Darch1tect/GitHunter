//
//  ViewController.swift
//  GitHunter
//
//  Created by Vitalii Roditieliev on 8/12/18.
//  Copyright © 2018 Vitalii Roditieliev. All rights reserved.
//

import UIKit

final class UsersListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView?
    
    private let userManager = UserManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userManager.delegate = self
        userManager.loadPage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? FollowersListViewController {
            destination.followersModel = FollowersListModel.init(with: userManager.selectedUser!)
        }
    }

}

extension UsersListViewController: UsersManagerObserving {
    
    func didReceiveDataUpdate() {
        tableView?.reloadData()
    }
}

extension UsersListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userManager.loadedUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return userManager.setupCellForRawAtIndexPath(indexPath: indexPath, tableView: tableView)
    }
}

extension UsersListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row == userManager.loadedUsers.count - 1) {
            userManager.loadPage()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
        userManager.selectedUser = userManager.loadedUsers[indexPath.row]
        self.performSegue(withIdentifier: "followersSegue", sender: self)
    }
}

