//
//  Dogs_OutApp.swift
//  Dogs Out
//
//  Created by Danny Prodanovic on 25/11/2021.
//

import SwiftUI

@main
struct Dogs_OutApp: App {
    let environment = AppEnviroment.bootstrap()
    var body: some Scene {
        WindowGroup {
            ContentView(container: environment.container)
        }
    }
}
