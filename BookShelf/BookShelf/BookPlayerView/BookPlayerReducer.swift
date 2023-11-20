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
        var book: Book
        var audioPlayer: AVQueuePlayer?
        var isPlaying: Bool = false
        var currentTime: TimeInterval = 0
        var chaptersItems: [AVPlayerItem] = []
        var currentIndex = 0
        var isNextButtonDisable = false
        var isPreviousButtonDisable = true
        var rate = Rate.one
        var duration: TimeInterval = 0
        var chapterDescription = ""
        var chaptersCount = 0
        
        enum Rate: Float {
            case one = 1
            case onePoint25 = 1.25
            case onePoint5 = 1.5
            case two = 2
        }
    }
    
    enum Action {
        case playButtonTapped
        case setupPlayer
        case fastForward
        case fastBackward
        case nextTrack
        case previousTrack
        case changeRate
        case changeTimeInterval
        case onReceiveTimeUpdate(TimeInterval)
        case sliderValueChanged(Double)
    }
    
    private func nextPrevButtonEnabling(
        state: inout State
    ) -> Effect<Action> {
        state.isNextButtonDisable = state.currentIndex == state.chaptersItems.count - 1
        state.isPreviousButtonDisable = state.currentIndex == 0
        return .none
    }
    
    enum PlayerError: Error {
        case resourceNotFound
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .playButtonTapped:
                if state.isPlaying {
                    state.audioPlayer?.pause()
                    state.isPlaying = false
                } else {
                    state.audioPlayer?.playImmediately(atRate: state.rate.rawValue)
                    state.isPlaying = true
                }
                return .none
                
            case .setupPlayer:
                do {
                    try setupPlayer(&state)
                } catch {
                    print("Error loading chapters: Resource not found")
                }
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
                    play(index: state.currentIndex, &state)
                }
                return nextPrevButtonEnabling(state: &state)
            case .previousTrack:
                if state.currentIndex != 0 {
                    state.currentIndex -= 1
                    play(index: state.currentIndex, &state)
                }
                return nextPrevButtonEnabling(state: &state)
            case .changeRate:
                switch state.rate {
                case .one:
                    state.audioPlayer?.playImmediately(
                        atRate: BookPlayer.State.Rate.onePoint25.rawValue
                    )
                    state.isPlaying = true
                    state.rate = .onePoint25
                case .onePoint25:
                    state.audioPlayer?.playImmediately(
                        atRate: BookPlayer.State.Rate.onePoint5.rawValue
                    )
                    state.isPlaying = true
                    state.rate = .onePoint5
                case .onePoint5:
                    state.audioPlayer?.playImmediately(
                        atRate: BookPlayer.State.Rate.two.rawValue
                    )
                    state.isPlaying = true
                    state.rate = .two
                case .two:
                    state.audioPlayer?.playImmediately(
                        atRate: BookPlayer.State.Rate.one.rawValue
                    )
                    state.isPlaying = true
                    state.rate = .one
                }
                return .none
            case .changeTimeInterval:
                return .none
                
            case .onReceiveTimeUpdate(let currentTime):
                state.currentTime = currentTime
                return .none
                
            case .sliderValueChanged(let time):
                state.currentTime = time
                seek(to: time, &state)
                return .none
            }
        }
    }
    
    func play(index: Int, _ state: inout State) {
        state.audioPlayer?.removeAllItems()
        let playerItem = state.chaptersItems[index]
        playerItem.seek(to: CMTime.zero)
        state.audioPlayer?.insert(playerItem, after: nil)
        state.duration = state.audioPlayer?.currentItem?.asset.duration.seconds ?? 0
        state.chapterDescription = state.book.chaptersDescription[index]
    }
    
    func setupPlayer(_ state: inout State) throws {
        for name in state.book.chaptersNames {
            do {
                guard let path = Bundle.main.path(forResource: name, ofType: "mp3") else {
                    throw PlayerError.resourceNotFound
                }
                let url = URL(fileURLWithPath: path)
                let playerItem = AVPlayerItem(url: url)
                state.chaptersItems.append(playerItem)
            }
        }
        state.audioPlayer = AVQueuePlayer(items: state.chaptersItems)
        state.chaptersCount = state.chaptersItems.count
        state.chapterDescription = state.book.chaptersDescription.first ?? ""
        state.duration = state.audioPlayer?.currentItem?.asset.duration.seconds ?? 0
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
}
