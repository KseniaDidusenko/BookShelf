//
//  DescriptionView.swift
//  BookShelf
//
//  Created by Ksenia on 16.11.2023.
//

import SwiftUI

struct DescriptionView: View {
    
    @State var text: String = "Multiline \ntext \nis called \nTextEditor"
    
    var body: some View {
        TextField("Title", text: $text,  axis: .vertical)
            .lineLimit(5...100)
            .font(.subheadline).bold()
            .foregroundColor(.primary)
            .padding(.bottom, 2)
            .padding(.leading, 8)
            .padding(.trailing, 8)
    }
}

struct DescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        DescriptionView()
    }
}
