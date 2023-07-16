//
//  RMRequest.swift
//  
//
//  Created by Rafael Menezes on 12/07/23.
//

import Foundation

public enum RMMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

public protocol RMRequest {
    var host: String? { get set }
    var path: String { get set }
    var method: RMMethod { get set }
    var body: AnyHashable? { get set }
    var params: [String: AnyHashable]? { get set }
    var header: [String: AnyHashable]? { get set }
}
