//
//  MusicModal.swift
//  ssc26 Bel
//
//  Created by Isabel Cristina Marras Salles on 12/02/26.
//

import SwiftUI

struct MusicModal: View {
    var isPaused: Bool 
    var audioPlayer: AudioPlayer
    @Binding var musicSelected: String 
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack{
            HStack{
                MusicOption(title: "No sound", icon: "speaker.slash.fill", isSelected: musicSelected == "No sound"){
                    musicSelected = "No sound"
                    audioPlayer.stop()
                }
                MusicOption(title: "Rain", icon: "cloud.rain.fill", isSelected: musicSelected == "RainSong"){
                    musicSelected = "RainSong"
                    audioPlayer.startAudio(fileName: musicSelected)
                    if isPaused{
                        audioPlayer.pause()
                    }
                }
                MusicOption(title: "Nature", icon: "tree.fill", isSelected: musicSelected == "NatureSound"){
                    musicSelected = "NatureSound"
                    audioPlayer.startAudio(fileName: musicSelected)
                    if isPaused{
                        audioPlayer.pause()
                    }
                    
                }
                MusicOption(title: "Lo-fi", icon: "beats.headphones", isSelected: musicSelected == "LoFiSong"){
                    musicSelected = "LoFiSong"
                    audioPlayer.startAudio(fileName: musicSelected)
                    if isPaused{
                        audioPlayer.pause()
                    }
                }
                
                
            }.padding()
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction){
                Button(action:{
                    dismiss()
                }){
                    Image(systemName: "xmark")
                }
            }
        }
    }
}

