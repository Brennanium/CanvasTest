//
//  DraggableView.swift
//  CanvasTest
//
//  Created by Brennan Drew on 9/17/20.
//

import SwiftUI

enum DragState {
    case inactive
    case pressing
    case dragging(translation: CGSize)
 
    var translation: CGSize {
        switch self {
        case .inactive, .pressing:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
 
    var isPressing: Bool {
        switch self {
        case .pressing, .dragging:
            return true
        case .inactive:
            return false
        }
    }
}
 
struct DraggableView<Content>: View where Content: View {
    @GestureState private var dragState = DragState.inactive
    @State private var position = CGSize.zero
 
    var content: () -> Content
 
    var body: some View {
        content()
            .opacity(dragState.isPressing ? 0.5 : 1.0)
            .offset(x: position.width + dragState.translation.width, y: position.height + dragState.translation.height)
            .animation(.easeInOut)
            .gesture(
                LongPressGesture(minimumDuration: 1.0)
                .sequenced(before: DragGesture())
                .updating($dragState, body: { (value, state, transaction) in
 
                    switch value {
                    case .first(true):
                        state = .pressing
                    case .second(true, let drag):
                        state = .dragging(translation: drag?.translation ?? .zero)
                    default:
                        break
                    }
 
                })
                .onEnded({ (value) in
 
                    guard case .second(true, let drag?) = value else {
                        return
                    }
 
                    self.position.height += drag.translation.height
                    self.position.width += drag.translation.width
                })
            )
    }
}

struct DraggableView_Previews: PreviewProvider {
    static var previews: some View {
        DraggableView() {
            Circle()
                .frame(width: 100, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
        }
    }
}
