//
//  ZoomView.swift
//  Dogs Out
//
//  Created by Danny Prodanovic on 11/01/2022.
//

import SwiftUI

struct ZoomView: View {

    @State var offsetY = 0
    var simpleDrag: some Gesture {
           DragGesture()
               .onChanged { gesture in
                   withAnimation(.spring()) {
                       if gesture.translation.height < 160 &&
                            gesture.translation.height > -160 {
                           offsetY = Int(lastOffsetY + gesture.translation.height)
                       }
                   }
               }
               .onEnded { _ in
                   lastOffsetY = CGFloat(offsetY)
               }
       }

    @State var scrolling = false
    @Binding var zoomlevel: Double
    @State private var lastOffsetY: CGFloat = 0

    var body: some View {
        HStack {
            ZStack {
                Rectangle()
                    .frame(width: scrolling ? 100 : 40, height: 30)

                    .offset(x: 10, y: CGFloat(offsetY))
                    .opacity(0.3)
                    .animation(.easeIn)
                .gesture(simpleDrag)

                .onLongPressGesture(minimumDuration: 0.1) { } onPressingChanged: { inProgress in
                       scrolling = inProgress
                    }
                
                Text(returnImage())
                    .offset(x: scrolling ? -10 : 10, y: CGFloat(offsetY))
                    .animation(.easeIn)
    
                    
            }
            Rectangle()
                .frame(width: 3, height: 350)
                .opacity(0.3)
        }

    }

    private func returnImage() -> String {
        switch offsetY {
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


struct foot_Previews: PreviewProvider {
    @State var zoom = 0.5
    static var previews: some View {
        ZoomView(zoomlevel: .constant(0.5))
    }
}
