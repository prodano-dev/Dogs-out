//
//  Error.swift
//  Dogs Out
//
//  Created by Danny Prodanovic on 25/11/2021.
//

import Foundation
import Combine

enum APIError: Error, LocalizedError {

    case urlError(URLError)
    case responseError(Int)
    case decodingError(DecodingError)
    case genericError
    case other(Error)

    var localizedMessage: String {

        switch self {
        case .urlError(let error):
            return error.localizedDescription
        case .responseError(let status):
            return "bad response: \(status)"
        case .decodingError(let error):
            return error.localizedDescription
        case .genericError:
            return "Unkown error, please check later"
        case .other(let error):
            return "see error \(error.localizedDescription)"
        }
    }

    static func map(_ error: Error) -> APIError {
      return (error as? APIError) ?? .other(error)
    }
}
