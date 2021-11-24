//
//  FireDBHelper.swift
//  Satvik_Friends
//
//  Created by Satvik Kathpal on 2021-11-24.
//  991487352

import Foundation
import FirebaseFirestore

class FireDBHelper: ObservableObject{
    @Published var friendList = [Friend]()
    private let COLLECTION_NAME : String = "Friends"
    private let store : Firestore
    
    private static var shared : FireDBHelper?
    
    static func getInstance() -> FireDBHelper {
        if shared == nil{
            shared = FireDBHelper(database: Firestore.firestore())
        }
        return shared!
    }
    
    init(database : Firestore){
        self.store = database
    }
    
    func insertFriend(newFriend: Friend){
        do{
            try self.store.collection(COLLECTION_NAME).addDocument(from: newFriend)
        }catch let error as NSError{
            print(#function, "Error while inserting the Friend", error)
        }
    }
    
    func getAllFriends(){
            self.store.collection(COLLECTION_NAME)
                .addSnapshotListener({(querySnapshot, error) in
                    guard let snapshot = querySnapshot else{
                        print(#function, "Error getting the snapshot of the documents", error)
                        return
                    }
                    
                    snapshot.documentChanges.forEach{ (docChange) in
                        
                        var friend = Friend()
                        
                        do{
                            friend = try docChange.document.data(as: Friend.self)!
                            
                            if docChange.type == .added{
                                self.friendList.append(friend)
                                print(#function, "New document added : ", friend)
                            }
                            
                            if docChange.type == .modified{
                                let docId = docChange.document.documentID
                                
                                let matchedIndex = self.friendList.firstIndex(where: {($0.id?.elementsEqual(docId))!})
                                if (matchedIndex != nil){
                                    self.friendList[matchedIndex!] = friend
                                }
                            }
                            
                            if docChange.type == .removed{
                                let docId = docChange.document.documentID
                                
                                let matchedIndex = self.friendList.firstIndex(where: {($0.id?.elementsEqual(docId))!})
                                if (matchedIndex != nil){
                                    self.friendList.remove(at: matchedIndex!)
                                }
                            }
                            
                        }catch let error as NSError{
                            print(#function, "error while getting document change", error)
                        }
                    }
                })
    }
    
    
    func deleteFriend(friendToDelete : Friend){
        self.store.collection(COLLECTION_NAME).document(friendToDelete.id!).delete{error in
            if let error = error{
                print(#function, "error while deleting doc " , error)
            }else{
                print(#function, "Document successfully deleted")
            }
        }
    }
    
}
