//
//  SegmentedPickerView.swift
//  BookShelf
//
//  Created by Ksenia on 17.11.2023.
//

import SwiftUI

struct SegmentedPickerView: View {

    @Binding public var selection: Int
        
        private let size: CGSize
        private let segmentLabels: [String]
        
        var body: some View {
            
            ZStack(alignment: .leading) {
                
                // # Background shape
                RoundedRectangle(cornerRadius: 50)
                    .stroke(Color.gray, lineWidth: 2)
                    .frame(width: size.width, height: size.height)
                    .foregroundColor(.red)
                    .opacity(0.6)
                
                // # Selection background
                RoundedRectangle(cornerRadius: 50)
                    .frame(width: segmentWidth(size), height: size.height - 6)
                    .foregroundColor(.blue)
                    .offset(x: calculateSegmentOffset(size) + 3)
                    .animation(Animation.easeInOut(duration: 0.5))
                
                // # Labels
                HStack(spacing: 0) {
                    ForEach(0..<segmentLabels.count) { idx in
                        SegmentLabel(title: segmentLabels[idx], width: segmentWidth(size), textColour: selection == idx ? Color.white : Color.black)
                            .onTapGesture {
                                selection = idx
                                print("\(idx)")
                            }
                    }
                }
            }
        }
        
        public init(selection: Binding<Int>, size: CGSize, segmentLabels: [String]) {
            self._selection = selection
            self.size = size
            self.segmentLabels = segmentLabels
        }
        
        /// Calculates the width of a segment
        private func segmentWidth(_ mainSize: CGSize) -> CGFloat {
            var width = (mainSize.width / CGFloat(segmentLabels.count) - 3)
            if width < 0 {
                width = 0
            }
            return width
        }
        
        /// Calculates the offset of a segment
        private func calculateSegmentOffset(_ mainSize: CGSize) -> CGFloat {
            segmentWidth(mainSize) * CGFloat(selection)
        }
}


struct SegmentedPickerView_Previews: PreviewProvider {
    static var previews: some View {
//        SegmentedPickerView(size: CGSize(width: UIScreen.main.bounds.width - 40, height: 48))
        SegmentedPickerView(selection: .constant(0), size: CGSize(width: 150, height: 70), segmentLabels: ["headphones", "text.alignleft" ])
    }
}


fileprivate struct SegmentLabel: View {
    
    let title: String
    let width: CGFloat
    let textColour: Color
    
    var body: some View {
        
        Image(systemName: title)
            .resizable()
            .frame(width: 24.0, height: 24.0)
            .bold()
            .frame(width: width)
            .foregroundColor(textColour)
            .contentShape(Rectangle())
    }
}
