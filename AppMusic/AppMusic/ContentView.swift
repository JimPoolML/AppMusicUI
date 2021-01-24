//
//  ContentView.swift
//  AppMusic
//
//  Created by Jim Pool Moreno on 18/01/21.
//

import SwiftUI
import Firebase

struct Album : Hashable{
    var id = UUID()
    var name : String
    var image : String
    //Array
    var songs :  [Song]
}

struct Song : Hashable{
    var id = UUID()
    var name : String
    var time : String
    var file : String
}

struct ContentView: View {
    
    @ObservedObject var data : OwnData
    
     //MARK: -- List albums
//    var albums = [
//    Album(name: "Album 1", image: "1",
//          songs: [Song(name: "Song 1", time: "1:15"),
//                  Song(name: "Song 2", time: "1:16"),
//                  Song(name: "Song 3", time: "1:17"),
//                  Song(name: "Song 4", time: "1:18")]),
//        Album(name: "Album 2", image: "2",
//              songs: [Song(name: "Song 11", time: "1:19"),
//                      Song(name: "Song 12", time: "1:20"),
//                      Song(name: "Song 13", time: "1:21"),
//                      Song(name: "Song 14", time: "1:22")]),
//        Album(name: "Album 3", image: "3",
//              songs: [Song(name: "Song 21", time: "1:27"),
//                      Song(name: "Song 22", time: "1:28"),
//                      Song(name: "Song 23", time: "1:29"),
//                      Song(name: "Song 24", time: "1:30")]),
//        Album(name: "Album 4", image: "4",
//              songs: [Song(name: "Song 31", time: "1:31"),
//                      Song(name: "Song 32", time: "1:32"),
//                      Song(name: "Song 33", time: "1:33"),
//                      Song(name: "Song 34", time: "1:34")]),
//        Album(name: "Album 5", image: "5",
//              songs: [Song(name: "Song 41", time: "1:23"),
//                      Song(name: "Song 42", time: "1:24"),
//                      Song(name: "Song 43", time: "1:25"),
//                      Song(name: "Song 44", time: "1:26")])]
    
    @State private var currentAlbum : Album?
    
    var body: some View {
        NavigationView{
            ScrollView{
                ScrollView(.horizontal, showsIndicators: false, content : {
                    LazyHStack{
                        ForEach(self.data.albums, id: \.self, content:{
                            album in
                            ArtAlbum(album: album, isWithText: true).onTapGesture{
                                self.currentAlbum = album
                            }
                        })
                    }
                })
            
            LazyVStack{
                if(self.data.albums.first == nil){
                    EmptyView()
                }else{
                ForEach((self.currentAlbum?.songs ?? self.data.albums.first?.songs) ?? [
                             Song(name: "", time: "", file: "")
                ],
                        id: \.self,
                        content: {
                                   song in
                            CellSong(album: currentAlbum ?? self.data.albums.first!, song:  song)
                            
                       })
                }
            }
            }.navigationTitle("Banda musical")
        }
    }
}

//MARK: --ArtAlbum
struct ArtAlbum : View {
    var album : Album
    //add text
    var isWithText : Bool
    var body: some View{
        ZStack(alignment: .bottom, content: {
            Image(album.image)
                .resizable()
                .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                .frame(width: 170, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            if (isWithText==true){
                ZStack{
                    Blur(style: .dark)
                    Text(album.name).foregroundColor(.white)
                }.frame(width: 60, alignment: .bottom)
            }
        }).frame(width: 170, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).clipped().cornerRadius(20).shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/).padding(20)
    }
}

//MARK: --CellSong
struct CellSong : View {
    var album: Album
    var song : Song
    var body: some View {
//        NavigationLink(
//            destination: PlayerController(album: album, song: song),
//            label: {
//            }).buttonStyle(PlainButtonStyle())
        
        NavigationLink(
            destination: PlayerController(album: album, song: song),
            label: {
                HStack{
                    ZStack{
                        Circle().frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        Circle().frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).foregroundColor(.white)
                    }
                Text(song.name).bold()
                Spacer()
                Text(song.time)
                }.padding(22)
            }).buttonStyle(PlainButtonStyle())
    }
}

