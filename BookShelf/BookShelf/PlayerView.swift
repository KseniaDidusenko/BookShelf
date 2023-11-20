//
//  PlayerView.swift
//  BookShelf
//
//  Created by Ksenia on 16.11.2023.
//

import ComposableArchitecture
import SwiftUI

// MARK: - Reducer
struct Player: Reducer {    
    struct State: Equatable, Identifiable {
        
        var keyPoint: String
        var description: String
        var duration: TimeInterval
        var mode = Mode.notPlaying
        var url: URL
        
        var id: URL { self.url }
        
        enum Mode: Equatable {
            case notPlaying
            case playing(progress: Double)
            
            var isPlaying: Bool {
                if case .playing = self { return true }
                return false
            }
            
            var progress: Double? {
                if case let .playing(progress) = self { return progress }
                return nil
            }
        }
    }
    
    enum Action: Equatable {
        
        case audioPlayerClient(TaskResult<Bool>)
        case delegate(Delegate)
        case playButtonTapped
        case timerUpdated(TimeInterval)
        
        enum Delegate {
            case playbackStarted
            case playbackFailed
        }
    }
    
    @Dependency(\.audioPlayer) var audioPlayer
    @Dependency(\.continuousClock) var clock
    private enum CancelID { case play }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .audioPlayerClient(.failure):
            state.mode = .notPlaying
            return .merge(
                .cancel(id: CancelID.play),
                .send(.delegate(.playbackFailed))
            )
            
        case .audioPlayerClient:
            state.mode = .notPlaying
            return .cancel(id: CancelID.play)
            
        case .delegate:
            return .none
            
        case .playButtonTapped:
            switch state.mode {
            case .notPlaying:
                state.mode = .playing(progress: 0)
                
                return .run { [url = state.url] send in
                    await send(.delegate(.playbackStarted))
                    
                    async let playAudio: Void = send(
                        .audioPlayerClient(TaskResult { try await self.audioPlayer.play(url) })
                    )
                    
                    var start: TimeInterval = 0
                    for await _ in self.clock.timer(interval: .milliseconds(500)) {
                        start += 0.5
                        await send(.timerUpdated(start))
                    }
                    
                    await playAudio
                }
                .cancellable(id: CancelID.play, cancelInFlight: true)
                
            case .playing:
                state.mode = .notPlaying
                return .cancel(id: CancelID.play)
            }
            
        case let .timerUpdated(time):
            switch state.mode {
            case .notPlaying:
                break
            case .playing:
                state.mode = .playing(progress: time / state.duration)
            }
            return .none
        }
    }
}

struct PlayerView: View {
    let store: StoreOf<Player>
    @State private var sliderValue: Double = .zero
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            let currentTime =
                          viewStore.mode.progress.map { $0 * viewStore.duration } ?? viewStore.duration
                        ScrollView(.vertical, showsIndicators: false) {
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
                                dateComponentsFormatter.string(from: currentTime).map {
                                  Text($0)
                                        .font(.subheadline).bold()
                                        .foregroundColor(.gray)
            //                        .font(.footnote.monospacedDigit())
            //                        .foregroundColor(Color(.systemGray))
                                }
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
                                        viewStore.send(.playButtonTapped)
                                    } label: {
                                        Image(systemName: viewStore.mode.isPlaying ? "pause.fill" : "play.fill")
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
}
