//
//  Satvik_FriendsApp.swift
//  Satvik_Friends
//
//  Created by Satvik Kathpal on 2021-11-24.
//

import SwiftUI
import Firebase
import FirebaseFirestore

@main
struct Satvik_FriendsApp: App {
    let fireDBHelper : FireDBHelper
    
    init(){
        FirebaseApp.configure()
        fireDBHelper = fireDBHelper(database: Firestore.firestore())
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(fireDBHelper)
        }
    }
}
