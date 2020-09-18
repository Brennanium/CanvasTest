//
//  RootView.swift
//  CanvasTest
//
//  Created by Brennan Drew on 9/10/20.
//

import SwiftUI

struct RootView: View {
    //var tree: Node
    //@Binding var root: Node
    
    @State var avgPosition: CGFloat? = nil
    
    //@Binding var horizontalPadding: CGFloat
    
    @ObservedObject var store: ObservedVariables
    
    var body: some View {
        TreeView(id: store.root!).environmentObject(store)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .onTapGesture(count: 1, perform: {
                withAnimation{
                    store.selected = nil
                }
            })
    }
}


struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello World")//RootView()
    }
}
