//
//  Route.swift
//  Dogs Out
//
//  Created by Danny Prodanovic on 25/11/2021.
//

import Foundation

public class Route {

    enum HTTPMethod: String {
        case Get = "GET"
    }

    enum Body {
        case none
        case dictonary([String: Any])
    }

    let method: HTTPMethod
    let path: String
    let headers: [String: String]
    var body: Body = .none

    init(method: HTTPMethod, path: String, headers: [String: String]) {
        self.method = method
        self.path = path
        self.headers = headers
    }

    public func urlRequest(baseURL: String) -> URLRequest {
        let url = URL(string: baseURL + path)
        var request = URLRequest(url: url!)
        request.httpMethod = method.rawValue
        for(key, value) in headers {
            request.setValue(key, forHTTPHeaderField: value)
        }
        return request
    }
}
