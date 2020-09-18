//
//  Model.swift
//  CanvasTest
//
//  Created by Brennan Drew on 8/10/20.
//

import SwiftUI


/*let sampleData =
Node(text: "TP", children: [
    Node(text: "0"),
    Node(text: "T'", children:
        [Node(text: "T"),
        Node(text: "VP", children:
            [Node(text: "NP"),
             Node(text: "V'", children:
                    [Node(text: "run")])])])
])*/

/*let sampleData2 =
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
])*/

struct MainView: View {
    
    @StateObject var store = ObservedVariables()
    
    var body: some View {
        NavigationView {
            VStack {
                /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
                    .navigationBarItems(trailing:
                        NavigationLink(destination:
                            store.selected != nil ?
                               AnyView(NodeDetailView(id: store.selected!).environmentObject(store))
                               :
                               AnyView(EmptyView())
                            )
                        {
                            Image(systemName: "info.circle")
                        }.disabled(store.selected == nil)
                    )
                Slider(value: $store.horizontalPadding, in: 0...15).padding()
                RootView(store: store)

                Button("Example Tree"){
                    self.store.testTree()
                    
                }
            }.navigationTitle("Test")
        }
    }
    
    
}


class ObservedVariables: ObservableObject {
    @Published var selected: UUID?
    @Published var horizontalPadding: CGFloat = 5
    
    @Published var nodes: [UUID:Node] = [:]
    @Published var root: UUID?
    
    subscript(id: UUID) -> Node {
        get {
            nodes[id]!
        }
        set {
            nodes.merge([newValue.id:newValue], uniquingKeysWith: { $1 })
        }
    }
    
    
    func insert(_ node: Node, forID id: UUID) -> UUID {
        nodes.merge([node.id:node], uniquingKeysWith: { $1 })
        if nodes[id]?.children != nil {
            nodes[id]!.children!.append(node)
        } else {
            nodes[id]?.children = [node]
        }
        
        
        return node.id
    }
    
    func delete(id: UUID) {
        guard let parentID = nodes.first(where: { key, value in
            value.children != nil && value.children!.contains(where: { $0.id == id })
        })?.key else {
            dealWithNodeIfNoParent(forID: id)
            nodes.removeValue(forKey: id)
            return
        }
        
        self[parentID].children!.removeAll(where: { $0.id == id })
        
        if self[id].children != nil {
            if self[parentID].children != nil {
                self[parentID].children!.append(contentsOf: self[id].children!)
            } else {
                self[parentID].children = self[id].children!
            }
        }
        
        nodes.removeValue(forKey: id)
        
    }
    
    private func dealWithNodeIfNoParent(forID id: UUID) {
        if self[id].children == nil {
            initTree()
            return
        }
        root = self[id].children!.first!.id
        
        self[id].children!.remove(at: 0)
        
        if self[id].children != nil && self[id].children!.count != 0 {
            //move children of deleting node to new root
            if self[root!].children != nil {
                self[root!].children!.append(contentsOf: self[id].children!)
            } else {
                self[root!].children = self[id].children!
            }
            
        }
    }
    
    func testTree(){
        let labels = ["TP","O","T'","T","VP","NP","V'","run"]
        let nodeArray = labels.map({
            Node(text: $0)
        })
        
        root = nodeArray[0].id
        
        nodeArray[0].children = [nodeArray[1],nodeArray[2]]
        nodeArray[2].children = [nodeArray[3],nodeArray[4]]
        nodeArray[4].children = [nodeArray[5],nodeArray[6]]
        nodeArray[6].children = [nodeArray[7]]
        
        nodes = Dictionary(uniqueKeysWithValues: nodeArray.map { ($0.id,$0) })
    }
    
    func initTree() {
        let newNode = Node(text: "XP")
        
        root = newNode.id
        
        nodes = [newNode.id:newNode]
    }
    
    init() {
        testTree()
        /*
        let node1 = Node(text: "root")
        let node2 = Node(text: "new!")
        let node3 = Node(text: "new!")
        node1.children = [node2,node3]
        nodes.merge([node1.id:node1], uniquingKeysWith: { $1 })
        nodes.merge([node2.id:node2], uniquingKeysWith: { $1 })
        nodes.merge([node3.id:node3], uniquingKeysWith: { $1 })
        
        root = node1.id*/
    }
}



struct Model_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
