//
//  UsersManager.swift
//  GitHunter
//
//  Created by Vitalii Roditieliev on 8/14/18.
//  Copyright © 2018 Vitalii Roditieliev. All rights reserved.
//

import Foundation
import UIKit

protocol UsersManagerObserving: class {
    func didReceiveDataUpdate()
}

final class UserManager {
    
    var loadedUsers: [UserModel] = []
    var pagesCount: Int = 0
    
    static let shared = UserManager()
    
    weak var delegate: UsersManagerObserving?
    
    private init() {
        
    }
    
    public func loadPage() {
        let cfg = ServiceConfiguration.appConfig()
        let service = Service(cfg!)
        _ = LoadUsers.init(from: pagesCount+1, perPage: 30).execute(in: service, retry: 1).done { newLoadedUsers in
            self.loadedUsers += newLoadedUsers
            self.pagesCount += 1
            print(newLoadedUsers)
            self.delegate?.didReceiveDataUpdate()
        }
    }
    
    func setupCellForRawAtIndexPath(indexPath: IndexPath, tableView: UITableView) -> UserCell {
        let cell: UserCell
        let userModel = loadedUsers[indexPath.row]
        
        cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCell
        cell.setupWithModel(userModel: userModel)
        return cell
    }
}
