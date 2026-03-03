//
//  VideoPlayer.swift
//  ssc26 Bel
//
//  Created by Isabel Cristina Marras Salles on 23/02/26.
//

import AVFoundation
import AVKit
import SwiftUI

struct VideoView: UIViewRepresentable {
    let videoName: String
    let videoType: String
    
    func makeUIView(context: Context) -> UIView {
        return PlayerUIView(videoName: videoName, videoType: videoType)
    }
    
    func updateUIView(_ uiView: UIView, context: Context) { }
    
    
}

class PlayerUIView: UIView {
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
    init(videoName: String, videoType: String) {
        super.init(frame: .zero)
        
        backgroundColor = .clear
        
        guard let path = Bundle.main.path(forResource: videoName, ofType: videoType) else {
            return
        }
        
        let url = URL(fileURLWithPath: path)
        let player = AVPlayer(url: url)
        self.player = player
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.backgroundColor = UIColor.clear.cgColor
        self.layer.addSublayer(playerLayer)
        self.playerLayer = playerLayer
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(restartVideo),
            name: AVPlayerItem.didPlayToEndTimeNotification,
            object: player.currentItem
        )
        
        player.isMuted = true
        player.play()
    }
    
    @objc private func restartVideo() {
        player?.seek(to: .zero)
        player?.play()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
}
