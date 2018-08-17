//
//  FollowersListViewController.swift
//  GitHunter
//
//  Created by Vitalii Roditieliev on 8/16/18.
//  Copyright © 2018 Vitalii Roditieliev. All rights reserved.
//

import UIKit

final class FollowersListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var loadingView: UIView?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    
    var followersModel: FollowersListModel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        self.title = "\(followersModel.targetUser.loginUrlString)'s followers"
        followersModel.delegate = self
        loadingView?.isHidden = false
        activityIndicator?.startAnimating()
    }
    
}

extension FollowersListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followersModel.usersFollowers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return followersModel.setupCellForRawAtIndexPath(indexPath: indexPath, tableView: tableView)
    }
    
}

extension FollowersListViewController: FollowersObserving {
    
    func followersUpdated() {
        tableView?.reloadData()
        activityIndicator?.stopAnimating()
        loadingView?.isHidden = true
    }
}
