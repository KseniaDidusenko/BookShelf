//
//  BookPlayerReducer.swift
//  BookShelf
//
//  Created by Ksenia on 19.11.2023.
//

import AVFoundation
import ComposableArchitecture
import Foundation

struct BookPlayer: Reducer {
    
    struct State: Equatable {
        //        @BindingState var switchMode
        //        @PresentationState var alert: AlertState<AlertAction>?
        //        var player: Player.State
        var book: Book
        //        var keyPoint: String
        var audioPlayer: AVPlayer?
        var isPlaying: Bool = false
        var currentTime: TimeInterval = 0
        var chaptersItems: [URL] = []
        var currentIndex = 0
        var isNextButtonDisable = false
        var isPreviousButtonDisable = true
        var rate = Rate.one
        var nextRate = Rate.one
        
        
        enum Rate: Float {
            case one = 1
            case onePoint25 = 1.25
            case onePoint5 = 1.5
            case two = 2
        }
    }
    
    
    enum Action {
        //        case alert(PresentationAction<AlertAction>)
        case playButtonTapped
        case setupPlayer
        case fastForward
        case fastBackward
        case nextTrack
        case previousTrack
        case changeRate
    }
    
    //    @Dependency(\.audioPlayer) var audioPlayer
    //    @Dependency(\.continuousClock) var clock
    //    private enum CancelID { case play }
    //    enum AlertAction: Equatable {}
    
    private func nextPrevButtonEnabling(
        state: inout State
    ) -> Effect<Action> {
        state.isNextButtonDisable = state.currentIndex == state.chaptersItems.count - 1
        state.isPreviousButtonDisable = state.currentIndex == 0
        return .none
    }
    
    private func restartRate(
        state: inout State
    ) -> Effect<Action> {
        
        return .none
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .playButtonTapped:
                if state.isPlaying {
                    state.audioPlayer?.pause()
                    state.isPlaying = false
                } else {
                    state.audioPlayer?.play()
                    state.isPlaying = true
                }
                return .none
                
            case .setupPlayer:
                setupPlayer(&state)
                
                

//                    state.audioPlayer?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 10), queue: nil) {[state] time in
//                        guard let item = state.audioPlayer?.currentTime else{
//                            return
//                        }
//                        print(item)
////                        state.currentTime = item.tim
//        //
//        //                self.seekPos = time.seconds / item.duration.seconds
//                    }
//
//                    // Set end time for updating UI when the track finishes
//                    if let duration = state.audioPlayer?.currentItem?.duration.seconds, duration.isFinite {
//                        state.currentTime = duration
//                    }
//
                
                return .none
            case .fastForward:
                fastForward(&state)
                return .none
            case .fastBackward:
                fastBackward(&state)
                return .none
            case .nextTrack:
                if state.currentIndex < state.chaptersItems.count - 1 {
                    state.currentIndex += 1
                    state.audioPlayer = AVPlayer(url: state.chaptersItems[state.currentIndex])
                    state.audioPlayer?.play()
                    state.isPlaying = true
                }
                return nextPrevButtonEnabling(state: &state)
            case .previousTrack:
                if state.currentIndex != 0 {
                    state.currentIndex -= 1
                    state.audioPlayer = AVPlayer(url: state.chaptersItems[state.currentIndex])
                    state.audioPlayer?.play()
                    state.isPlaying = true
                }
                return nextPrevButtonEnabling(state: &state)
            case .changeRate:
                switch state.rate {
                case .one:
                    state.audioPlayer?.playImmediately(
                        atRate: BookPlayer.State.Rate.onePoint25.rawValue
                    )
                    state.rate = .onePoint25
                case .onePoint25:
                    state.audioPlayer?.playImmediately(
                        atRate: BookPlayer.State.Rate.onePoint5.rawValue
                    )
                    state.rate = .onePoint5
                case .onePoint5:
                    state.audioPlayer?.playImmediately(
                        atRate: BookPlayer.State.Rate.two.rawValue
                    )
                    state.rate = .two
                case .two:
                    state.audioPlayer?.playImmediately(
                        atRate: BookPlayer.State.Rate.one.rawValue
                    )
                    state.rate = .one
                    
//                    return restartRate(state: &state)
                }
                return .none
            }
            
        }
    }
    
    func setupPlayer(_ state: inout State) {
        for name in state.book.chaptersNames {
            
            if let path = Bundle.main.path(forResource: name, ofType: "mp3") {
                let url = URL(fileURLWithPath: path)
                state.chaptersItems.append(url)
            }
        }
        state.audioPlayer = AVPlayer(url: state.chaptersItems.first!)
    }
    
    func seek(to value: Double, _ state: inout State) {
        let time = CMTime(seconds: value, preferredTimescale: 1000)
        state.audioPlayer?.seek(to: time)
    }
    
    func fastForward(_ state: inout State) {
        
        var time: TimeInterval = state.audioPlayer?.currentTime().seconds ?? 0.0
        time += 10.0
        if state.audioPlayer?.currentItem?.currentTime() == state.audioPlayer?.currentItem?.duration {
            return
        }
        
        seek(to: time, &state)
    }
    
    func fastBackward(_ state: inout State) {
        
        var time: TimeInterval = state.audioPlayer?.currentTime().seconds ?? 0.0
        time -= 5.0
        if state.audioPlayer?.currentItem?.currentTime() == .zero {
            return
        }
        
        seek(to: time, &state)

    }
    
    func nextTrack(_ state: inout State) {
    }
    
    func previousTrack() {
        
    }
    
}

 func formattedTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
