//
//  ZoomView.swift
//  Dogs Out
//
//  Created by Danny Prodanovic on 11/01/2022.
//

import SwiftUI

struct ZoomView: View {

    @State var yAs = 0
    var simpleDrag: some Gesture {
           DragGesture()
               .onChanged { value in
                   yAs = Int(value.translation.height)
               }
       }
    @State var scrolling = false
    @Binding var zoomlevel: Double
    
    var body: some View {
        HStack {
            ZStack {
                Rectangle()
                    .frame(width: scrolling ? 100 : 40, height: 30)

                    .offset(x: 10, y: CGFloat(yAs))
                    .opacity(0.3)
                    .animation(.easeIn)
                .gesture(simpleDrag)
                .onTapGesture {
                    print(yAs)
                }
                .onLongPressGesture(minimumDuration: 0.1) {

                    } onPressingChanged: { inProgress in
                       scrolling = inProgress
                    }
                Text(returnImage())
                    .offset(x: scrolling ? -10 : 10, y: CGFloat(yAs))
                    .animation(.easeIn)

                    
            }
            Rectangle()
                .frame(width: 3, height: 350)
                .opacity(0.3)
        }

    }

    private func returnImage() -> String {
//schoen, bijvogel, heli, vliegt, nasa raket.
        switch yAs {
        case -160 ... -120:
            return "👟"
        case -120 ... -80:
            return "🐝"
        case -80 ... -40:
            return "🕊"
        case -40 ... 0:
            return "🚁"
        case 0...40:
            return "✈️"
        case 40...80:
            return "🛰"
        case 80...120:
            return "🚀"
        case 120...160:
            return "🛸"
        default:
            return "🕊"
        }
    }
}
