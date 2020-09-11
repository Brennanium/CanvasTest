//
//  NodeDetailView.swift
//  CanvasTest
//
//  Created by Brennan Drew on 9/10/20.
//

import SwiftUI

struct NodeDetailView: View {
    var node: Node
    
    @State var text = ""
    var body: some View {
        TextField("Node Label", text: $text)
            .font(.system(size: 16))
    }
}

struct NodeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)//NodeDetailView()
    }
}
