//
//  PlayerView.swift
//  BookShelf
//
//  Created by Ksenia on 16.11.2023.
//

import SwiftUI

struct PlayerView: View {
    @State private var sliderValue: Double = .zero
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                player
                playerControls
            }
        }
    }
}

extension PlayerView {
    var player: some View {
        VStack (alignment: .center, spacing: 16) {
            Text("KEY POINT 2 OF 10")
                .font(.subheadline).bold()
                .foregroundColor(.primary)
                .opacity(0.5)
            
            Text("Design is not how a thing looks, but how it works")
                .lineLimit(1...100)
                .font(.subheadline)
                .padding(.leading, 24)
                .padding(.trailing, 24)
                .padding(.bottom)
        }
        .padding(.top)
    }
    
    var playerControls: some View {
        VStack {
            
            HStack{
                Text("00:29")
                    .font(.subheadline).bold()
                    .foregroundColor(.gray)
                Slider(value: $sliderValue, in: 0...100)
                    .padding(.horizontal)
                    .gesture(DragGesture()
                        .onChanged({ (value) in
                            
                        })
                            .onEnded({ (value) in
                                print("Ended in \(value)")
                                
                            })
                    )
                Text("02:04:43")
                    .font(.subheadline).bold()
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
            
            Button {

                print("toPreviousChapter")
            } label: {
                Text("Speed x1")
                    .padding(.horizontal, 8)
                
                    .frame(height: 44)
                
                    .foregroundColor(.black)
                    .background(Color("lightGray"))
                    .cornerRadius(8)
            }
            .padding(.top, 10)
            
            
            HStack {
                Group {
                    Button {

                    } label: {
                        Image(systemName: "backward.end.fill")
                            .padding(.horizontal, 15)
                    }
                    Button {

                    } label: {
                        Image(systemName: "gobackward.5")
                        
                    }
                    Button {

                    } label: {
                        Image(systemName: "play.fill")
                            .frame(height: 50)
                            .font(.system(size: 47))
                            .padding(.horizontal, 15)

                    }
                    Button {

                    } label: {
                        Image(systemName: "goforward.10")
                    }
                    Button {

                    } label: {
                        Image(systemName: "forward.end.fill")
                            .padding(.horizontal, 15)
                    }
                }
                .font(.system(size: 34))
                .foregroundStyle(.primary)
            }
            .padding(.top, 30)
            .padding(.bottom, 60)
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
    }
}
