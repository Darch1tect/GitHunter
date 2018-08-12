//
//  OperationProtocol.swift
//  ClientRedd
//
//  Created by Vitalii Roditieliev on 7/17/18.
//  Copyright © 2018 Vitalii Roditieliev. All rights reserved.
//

import Foundation
import PromiseKit

protocol OperationProtocol {
    associatedtype T
    
    var request: RequestProtocol? { get set }
    
    func execute(in service: ServiceProtocol, retry: Int?) -> Promise<T>
}
