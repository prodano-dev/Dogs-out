//
//  ContentView.swift
//  Dogs Out
//
//  Created by Danny Prodanovic on 25/11/2021.
//

import SwiftUI

struct ContentView: View {

    let container: DIContainer

    var body: some View {
        //ZoomView()
        MapView(viewModel: .init(container: container))
    }
}
