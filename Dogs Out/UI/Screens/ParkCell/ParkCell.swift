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
    var timeTravel = 0.0
    let onTap: (() -> Void)
    var navigating = false

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
                    VStack {
                        HStack {
                            Image(systemName: "location.fill")
                                .foregroundColor(.orange)
                            if distance == 0.0 {
                                Text("Enable location")
                                    .font(.subheadline)
                            } else {
                                Text("\(format(item: distance)) km verwijderd")
                                    .font(.caption)
                            }
                            Spacer()
                        }
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(.orange)
                            if !(distance == 0.0) {
                                Text("\(format(item: timeTravel)) minuten")
                                    .font(.caption)
                            }
                            Spacer()
                        }
                    }

                    Button {
                        onTap()
                    } label: {
                        Text(navigating ? "Stop navigation" : "Navigate")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                    .frame(width: 150, height: 50)
                    .background(navigating ? Color.red: Color.orange)
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

    func format(item: Double) -> String {
        return String(format: "%.2f", item)
    }
}
