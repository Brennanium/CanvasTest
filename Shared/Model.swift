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
                Text("Hello, World!")
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
                Text("parent: \(store.selected != nil ? (store.parent(ofID: store.selected!) != nil ? store.parent(ofID: store.selected!)!.text : "") : "")")
                Text("child: \(store.selected != nil ? store.nodeByID(store.selected!)?.text ?? "" : "")")
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
    
    var rootNode: Node? {
        get { root != nil ? nodes[root!] : nil }
    }
    
    subscript(id: UUID) -> Node {
        get {
            nodes[id]!
        }
        set {
            nodes.merge([newValue.id:newValue], uniquingKeysWith: { $1 })
        }
    }
    
    func nodeByID(_ id: UUID) -> Node? {
        return nodes[id]
    }
    
    func isValidID(_ id: UUID) -> Bool {
        return nodeByID(id) != nil
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
        func node() -> Node? {
            self.nodeByID(id)
        }
        
        guard let parentID = findParentID(forID: id) else {
            dealWithNodeIfNoParent(forID: id)
            nodes.removeValue(forKey: id)
            return
        }
        
        self[parentID].children!.removeAll(where: { $0.id == id })
        
        
        if node()?.children != nil {
            if self[parentID].children != nil {
                self[parentID].children!.append(contentsOf: node()!.children!)
            } else {
                self[parentID].children = node()!.children!
            }
        }
        
        nodes.removeValue(forKey: id)
        
    }
    
    private func findParentID(forID id: UUID) -> UUID? {
        return nodes.first(where: { key, value in
            value.children != nil && value.children!.contains(where: { $0.id == id })
        })?.key
    }
    
    func parent(ofID id: UUID) -> Node? {
        let parentID = findParentID(forID: id)
        
        return parentID != nil ? nodes[parentID!] : nil
    }
    
    private func dealWithNodeIfNoParent(forID id: UUID) {
        func node() -> Node? {
            self.nodeByID(id)
        }
        
        guard node()?.children != nil else {
            initTree()
            return
        }
        root = node()!.children!.first!.id
        
        node()?.children!.remove(at: 0)
        
        if node()?.children != nil && node()!.children!.count != 0 {
            //move children of deleting node to new root
            if rootNode!.children != nil {
                rootNode!.children!.append(contentsOf: node()!.children!)
            } else {
                rootNode!.children = node()!.children!
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
