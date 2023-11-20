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
        WithViewStore(self.store, observe: { $0 } ) { viewStore in
            ScrollView(.vertical, showsIndicators: false) {
                VStack (alignment: .center, spacing: 8) {
                    bookCover
                    Text("Chapter \(viewStore.currentIndex + 1) of \(viewStore.chaptersCount)")
                        .font(.subheadline).bold()
                        .foregroundColor(.primary)
                        .opacity(0.5)
                    
                    Text(viewStore.chapterDescription)
                        .lineLimit(2)
                        .font(.subheadline)
                        .frame(height: 44)
                        .padding(.leading, 24)
                        .padding(.trailing, 24)
                        .multilineTextAlignment(.center)
                }
                
                
                HStack {
                    Text(formattedTime(viewStore.currentTime))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Slider(value: viewStore.binding(
                        get: {$0.currentTime},
                        send: BookPlayer.Action.sliderValueChanged
                    ), in: 0...viewStore.duration)
                        .padding(.horizontal)
                    Text(formattedTime(viewStore.duration))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
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
                viewStore.audioPlayer?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: DispatchQueue.main) { time in
                    let currentTime = time.seconds
                    viewStore.send(.onReceiveTimeUpdate(currentTime))
                }
            }
        }
        .background(Color("Background"))
        
    }
}

extension BookPlayerView {
    var bookCover: some View {
            VStack (alignment: .center, spacing: 8) {
                Image("BookCover")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(20)
                    .clipped()
                    .aspectRatio(1.1, contentMode: .fit)
                    .padding(.bottom, 24)
                    .padding(.leading, 48)
                    .padding(.trailing, 48)
                    .padding(.top, 20)
                
            }
            .padding(.top)
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

private func formattedTime(_ time: TimeInterval) -> String {
    let minutes = Int(time) / 60
    let seconds = Int(time) % 60
    return String(format: "%02d:%02d", minutes, seconds)
}
