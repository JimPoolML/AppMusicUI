//
//  AppMusic.swift
//  AppMusic
//
//  Created by Jim Pool Moreno on 20/01/21.
//

import SwiftUI
import Firebase


@main
struct AppMusicApp: App {
    
    let data = OwnData()

    init() {
        FirebaseApp.configure()
        data.loadAlbums()
    }

    var body: some Scene{
        WindowGroup{
            ContentView(data: data)
        }
    }

}
