//
//  RealmEntry.swift
//  Journal
//
//  Created by 윤진서 on 2018. 8. 24..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import Foundation
import RealmSwift

class RealmEntry: Object, EntryType {
    var id: UUID { return UUID.init(uuidString: uuidString)! }
    
    @objc dynamic var uuidString: String = ""
    @objc dynamic var createdAt: Date = Date()
    @objc dynamic var text: String = ""
    
    override static func primaryKey() -> String? {
        return "uuidString"
    }
}
