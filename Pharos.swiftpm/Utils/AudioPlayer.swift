//
//  AudioPlayer.swift
//  ssc26 Bel
//
//  Created by Isabel Cristina Marras Salles on 12/02/26.
//

import AVFoundation
import SwiftUI

class AudioPlayer: ObservableObject {
    private var player: AVAudioPlayer?
    
    @Published var isPlaying: Bool = false
    
    func startAudio(fileName: String, fileType: String = "mp3"){
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileType) else { return }
        do{
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1
            player?.volume = 0.1
            player?.play()
            isPlaying = true
        } catch{
            print("Error playing audio: \(error.localizedDescription)")
        }
    }
    
    func pause(){
        player?.pause()
        isPlaying = false
    }
    
    func resume(){
        player?.play()
        isPlaying = true
    }
    
    func stop(){
        player?.stop()
        isPlaying = false
    }
    
}
