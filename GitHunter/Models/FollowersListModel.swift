//
//  FollowersListModel.swift
//  GitHunter
//
//  Created by Vitalii Roditieliev on 8/16/18.
//  Copyright © 2018 Vitalii Roditieliev. All rights reserved.
//

import UIKit

protocol FollowersObserving: class {
    func followersUpdated()
}

final class FollowersListModel {
    
    let targetUser: UserModel
    var usersFollowers: [UserModel] = []
    
    weak var delegate: FollowersObserving?
    
    init(with user: UserModel) {
        targetUser = user
        getFollowersList(for: targetUser)
    }
    
    func getFollowersList(for user: UserModel) {
        let cfg = ServiceConfiguration.appConfig()
        let service = Service(cfg!)
        _ = LoadFollowers.init(for: user.loginUrlString).execute(in: service, retry: 1).done
            { [unowned self] loadedUsers in
                self.usersFollowers += loadedUsers
                print(loadedUsers)
                self.delegate?.followersUpdated()
        }
    }
    
    func setupCellForRawAtIndexPath(indexPath: IndexPath, tableView: UITableView) -> UserCell {
        let cell: UserCell
        let userModel = usersFollowers[indexPath.row]
        
        cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCell
        cell.setupWithModel(userModel: userModel)
        return cell
    }
    
}
