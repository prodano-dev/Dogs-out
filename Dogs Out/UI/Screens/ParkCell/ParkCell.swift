//
//  ParkCell.swift
//  Dogs Out
//
//  Created by Danny Prodanovic on 07/12/2021.
//

import SwiftUI
import MapKit

struct ParkCell: View {

    let title: String
    var distance = 0.0

    var body: some View {
        HStack {
            Image("doggy")
                .resizable()
                .frame(width: 100, height: 125)
                .padding(.horizontal)
            HStack {
                VStack {
                    HStack {
                        Text(title)
                            .font(.headline)
                        .padding(.top)
                        Spacer()
                    }
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.orange)
                        if distance == 0.0 {
                            Text("Enable location")
                                .font(.subheadline)
                        } else {
                            Text("\(distance) km verwijderd")
                                .font(.caption)
                        }
                        Spacer()
                    }
                    Button {

                    } label: {
                        Text("Navigate")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                    .frame(width: 150, height: 50)
                    .background(Color.orange)
                    .cornerRadius(50)
                    .padding()

                }
                Spacer()
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal, 5)
        .padding(.bottom)

    }
}


struct ParkCell_Preview: PreviewProvider {
    static var previews: some View {
        ParkCell(title: "Lisalaan")
    }
}
