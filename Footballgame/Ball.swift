//
//  Ball.swift
//  Footballgame
//
//  Created by infuntis on 09/07/17.
//  Copyright © 2017 gala. All rights reserved.
//

import Foundation
let SelectedBallKey = "SelectedBall"

enum ThemeBall: Int{
    case  usual = 0, golf, dark_blue, green, big_balloon, purple,  balloon, tennis
    
    static var count: Int { return ThemeBall.tennis.hashValue + 1}
    
    
    var prefix: String{
        switch self {
        case .usual:
            return "usual"
        case .golf:
            return "golf"
        case .dark_blue:
            return "dark_blue"
        case .green:
            return "green"
        case .big_balloon:
            return "big_balloon"
        case .purple:
            return "purple"
        case .balloon:
            return "balloon"
        case .tennis:
            return "tennis"
        }
    }
    
    var string: String {
        return String(describing: self)
    }
}


struct ThemeManager {
    
    static func currentTheme() -> ThemeBall {
        UserDefaults.standard.value(forKeyPath: SelectedBallKey)
        if let storedTheme = (UserDefaults.standard.value(forKey: SelectedBallKey) as AnyObject).integerValue {
            return ThemeBall(rawValue: storedTheme)!
        } else {
            return .usual
        }
    }
    
    static func applyTheme(_ theme: ThemeBall) {
        UserDefaults.standard.set(theme.rawValue, forKey: SelectedBallKey)
        UserDefaults.standard.synchronize()
    }
}
