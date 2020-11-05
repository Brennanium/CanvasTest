//
//  NodeDetailView.swift
//  CanvasTest
//
//  Created by Brennan Drew on 9/10/20.
//

import SwiftUI

struct NodeDetailView: View {
    var id: UUID
    
    var node: Node? {
        get { store.nodeByID(id) }
    }
    
    @State var text = ""
    
    @EnvironmentObject var store: ObservedVariables
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                textField(text: node != nil ? $store[id].text : $text)
            }
            
            if node?.children != nil {
                Group {
                    Text("children:")
                    HStack {
                        ForEach(node!.children!) { node in
                            textField(text: $store[node.id].text)
                        }
                    }
                }
            }
        }
    }
    
    func textField(text binding: Binding<String>) -> some View {
        TextField("XP", text: binding)
            .font(.system(size: 16))
            .fixedSize()
            .padding(2)
            .background(RoundedRectangle(cornerRadius: 4).stroke().foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/))
    }
}

struct NodeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)//NodeDetailView()
    }
}
