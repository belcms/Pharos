//
//  AppBackground.swift
//  ssc26 Bel
//
//  Created by Isabel Cristina Marras Salles on 26/02/26.
//

import SwiftUI

struct AppBackground: View {
    var body: some View {
        ZStack {
            Color("Background").opacity(0.7)
            
            RadialGradient(
                colors: [Color.white.opacity(0.2), Color.clear],
                center: .topLeading,
                startRadius: 0,
                endRadius: 600
            )
        }
        .ignoresSafeArea()
    }
}
