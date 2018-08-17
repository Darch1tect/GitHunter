//
//  UsersOperations.swift
//  GitHunter
//
//  Created by Vitalii Roditieliev on 8/13/18.
//  Copyright © 2018 Vitalii Roditieliev. All rights reserved.
//

import Foundation

public class LoadUsers: JSONOperation<[UserModel]> {
    
    public init(since userId: Int, perPage: Int) {
        super.init()
        let fields: ParametersDict = ["since" : userId, "per_page" : perPage]
        self.request = Request(method: .get, endpoint: "/users", fields: fields)
        self.onParseResponse = { json in
            return UserModel.load(list: json.arrayValue)
        }
    }
}

public class LoadFollowers: JSONOperation<[UserModel]> {
    
    public init(for userName: String) {
        super.init()
        let endpointString = "/users/\(userName)/followers"
        self.request = Request(method: .get, endpoint: endpointString)
        self.onParseResponse = { json in
            return UserModel.load(list: json.arrayValue)
        }
    }
}

public class LoadImage: DataOperation<ResponseProtocol> {
    
    public init(from url: String) {
        super.init()
        self.request = Request(method: .get, endpoint: "")
    }
}
