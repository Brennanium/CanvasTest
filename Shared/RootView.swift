//
//  RootView.swift
//  CanvasTest
//
//  Created by Brennan Drew on 9/10/20.
//

import SwiftUI

struct RootView: View {
    var tree: Node
    @Binding var root: Node
    
    @State var avgPosition: CGFloat? = nil
    
    //@Binding var horizontalPadding: CGFloat
    
    
    
    var body: some View {
        TreeView(tree: tree, root: $root)
        
    }
}

class ObservedVariables: ObservableObject {
    @Published var selected: UUID?
    @Published var horizontalPadding: CGFloat = 5
    
    @Published var nodes: [UUID:Node] = [:]
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello World")//RootView()
    }
}
