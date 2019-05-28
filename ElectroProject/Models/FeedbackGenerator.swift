//
//  FeedbackGenerator.swift
//  ElectroProject
//
//  Created by Houcem Sanai on 14/12/2017.
//  Copyright © 2017 ESPRIT. All rights reserved.
//

import UIKit

struct FeedbackGenerator {
    
    static func impactOcurredWith(style: UIImpactFeedbackStyle) {
        if #available(iOS 10.0, *), UserDefaultsManager.hapticFeedbackSwitchIsOn {
            UIImpactFeedbackGenerator(style: style).impactOccurred()
        }
    }
    
    static func notificationOcurredOf(type: UINotificationFeedbackType) {
        if #available(iOS 10.0, *), UserDefaultsManager.hapticFeedbackSwitchIsOn {
            UINotificationFeedbackGenerator().notificationOccurred(type)
        }
    }
    
    static func selectionChanged() {
        if #available(iOS 10.0, *), UserDefaultsManager.hapticFeedbackSwitchIsOn {
            UISelectionFeedbackGenerator().selectionChanged()
        }
    }
}

