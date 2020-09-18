//
//  NodeView.swift
//  CanvasTest
//
//  Created by Brennan Drew on 9/1/20.
//

import SwiftUI

struct NodeView: View {
    var id: UUID
    
    @EnvironmentObject var store: ObservedVariables
    
    var body: some View {
        let tap = TapGesture()
            .onEnded() { _ in
                //withAnimation(.default) {
                    //self.root.insert("new!", forID: self.node.id)
                    if self.store.selected != self.id {
                        self.store.selected = self.id
                    } //else {
                        //self.store.selected = nil
                    //}
                //}
            }
        let doubleTap = TapGesture(count: 2)
            .onEnded() { _ in
                withAnimation(.default) {
                    self.store.selected = self.store.insert(Node(text: "new!"), forID: id)
                }
            }
        let simultaneous = tap.simultaneously(with: doubleTap)
        
        return innerNode
            .gesture(simultaneous)
            .anchorPreference(key: NodePositionsPreferenceKey.self, value: .top, transform: { anchor in
                [id: NodePositionData(top: anchor)]
            })
            .transformAnchorPreference(key: NodePositionsPreferenceKey.self, value: .bottom, transform: { value, anchor  in
                value[id]!.bottom = anchor
            })
            .transformAnchorPreference(key: NodePositionsPreferenceKey.self, value: .leading, transform: { value, anchor  in
                value[id]!.leading = anchor
            })
            
            
    }
    
    
    var innerNode: some View {
        if store.selected == id {
            return AnyView(//NavigationLink(destination: NodeDetailView(id: id).environmentObject(store)) {
                Text(store[id].text)
            //TextField("XP", text: $store[id].text)
                    .font(.system(size: 16))
                    .fixedSize()
                    .padding(2)
                    .background(RoundedRectangle(cornerRadius: 4).stroke().foregroundColor(.blue))
                    /*.contextMenu() {
                        Button(action: {
                            store.delete(id: id)
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                    }*/
            )
        } else {
            /*let tap = TapGesture()
                .onEnded() { _ in
                    withAnimation {
                        //self.root.insert("new!", forID: self.node.id)
                        if self.store.selected != self.id {
                            self.store.selected = self.id
                        } else {
                            self.store.selected = UUID()
                        }
                    }
                }
            let doubleTap = TapGesture(count: 2)
                .onEnded() { _ in
                    _ = self.store.insert(Node(text: "new!"), forID: id)
                }
            let simultaneous = tap.simultaneously(with: doubleTap)
        
            */
            return AnyView(Text(store[id].text)
                .font(.system(size: 16))
                .fixedSize()
                .padding(2)
                //.gesture(simultaneous)
                /*.onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                    withAnimation {
                        //self.root.insert("new!", forID: self.node.id)
                        if self.store.selected != self.id {
                            self.store.selected = self.id
                        } else {
                            self.store.selected = UUID()
                        }
                    }
                })*/)
        }

    }
}


class Node: /*Hashable,*/ Identifiable {
    static func == (lhs: Node, rhs: Node) -> Bool {
        lhs.id == rhs.id
    }
    
    var id = UUID()
    
    var text: String
    
    var children: [Node]?
    
    var shape: String?
    
    init(text: String) {
        self.text = text
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










