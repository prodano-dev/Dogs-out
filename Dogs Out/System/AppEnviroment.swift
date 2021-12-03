//
//  AppEnviroment.swift
//  Dogs Out
//
//  Created by Danny Prodanovic on 25/11/2021.
//

import Foundation

struct AppEnviroment {
    let container: DIContainer
}

extension AppEnviroment {

    static func bootstrap() -> AppEnviroment {
        let session = configuredURLSession()
        let webRepository = configureWebRepository(session: session)
        let service = configureServices(webRepository: webRepository)
        let diContainer = DIContainer(sevices: service)

        return AppEnviroment(container: diContainer)
    }

    private static func configuredURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        return URLSession(configuration: configuration)
    }

    private static func configureWebRepository(session: URLSession) ->
        DIContainer.WebRepositories {
            let dogsWebRepository = DefaultDogsWebRepository(
                session: session,
                baseURL: "https://data.eindhoven.nl/api/records/1.0/search/?dataset=")
            return .init(dogsWebRepository: dogsWebRepository)
    }

    private static func configureServices(webRepository: DIContainer.WebRepositories) -> DIContainer.Services {
        let dogsService = DefaultDogsService(
            dogsWebRepository: webRepository.dogsWebRepository
        )

        return .init(dogsService: dogsService)
    }
}
