//
//  LineView.swift
//  CanvasTest
//
//  Created by Brennan Drew on 9/1/20.
//

import SwiftUI
/*
struct LineView: View {
    var line: Line
    
    @EnvironmentObject var store: ObservedVariables
    
    var body: some View {
        line
            .stroke()
            .foregroundColor(self.store.selected == self.line.id ? .blue : .black)
            .onTapGesture(count: 1, perform: {
                if self.store.selected != self.line.id {
                    self.store.selected = self.line.id
                } else {
                    self.store.selected = UUID()
                }
            })
    }
} */


struct Line: Shape {
    
    var from: CGPoint
    var to: CGPoint
    
    var animatableData: AnimatablePair<CGPoint, CGPoint> {
        get { AnimatablePair(from, to) }
        set {
            from = newValue.first
            to = newValue.second
        }
    }

    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: self.from)
            p.addLine(to: self.to)
        }
    }
}


struct LineView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello World")//LineView()
    }
}
