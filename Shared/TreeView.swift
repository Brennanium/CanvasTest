//
//  TreeView.swift
//  CanvasTest
//
//  Created by Brennan Drew on 9/1/20.
//

import SwiftUI

struct TreeView: View {
    var id: UUID
    
    //@Binding var root: Node
    
    @State var avgPosition: CGFloat? = nil
    
    //@Binding var horizontalPadding: CGFloat
    @EnvironmentObject var store: ObservedVariables
    
    var body: some View {
        VStack(alignment: .leading) {
            
            NodeView(id: id)
            
                .alignmentGuide(HorizontalAlignment.leading, computeValue: { dimension in
                    -(avgPosition ?? dimension.width/2.0) + dimension.width/2.0
                })
                .padding(.vertical, 7/2)
                .padding(.horizontal, store.horizontalPadding/2)
                
            
            //Text("\(avgPosition ?? 0)").font(.system(size: 8))
            if(store[id].children != nil){
                HStack(alignment: .top, spacing: 10) {
                    ForEach(store[id].children!) { node in
                        //DraggableView() {
                            TreeView(id: node.id)
                        //}
                    }
                }
            }
        }
        .backgroundPreferenceValue(NodePositionsPreferenceKey.self) { preference -> GeometryReader<AnyView> in
            GeometryReader { geometry -> AnyView in
                
                if(store[id].children != nil){
                    
                    DispatchQueue.main.async {
                        var sum: CGFloat = 0
                        
                        store[id].children!.forEach({ child in
                            sum += geometry[preference[child.id]!.top!].x
                        })
                        
                        self.avgPosition = sum/CGFloat(store[id].children!.count)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.avgPosition = geometry.size.width/2
                    }
                }
                
                return AnyView(EmptyView())
            }
        }
        .backgroundPreferenceValue(NodePositionsPreferenceKey.self) { preference in
            GeometryReader { geometry in
                if(store[id].children != nil){
                    ForEach(store[id].children!, id: \.id, content: { child in
                        Line(
                            from: geometry[preference[id]!.bottom!],
                            to: geometry[preference[child.id]!.top!]
                        ).stroke()
                    })
                }
            }
        }
    }
}



struct TreeView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello World")//TreeView()
    }
}
