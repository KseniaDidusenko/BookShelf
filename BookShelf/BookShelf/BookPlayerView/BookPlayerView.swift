//
//  BookPlayerView.swift
//  BookShelf
//
//  Created by Ksenia on 15.11.2023.
//

import AVFoundation
import ComposableArchitecture
import SwiftUI



struct BookPlayerView: View {
    
    @State private var sliderValue: Double = .zero
    @State var preselectedIndex = 0
    
    
    let store: StoreOf<BookPlayer>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ScrollView(.vertical, showsIndicators: false) {
                
                
                bookCover
                VStack (alignment: .center, spacing: 16) {
                    Text(viewStore.book.name)
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
                
                
                HStack{
                    Text(formattedTime(viewStore.currentTime))
                        .font(.subheadline)
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
//                    dateComponentsFormatter.string(from: currentTime).map {
                        Text("02:33")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        //                        .font(.footnote.monospacedDigit())
                        //                        .foregroundColor(Color(.systemGray))
//                    }
                }
                .padding(.horizontal)
                
                Button {
                    viewStore.send(.changeRate)
                } label: {
                    Text("Speed x\(viewStore.rate.rawValue.formatted())")
                        .bold()
                        .padding(.horizontal, 8)
                    
                        .frame(width: 120, height: 44)
                        
                        .foregroundColor(.black)
                        .background(Color("lightGray"))
                        .cornerRadius(8)
                }
                .padding(.top, 10)
                
                
                HStack {
                    Group {
                        Button {
                            viewStore.send(.previousTrack)
                        } label: {
                            Image(systemName: "backward.end.fill")
                                .padding(.horizontal, 15)
                                .foregroundColor(
                                    viewStore.isPreviousButtonDisable
                                    ? .gray
                                    : .black
                                )
                        }
                        .disabled(viewStore.isPreviousButtonDisable)
                        Button {
                            viewStore.send(.fastBackward)
                        } label: {
                            Image(systemName: "gobackward.5")
                            
                        }
                        Button {
                            viewStore.send(.playButtonTapped)
                        } label: {
                            Image(systemName: viewStore.isPlaying ? "pause.fill" : "play.fill")
                                .frame(height: 50)
                                .font(.system(size: 47))
                                .padding(.horizontal, 15)
                            
                        }
                        Button {
                            viewStore.send(.fastForward)
                        } label: {
                            Image(systemName: "goforward.10")
                        }
                        Button {
                            viewStore.send(.nextTrack)
                        } label: {
                            Image(systemName: "forward.end.fill")
                                .padding(.horizontal, 15)
                                .foregroundColor(
                                    viewStore.isNextButtonDisable
                                    ? .gray
                                    : .black
                                )
                        }
                        .disabled(viewStore.isNextButtonDisable)
                    }
                    .font(.system(size: 34))
                    .foregroundStyle(.primary)
                }
                .padding(.top, 30)
                .padding(.bottom, 60)
                
                switchMode
            }
            .onAppear() {
                viewStore.send(.setupPlayer)
            }
            .onReceive(viewStore.publisher) { state in
                            // Update UI based on state changes
//                            viewStore.currentTime = state.audioPlayer?.currentTime ?? 0
                print(state)
                        }
            
        
            }
        
        //        alert(store: self.store.scope(state: \.$alert, action: { .alert($0) }))
        .background(Color("Background"))

    }
    
}

extension BookPlayerView {
    var bookCover: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            
            VStack (alignment: .center, spacing: 8) {
                Image("BookCover")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(20)
                    .clipped()
                    .aspectRatio(1, contentMode: .fit)
                //                .frame(width: 360, height: 300)
                    .padding(.bottom, 24)
                    .padding(.leading, 48)
                    .padding(.trailing, 48)
                    .padding(.top, 20)
                //                .clipShape(RoundedRectangle(cornerRadius: 40))
                //                .overlay(RoundedRectangle(cornerRadius: 10))
                
            }
            .padding(.top)
        }
    }
    
    var switchMode: some View {
        SegmentedPickerView(
            selection: $preselectedIndex,
            size: CGSize(width: 150, height: 70),
            segmentLabels: ["headphones", "text.alignleft" ]
        )
        .padding(.bottom, 10)
    }
}

struct BookPlayerView_Previews: PreviewProvider {
        static var previews: some View {
            BookPlayerView(store: Store(initialState: BookPlayer.State(book: Book.mock), reducer: {
                BookPlayer()
            }))
    }
}
