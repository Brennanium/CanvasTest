//
//  NodeView.swift
//  CanvasTest
//
//  Created by Brennan Drew on 9/1/20.
//

import SwiftUI

struct NodeWrapperView: View {
    var node: Node
    @Binding var root: Node
    
    //@EnvironmentObject var store: ObservedVariables
    
    var body: some View {
        NodeView(node: node, root: $root)
            .anchorPreference(key: NodePositionsPreferenceKey.self, value: .top, transform: { anchor in
                [self.node.id: NodePositionData(top: anchor)]
            })
            .transformAnchorPreference(key: NodePositionsPreferenceKey.self, value: .bottom, transform: { value, anchor  in
                value[self.node.id]!.bottom = anchor
            })
            .transformAnchorPreference(key: NodePositionsPreferenceKey.self, value: .leading, transform: { value, anchor  in
                value[self.node.id]!.leading = anchor
            })
            
            
    }
}


struct NodeView: View {
    var node: Node
    @Binding var root: Node
    
    @EnvironmentObject var store: ObservedVariables
    
    var body: some View {
        if (store.selected ?? UUID()) == node.id {
            NavigationLink(destination: NodeDetailView(node: node)) {
                Text(node.text)
                    .font(.system(size: 16))
                    .fixedSize()
                    .padding(2)
                    .background(RoundedRectangle(cornerRadius: 4).stroke().foregroundColor(.blue))
            }
        } else {
            Text(node.text)
                .font(.system(size: 16))
                .fixedSize()
                .padding(2)
                .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                    withAnimation {
                        //self.root.insert("new!", forID: self.node.id)
                        if self.store.selected != self.node.id {
                            self.store.selected = self.node.id
                        } else {
                            self.store.selected = UUID()
                        }
                    }
                })
        }
    }
}

struct Node: Hashable, Identifiable {
    var id = UUID()
    
    var text: String
    
    var children: [Node]?
    
    var shape: String?
    
    mutating func insert(_ text: String) {
        /*if children == nil {
            children = [Node(text: text)]
        } else if children!.count > 1 {
            children![1].insert(text)
        }*/
        children!.append(Node(text: text))
    }
    
    mutating func insert(_ text: String, forID id: UUID) {
        if children != nil {
            for i in 0..<children!.count {
                if children![i].id == id {
                    if children![i].children != nil {
                        children![i].children!.append(Node(text: text))
                    } else {
                        children![i].children = [Node(text: text)]
                    }
                } else {
                    children![i].insert(text, forID: id)
                }
            }
        }
    }
}


struct NodePositionData {
    var top: Anchor<CGPoint>? = nil
    var bottom: Anchor<CGPoint>? = nil
    var leading: Anchor<CGPoint>? = nil
}

struct NodePositionsPreferenceKey: PreferenceKey {
    typealias Value = [UUID:NodePositionData]
    
    static var defaultValue: [UUID:NodePositionData] = [:]
    static func reduce(value: inout [UUID : NodePositionData], nextValue: () -> [UUID : NodePositionData]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}


struct NodeView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello World")//NodeView()
    }
}
