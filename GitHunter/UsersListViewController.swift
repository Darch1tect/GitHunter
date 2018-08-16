//
//  ViewController.swift
//  GitHunter
//
//  Created by Vitalii Roditieliev on 8/12/18.
//  Copyright © 2018 Vitalii Roditieliev. All rights reserved.
//

import UIKit

class UsersListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView?
    
    private let userManager = UserManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userManager.delegate = self
        userManager.loadPage()
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


