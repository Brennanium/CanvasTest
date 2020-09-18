//
//  NodeDetailView.swift
//  CanvasTest
//
//  Created by Brennan Drew on 9/10/20.
//

import SwiftUI

struct NodeDetailView: View {
    var id: UUID
    
    @State var text = ""
    
    @EnvironmentObject var store: ObservedVariables
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                textField(text: $store[id].text)
            }
            
            if store[id].children != nil {
                Group {
                    Text("children:")
                    HStack {
                        ForEach(store[id].children!) { node in
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
