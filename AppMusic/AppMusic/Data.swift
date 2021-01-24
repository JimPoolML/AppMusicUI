//
//  Data.swift
//  AppMusic
//
//  Created by Jim Pool Moreno on 20/01/21.
//

import Foundation
import SwiftUI
import SwiftAudioPlayer
import Firebase
import FirebaseStorage

class OwnData : ObservableObject {
    //MARK: -- List albums
    @Published public var albums = [Album]() // List<Album>
//    @Published public var albums = [
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
    
    //MARK: -- FireBase
    func loadAlbums() {
        Firestore.firestore().collection("albums").getDocuments{ (snapshot, error) in
            
            if error == nil {
                for document in snapshot!.documents{
                    let name = document.data()["name"] as? String ?? "errorName"
                    let image = document.data()["image"] as? String ?? "1"
                    print(image)
                    let songs = document.data()["songs"] as? [String : [String : Any]]
                    
                    
                    var songsArray = [Song]()
                    
                    if let songs = songs {
                        for song in songs{
                            let songName = song.value["name"] as? String ?? "error"
                            let songTime = song.value["time"] as? String ?? "error"
                            let songFile = song.value["file"] as? String ?? "error"
                            songsArray.append(Song(name: songName, time: songTime, file: songFile))
                        }
                    }
                    print(document.data())
                    
                    self.albums.append(Album(name: name, image: image, songs: songsArray))
                }
                //print(snapshot)
            } else {
                print("empty")
                print(error)
            }
            
        }
            
    }
}
