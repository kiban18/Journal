//
//  Setting.swift
//  Journal
//
//  Created by 윤진서 on 2018. 8. 21..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import Foundation

enum DateFormatOption: String {
    case `default` = "yyyy. M. dd. EEE"
    case western = "EEE, MMM d, yyyy"
    
    static var all: [DateFormatOption] { return [.default, .western] }
}

enum FontSizeOption: Double {
    case small = 14
    case medium = 16
    case large = 18
    
    static var `default`: FontSizeOption { return .medium }
    static var all: [FontSizeOption] { return [.small, .medium, .large] }
}

protocol Settings {
    var dateFormat: DateFormatOption { get set }
    var fontSize: FontSizeOption { get set }
}

extension Settings {
    var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = dateFormat.rawValue
        return df
    }
}

private let dateFormatOptionKey: String = "dateFormatOptionKey"
private let fontSizeOptionKey: String = "fontSizeOptionKey"

extension UserDefaults: Settings {
    var dateFormat: DateFormatOption {
        set {
            set(newValue.rawValue, forKey: dateFormatOptionKey)
            synchronize()
        }
        
        get {
            let rawValue = object(forKey: dateFormatOptionKey) as? String
            return rawValue.flatMap(DateFormatOption.init) ?? DateFormatOption.default
        }
    }
    
    var fontSize: FontSizeOption {
        set {
            set(newValue.rawValue, forKey: fontSizeOptionKey)
            synchronize()
        }
        
        get {
            let rawValue = object(forKey: fontSizeOptionKey) as? Double
            return rawValue.flatMap(FontSizeOption.init) ?? FontSizeOption.default
        }
    }
}
