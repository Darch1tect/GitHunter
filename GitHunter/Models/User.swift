//
//  User.swift
//  GitHunter
//
//  Created by Vitalii Roditieliev on 8/13/18.
//  Copyright © 2018 Vitalii Roditieliev. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct UserModel {
    let id: Int
    let loginUrlString: String
    let avatarUrlString: String
    let profileURLString: String
    
    public init?(_ json: JSON) {
        guard let id = json["id"].int else { return nil }
        self.id = id
        self.loginUrlString = json["login"].stringValue
        self.avatarUrlString = json["avatar_url"].stringValue
        self.profileURLString = json["html_url"].stringValue
    }
    
    public static func load(list: [JSON]) -> [UserModel] {
        return list.compactMap { UserModel($0) }
    }
}
