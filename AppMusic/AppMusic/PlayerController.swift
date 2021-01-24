//
//  PlayerController.swift
//  AppMusic
//
//  Created by Jim Pool Moreno on 19/01/21.
//

import Foundation
import AVFoundation
import SwiftUI
import SwiftAudioPlayer
import Firebase

struct PlayerController : View {
    
    @State var album : Album
    @State var song : Song
    
    @State var isPlayed : Bool = true
    
    //MARK: -- Player
    @State var player = AVPlayer()
    @State var volume : Float = 5.0
    @State var formatTime : String = "0.00"
    @State var songTime : Float = 0.1
    @State var totalTime : Float = 1.0
    //To update every second the song
    let timer1 = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack{
            Image(album.image).resizable().edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            Blur(style: .dark).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack{
                Spacer()
                ArtAlbum(album: album, isWithText: false)
                Text(song.name).font(.title).fontWeight(.light).foregroundColor(.white)
                Spacer()
                ZStack{
                    Color.white.cornerRadius(20).shadow(radius: 10)
                    VStack{
                        Spacer()
                        HStack {
                            Image(systemName: "minus")
                            Slider(value: Binding(
                                        get: {
                                            self.volume
                                        },
                                        set: {(newValue) in
                                              self.volume = newValue
                                              self.changeVolume()
                                        }
                                    ), in: 0...10, step: 1)
                            //Slider(value: $volume, in: 0...100, step: 1)
                                .accentColor(Color.blue)
                            Image(systemName: "plus")
                        }.foregroundColor(Color.blue).padding(20)
                        Spacer()
                        HStack {
                            Text(String(self.formatTime))
                            Slider(value: Binding(
                                        get: {
                                            self.songTime
                                        },
                                        set: {(newValue) in
                                              self.songTime = newValue
                                              self.changeTime()
                                        }
                                    ), in: 0...totalTime, step: 1)
                                .accentColor(Color.blue)
                                .onReceive(timer1) { _ in
                                    self.updateTimeSong()
                                }
                            //print(player.currentItem?.asset.duration)
                            //Text(String(format: "%.2f", songTime))
                            Text(song.time)
                        }.foregroundColor(Color.blue).padding(20)
                        Spacer()
                    HStack{
                        Button(action: self.onPrevious, label: {
                            Image(systemName: "arrow.left.circle").resizable()
                        }).frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).foregroundColor(Color.black.opacity(0.2))
                        
                        Button(action: self.playPause, label: {
                            Image(systemName: isPlayed ? "pause.circle.fill": "play.circle.fill").resizable()
                        }).frame(width: 70, height: 70, alignment: .center)
                        
                        Button(action: self.onNext, label: {
                            Image(systemName: "arrow.right.circle").resizable()
                        }).frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).foregroundColor(Color.black.opacity(0.2))
                    }.padding(20)
                    Spacer()
                    }
                }.edgesIgnoringSafeArea(.bottom).frame(height: 220, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
        }.onAppear(){
            self.appear()
        }
    }
    
    func appear(){
        let seconds: Int = self.passTimeData(songDuration : song.time)
        totalTime = Float(seconds)
        //self.songTime = player.currentItem?.duration.seconds ?? 0.0
        player.volume = self.volume
        self.playSong()
        self.changeTime()
    }
    
    func updateTimeSong(){
        songTime = Float(player.currentTime().seconds)
        let sec : Int = Int(songTime)%60
        if(sec<10){
            formatTime = String(Int(songTime)/60)+":0"+String(sec)
        }else{
            formatTime = String(Int(songTime)/60)+":"+String(sec)
        }
        print("songtime is : \(songTime)" )
        if(songTime >= totalTime){
            //Song the next song
            onNext()
            appear()
        }
    }
    
    func passTimeData(songDuration : String) -> Int{
        guard let minutes = Int(songDuration.prefix(1)) else { return 1 }
        guard let seconds = Int(songDuration.suffix(2)) else { return 15 }
        let total = (minutes*60 ) + seconds
        print(total)
        return total
    }
    
    
    func changeTime(){
        //first pause, last play
        formatTime = String(Int(songTime)/60)+":"+String(Int(songTime)%60)
        print(formatTime)
        print(songTime)
        //first pause, last play
        player.pause()
        player.seek(to: CMTime(seconds: Double(songTime),preferredTimescale: 10000))
        //player.currentTime = (TimeInterval(songTime))
        player.volume = volume
        player.play()
    }
    
    func changeVolume(){
        player.volume = self.volume
    }
    
    func playSong(){
        let storage = Storage.storage().reference(forURL: self.song.file)
        storage.downloadURL { (url, error) in
            if error != nil {
                print(error)
            } else{
                print(url?.absoluteString)
                
                do {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                 }
                 catch {
                    // report for an error
                 }
                player = AVPlayer(url: url!)
                player.play()
            }
        }
    }
    
    func playPause(){
        self.isPlayed.toggle()
        if isPlayed == false {
            player.pause()
        }else{
            player.play()
        }
    }
    
   func onNext(){
        if let currentIndex = album.songs.firstIndex(of: song){
            //final song of album
            if currentIndex == album.songs.count-1{
                player.pause()
                song = album.songs[0]
                self.playSong()
            }else {
                player.pause()
                song = album.songs[currentIndex+1]
                self.playSong()
            }
        }
    }
    
    func onPrevious(){
        if let currentIndex = album.songs.firstIndex(of: song){
            //final song of album
            if currentIndex == 0 {
                player.pause()
                song = album.songs[album.songs.count-1]
                self.playSong()
            }else {
                player.pause()
                song = album.songs[currentIndex-1]
                self.playSong()
            }
        }
        
    }
    
}
