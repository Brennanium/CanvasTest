//
//  TreeView.swift
//  CanvasTest
//
//  Created by Brennan Drew on 9/1/20.
//

import SwiftUI

struct TreeView: View {
    var tree: Node
    @Binding var root: Node
    
    @State var avgPosition: CGFloat? = nil
    
    //@Binding var horizontalPadding: CGFloat
    @EnvironmentObject var store: ObservedVariables
    
    var body: some View {
        VStack(alignment: .leading) {
            NodeWrapperView(node: tree, root: $root)
                .alignmentGuide(HorizontalAlignment.leading, computeValue: { dimension in
                    -(avgPosition ?? dimension.width/2.0) + dimension.width/2.0
                })
                /*
                //.read(rightColumnWidth)
                //.frame(width: width)*/
                
                .padding(.vertical, 7/2)
                .padding(.horizontal, store.horizontalPadding/2)
                
            //Text("\(avgPosition ?? 0)").font(.system(size: 8))
            if(tree.children != nil){
                HStack(alignment: .top, spacing: 10) {
                    ForEach(tree.children!) { child in
                        TreeView(tree: child, root: $root)
                            //.read(rightColumnWidth)
                            //.frame(width: width)
                    }
                }
            }
        }
        .backgroundPreferenceValue(NodePositionsPreferenceKey.self) { preference -> GeometryReader<AnyView> in
            GeometryReader { geometry -> AnyView in
                
                if(self.tree.children != nil){
                    
                    DispatchQueue.main.async {
                        var sum: CGFloat = 0
                        
                        self.tree.children!.forEach({ child in
                            sum += geometry[preference[child.id]!.top!].x
                        })
                        
                        self.avgPosition = sum/CGFloat(self.tree.children!.count)
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
                if(self.tree.children != nil){
                    ForEach(self.tree.children!, id: \.id, content: { child in
                        Line(
                            from: geometry[preference[self.tree.id]!.bottom!],
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
