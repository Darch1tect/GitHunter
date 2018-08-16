//
//  UserCell.swift
//  GitHunter
//
//  Created by Vitalii Roditieliev on 8/13/18.
//  Copyright © 2018 Vitalii Roditieliev. All rights reserved.
//

import Foundation
import UIKit

final class UserCell: UITableViewCell {
    
   @IBOutlet private weak var loginLabel: UILabel?
   @IBOutlet private weak  var profileLabel: UILabel?
   @IBOutlet private weak  var avatarView: UIImageView?
    
    func setupWithModel(userModel: UserModel) {
        loginLabel?.text = userModel.loginUrlString
        profileLabel?.text = userModel.profileUrlString
        
        let conf = ServiceConfiguration.init(name: "AvatarsCfg", base: userModel.avatarUrlString)
        let service = Service(conf!)
        _ = LoadImage.init(from: userModel.avatarUrlString).execute(in: service, retry: 1).done(on: DispatchQueue.main, { dataResponse in
            let image = UIImage(data: dataResponse.data!)
            self.avatarView?.image = image
        })
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarView?.image = nil
    }
    
}
