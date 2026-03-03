//
//  SessionView.swift
//  ssc26 Bel
//
//  Created by Isabel Cristina Marras Salles on 11/02/26.
//
import SwiftUI

struct SessionView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Environment(User.self) private var user : User
    @Environment(\.modelContext) private var context
    
    @State private var showPageInputModal = false
    @State private var postSessionModal = false
    @State private var showEndConfirmation = false
    @State private var noteModalisPresented : Bool = false
    @State private var musicModalisPresented : Bool = false
    
    @StateObject var audioPlayer: AudioPlayer = AudioPlayer()
    @StateObject var timerModel: TimerModel = TimerModel()
    
    @State var musicSelected: String = "RainSong"
    var book: Book
    @State private var session: Session
    @State private var isPaused = false
    
    init(book: Book){
        self.book = book
        self._session = State(initialValue: Session(book: book, date: .now))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                
                AppBackground()
                
                VideoView(videoName: "video_transparente", videoType: "mp4")
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: geometry.size.width * 2)
                    .shadow(color: Color("Color6").opacity(colorScheme == .dark ? 0.4 : 1), radius: 40)

                VStack {
                    Text(book.title)
                        .font(.title2)
                        .fontDesign(.serif)
                        .bold()
                        .padding(.vertical)
                    TimerView(timerModel: timerModel)
                    Button {
                        audioPlayer.isPlaying ? audioPlayer.pause() : audioPlayer.resume()
                        timerModel.startPause()
                        isPaused.toggle()
                    } label: {
                        Label(timerModel.isTimerRunning ? "pause" : "play", systemImage: timerModel.isTimerRunning ? "pause.fill" : "play.fill")
                            .labelStyle(.iconOnly)
                    }
                    .contentTransition(.symbolEffect(.replace))
                    .buttonStyle(.glass)
                    Spacer()
                }
                Spacer()
                VStack{
                    Button {
                        showEndConfirmation = true
                    } label: {
                        Text("Done")
                            .font(.headline)
                            .tracking(1.2)
                            .padding(.horizontal, 28)
                            .padding(.vertical, 14)
                            .background(
                                Capsule()
                                    .stroke(Color("Color6"), lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading){
                        Button {
                            musicModalisPresented.toggle()
                        } label: {
                            Label("Ambient Audio", systemImage: audioPlayer.isPlaying ? "music.note" : "music.note.slash")
                        }
                    
                    }
                    ToolbarItem(placement: .topBarTrailing){
                        Button {
                            noteModalisPresented.toggle()
                        } label: {
                            Label("Add note", systemImage: "square.and.pencil")
                        }
                    }

                }
                .toolbar (.hidden, for: .tabBar)
                .onAppear(){
                    user.lastBook = book
                    audioPlayer.startAudio(fileName: "RainSong")
                }
                .navigationBarBackButtonHidden(true)
                
            }
        }
        .confirmationDialog(
            "Are you sure you want to finish this session?",
            isPresented: $showEndConfirmation,
            titleVisibility: .visible
        ) {
            Button("Finish", role: .confirm) {
                finishSession()
            }
            Button("Cancel", role: .cancel) {
                showEndConfirmation = false
            }
        }
        
        
        .sheet(isPresented: $musicModalisPresented){
            MusicModal(isPaused: isPaused, audioPlayer: audioPlayer, musicSelected: $musicSelected)
                .presentationDetents([.fraction(0.4)])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $noteModalisPresented){
            NoteModal(session: session, book: book, isNewNote: true)
        }
        
        .fullScreenCover(isPresented: $postSessionModal){
            PostSessionView(dismissParent: dismiss, session: session)
        }
    }
    
    func finishSession(){
        timerModel.startPause()
        let duration = timerModel.elapsedTime
        session.duration = duration.asTimeInterval
        context.insert(session)
        try? context.save()
        audioPlayer.stop()
        postSessionModal = true
        
    }
}

