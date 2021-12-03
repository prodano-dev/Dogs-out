//
//  WebRepository.swift
//  Dogs Out
//
//  Created by Danny Prodanovic on 25/11/2021.
//

import Foundation
import Combine

protocol WebRepository {
    var session: URLSession { get }
    var baseURL: String { get }
}

extension WebRepository {

    public func fetchData<Value: Decodable>(endpoint: Route) -> AnyPublisher<Value, APIError> {

        do {
            let request = try endpoint.urlRequest(baseURL: baseURL)

            return session
                .dataTaskPublisher(for: request)
                .tryMap { response in
                    guard
                        let httpURLResponse = response.response as? HTTPURLResponse,
                        httpURLResponse.statusCode == 200 else {
                            throw APIError.genericError
                        }
                    return response.data

                }
                .mapError { APIError.map($0) }
                .decode(type: Value.self, decoder: JSONDecoder())
                .mapError { APIError.map($0) }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        } catch let error {
            return Fail<Value, APIError>(error: APIError.other(error)).eraseToAnyPublisher()
        }
    }
}
