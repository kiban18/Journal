//
//  Journal.swift
//  Journal
//
//  Created by JinSeo Yoon on 2018. 8. 3..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import Foundation

protocol EntryRepository {
    func add(_ entry: EntryType)
    func update(_ entry: EntryType)
    func remove(_ entry: EntryType)
    
    func entries(contains string: String) -> [EntryType]
    func recentEntries(max: Int, completion: @escaping ([EntryType]) -> Void)
}

class InMemoryEntryRepository: EntryRepository {
    private var entries: [UUID: EntryType]
    
    init(entries: [Entry] = []) {
        var result: [UUID: EntryType] = [:]
        
        entries.forEach { entry in
            result[entry.id] = entry
        }
        
        self.entries = result
    }
    
    static var shared: InMemoryEntryRepository = {
        let repository = InMemoryEntryRepository()
        return repository
    }()
    
    func add(_ entry: EntryType) {
        entries[entry.id] = entry
    }
    
    func update(_ entry: EntryType) {
        // entries[entry.id] = entry
    }
    
    func remove(_ entry: EntryType) {
        entries[entry.id] = nil
    }
    
    func entries(contains string: String) -> [EntryType] {
        return entries
            .values
            .filter { $0.text.contains(string) }
            .sorted { $0.createdAt > $1.createdAt  }
    }
    
    func entry(with id: UUID) -> EntryType? {
        return entries[id]
    }
    
    func recentEntries(max: Int, completion: @escaping ([EntryType]) -> Void) {
        let result = entries
            .values
            .sorted { $0.createdAt > $1.createdAt  }
            .prefix(max)
        
        completion(Array(result))
    }
}
