//
//  OnboardingView.swift
//  ssc26 Bel
//
//  Created by Isabel Cristina Marras Salles on 28/02/26.
//

import Foundation
import SwiftUI
import SwiftUI


enum OnboardingStep: Hashable {
    case welcome, difficulty, explanation, refuge, memory, action
}

struct OnboardingView: View {
    @State private var currentStep = OnboardingStep.welcome
    @State private var buttonShowing = false
    @State private var welcomeTextShowing = false
    
    @AppStorage("hasOnboarded") private var hasOnboarded = false
    
    var body: some View {
        ZStack {
            AppBackground()
                .ignoresSafeArea()
            
            TabView(selection: $currentStep) {
                
                Tab(value: .welcome) {
                    VStack(spacing: 40) {
                        
                        if welcomeTextShowing {
                            VStack(spacing: 16) {
                                Text("Welcome, _Reader!_")                           .font(.title).fontWeight(.bold).fontDesign(.serif)
                                    .multilineTextAlignment(.center)
                                
                            }
                            .padding(.horizontal, 32)
                            .transition(.scale.combined(with: .opacity))
                        }
                    }
                }

                
                
                Tab(value: .difficulty) {
                    VStack(spacing: 40) {
                        
                        if welcomeTextShowing {
                            VStack(spacing: 16) {
                                Text("Have you found it harder to stay immersed in a book?")                           .font(.title).fontWeight(.bold).fontDesign(.serif)
                                    .multilineTextAlignment(.center)
                                
                                Text("If your attention drifts after a few lines, you're not alone. \nIn a world built for constant stimulation, sustained focus has become rare.")
                                    .font(.body)
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.horizontal, 32)
                            .transition(.scale.combined(with: .opacity))
                        }
                    }
                }
                
                Tab(value: .explanation) {
                    VStack(spacing: 40) {
                        Image("CatStretching")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 220)
                            .shadow(color: .white.opacity(0.15), radius: 30, x: 0, y: 0)
                        
                        VStack(spacing: 16) {
                            Text("Your brain adapts to what it practices.")                                .font(.title).fontWeight(.bold).fontDesign(.serif)
                                .multilineTextAlignment(.center)
                            
                            Text("Endless scrolling trains rapid attention shifts. \nDeep reading, however, depends on stillness, control, and time.")                                .font(.body)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal, 32)
                    }
                }
                
                Tab(value: .refuge) {
                    VStack(spacing: 40) {
                        Image("LibraryImage")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 220)
                            .shadow(color: .white.opacity(0.15), radius: 30, x: 0, y: 0)
                        
                        VStack(spacing: 16) {
                            Text("Focus needs an environment.")                                .font(.title).fontWeight(.bold).fontDesign(.serif)
                                .multilineTextAlignment(.center)
                            
                            Text("Reduce external noise. \nSlow your pace. \nCreate a space where your mind can remain present — and your book can unfold.")
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal, 32)
                    }
                }
                
                Tab(value: .memory) {
                    VStack(spacing: 40) {                        
                        VStack(spacing: 16) {
                            
                            Text("Deep reading is active.")                                .font(.title).fontWeight(.bold).fontDesign(.serif)
                                .multilineTextAlignment(.center)
                            
                            Text("Write your thoughts, capture insights, and revisit them anytime. \nGet gentle summaries to help consolidate what you’ve understood — not replace it.")
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal, 32)
                    }
                }
                
                Tab(value: .action) {
                    VStack(spacing: 40) {
                        Image("CatAndBooks")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 250)
                            .shadow(color: .white.opacity(0.15), radius: 30, x: 0, y: 0)
                        
                        VStack(spacing: 16) {
                            Text("Reclaim your focus.")                                .font(.title).fontWeight(.bold).fontDesign(.serif)
                                .multilineTextAlignment(.center)
                            
                            Text("Just a few intentional minutes a day can retrain your attention. \nLet's begin your first session.")
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal, 32)
                    }
                }
                
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .animation(.easeInOut(duration: 0.6), value: currentStep)
        .task {
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(0.4))
                withAnimation {
                    welcomeTextShowing = true
                }
                
                try? await Task.sleep(for: .seconds(0.6))
                withAnimation {
                    buttonShowing = true
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            if buttonShowing {
                Button {
                    incrementStep()
                } label: {
                    Text(currentStep == .action ? "Let's read!" : "Continue")
                        .font(.headline)
                        .padding(10)
                        .frame(maxWidth: 350)
                }
                .buttonBorderShape(.roundedRectangle(radius: 24))
                .buttonStyle(.glass)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .padding(.bottom, 20)
            }
        }
    }
    
    func incrementStep() {
        switch currentStep {
        case.welcome:
            currentStep = .difficulty
        case .difficulty:
            currentStep = .explanation
        case .explanation:
            currentStep = .refuge
        case .refuge:
            currentStep = .memory
        case .memory:
            currentStep = .action
        case .action:
            withAnimation {
                hasOnboarded = true
            }
        }
    }
}

