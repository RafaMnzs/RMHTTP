//
//  RMStatus.swift
//  
//
//  Created by Rafael Menezes on 12/07/23.
//

import Foundation

public enum RMStatus: Error {
    case success
    case emptyData
    case notFound
    case unprocessable
    case tooManyRequests
    case unauthorized
    case forbidden
    case conflict
    case internalServerError
    case serviceUnavailable
    case gatewayTimeout
    case timeout
    case unknown

    public init(statusCode: Int?) {
        switch statusCode ?? 0 {
        case 200..<300:
            self = .success
        case 404:
            self = .notFound
        case 401:
            self = .unauthorized
        case 403:
            self = .forbidden
        case 408:
            self = .timeout
        case 422:
            self = .unprocessable
        case 429:
            self = .tooManyRequests
        case 409:
            self = .conflict
        case 500:
            self = .internalServerError
        case 503:
            self = .serviceUnavailable
        case 504:
            self = .gatewayTimeout
        default:
            self = .unknown
        }
    }
}
