//
//  MusicOption.swift
//  ssc26 Bel
//
//  Created by Isabel Cristina Marras Salles on 17/02/26.
//

import SwiftUI

struct MusicOption: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    
    var body: some View {
        Button(action: action){
            VStack{
                ZStack{
                    Circle()
                        .fill(isSelected ? .regularMaterial : .ultraThinMaterial)
                        .frame(width: 60, height: 60)
                    Image(systemName: icon)
                        .foregroundStyle(isSelected ? Color("AccentColor"): .secondary)
                }
                Text(title)
                    .foregroundStyle(isSelected ?  Color("AccentColor") : .secondary)
                    .font(.subheadline)
            }
        }.buttonStyle(.plain)
    }
    
}
