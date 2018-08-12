//
//  ServiceProtocol.swift
//  ClientRedd
//
//  Created by Vitalii Roditieliev on 6/25/18.
//  Copyright © 2018 Vitalii Roditieliev. All rights reserved.
//

import Foundation
import PromiseKit

public protocol ServiceProtocol {
    
    var configuration: ServiceConfiguration { get }
    var headers: HeadersDict { get }
    
    init(_ configuration: ServiceConfiguration)
    
    func execute(_ request: RequestProtocol, retry: Int?) -> Promise<ResponseProtocol>
}
