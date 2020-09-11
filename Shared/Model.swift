//
//  Model.swift
//  CanvasTest
//
//  Created by Brennan Drew on 8/10/20.
//

import SwiftUI


let sampleData =
Node(text: "TP", children: [
    Node(text: "0"),
    Node(text: "T'", children:
        [Node(text: "T"),
        Node(text: "VP", children:
            [Node(text: "NP"),
             Node(text: "V'", children:
                    [Node(text: "run")])])])
])

let sampleData2 =
Node(text: "level 0", children: [
    Node(text: "level 1"),
    Node(text: "level 1", children:
        [Node(text: "level 2"),
         Node(text: "level 2"),
         Node(text: "level 2", children:
            [Node(text: "level 3"),
             Node(text: "level 3")
         ])
    ])
])

struct MainView: View {
    //@State var horizontalPadding: CGFloat = 3
    @State var tree = sampleData
    
    @StateObject var store = ObservedVariables()
    
    var body: some View {
        NavigationView {
            VStack {
                /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
                Slider(value: $store.horizontalPadding, in: 0...15).padding()
                RootView(tree: tree, root: $tree).environmentObject(store)

                Button("Add"){
                    withAnimation() {
                        self.tree.insert("new")
                    }
                }
            }.navigationTitle("Test")
        }
    }
    
    
}




struct Model_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
