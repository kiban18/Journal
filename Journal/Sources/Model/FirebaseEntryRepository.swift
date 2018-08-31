//
//  FirebaseEntryRepository.swift
//  Journal
//
//  Created by 윤진서 on 2018. 8. 31..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseEntryRepository: EntryRepository {
    private let reference: DatabaseReference
    
    init(reference: DatabaseReference = Database.database().reference()) {
        self.reference = reference.child("entries")
    }
    
    func add(_ entry: EntryType) {
        reference.child(entry.id.uuidString).setValue(
            [
                "uuidString": entry.id.uuidString,
                "createdAt": entry.createdAt.timeIntervalSince1970,
                "text": entry.text
            ]
        )
    }
    
    func update(_ entry: EntryType) {
        reference.child(entry.id.uuidString).child("text").setValue(entry.text)
    }
    
    func remove(_ entry: EntryType) {
        reference.child(entry.id.uuidString).removeValue()
    }
    
    func entries(contains string: String) -> [EntryType] {
        return []
    }
    
    func recentEntries(max: Int, completion: @escaping ([EntryType]) -> Void) {
        self.reference
            .queryOrdered(byChild: "createdAt")
            .queryLimited(toLast: UInt(max))
            .observeSingleEvent(of: .value) { snapshot in
                let entries: [Entry] = snapshot.children.compactMap {
                    guard
                        let childSnapshot = $0 as? DataSnapshot,
                        let dict = childSnapshot.value as? [String: Any],
                        let entry = Entry(dictionary: dict)
                        else { return nil }
                    return entry
                }
                completion(entries.reversed())
            }
    }
}
