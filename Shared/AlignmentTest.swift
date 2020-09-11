//
//  AlignmentTest.swift
//  CanvasTest
//
//  Created by Brennan Drew on 8/16/20.
//

import SwiftUI

struct AlignmentTestView: View {
    var body: some View {
        ZStack(alignment: .myAlignment) {
           Rectangle()
                .foregroundColor(Color.green)
                .alignmentGuide(HorizontalAlignment.myAlignment)
                                   { d in d[.trailing]}
                .alignmentGuide(VerticalAlignment.myAlignment)
                                   { d in d[VerticalAlignment.bottom] }
                .frame(width: 100, height: 100)

           Rectangle()
                .foregroundColor(Color.red)
                .alignmentGuide(VerticalAlignment.myAlignment)
                                   { d in d[VerticalAlignment.top] }
                .alignmentGuide(HorizontalAlignment.myAlignment)
                                   { d in d[HorizontalAlignment.center] }
                .frame(width: 100, height: 100)

            Circle()
                .foregroundColor(Color.orange)
                .alignmentGuide(HorizontalAlignment.myAlignment)
                                   { d in d[.leading] }
                .alignmentGuide(VerticalAlignment.myAlignment)
                                   { d in d[.bottom] }
                .frame(width: 100, height: 100)
        }
    }
}


extension HorizontalAlignment {
  
    enum MyHorizontal: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat
                 { d[HorizontalAlignment.center] }
    }

    static let myAlignment =
                 HorizontalAlignment(MyHorizontal.self)
}

extension VerticalAlignment {
    enum MyVertical: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat
                 { d[VerticalAlignment.center] }
    }
  
    static let myAlignment = VerticalAlignment(MyVertical.self)
}

extension Alignment {
    static let myAlignment = Alignment(horizontal: .myAlignment,
                               vertical: .myAlignment)
}












struct RoundedCircleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 20, height: 20)
            .background(Circle().stroke())
            .background(Circle().fill(Color.white))
            .padding(2)
    }
}


//equal width code
struct GeometryPreferenceReader<K: PreferenceKey, V> where K.Value == V {
    let key: K.Type
    let value: (GeometryProxy) -> V
}

extension GeometryPreferenceReader: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(GeometryReader {
                Color.clear.preference(key: self.key,
                                       value: self.value($0))
            })
    }
}

protocol Preference {}

struct AppendValue<T: Preference>: PreferenceKey {
    static var defaultValue: [CGFloat] { [] }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.append(contentsOf: nextValue())
    }
    typealias Value = [CGFloat]
}

extension View {
    func assignMaxPreference<K: PreferenceKey>(
        for key: K.Type,
        to binding: Binding<CGFloat?>) -> some View where K.Value == [CGFloat] {

        return self.onPreferenceChange(key.self) { prefs in
            let maxPref = prefs.reduce(0, max)
            if maxPref > 0 {
                // only set value if > 0 to avoid pinning sizes to zero
                binding.wrappedValue = maxPref
            }
        }
    }

    func read<K: PreferenceKey, V>(_ preference: GeometryPreferenceReader<K, V>) -> some View {
        modifier(preference)
    }
}









struct AlignmentTest_Previews: PreviewProvider {
    static var previews: some View {
        AlignmentTestView()
    }
}
