//
//  Constant.swift
//  Baby_Jaserick
//
//  Created by TinhPV on 1/24/19.
//  Copyright © 2019 TinhPV. All rights reserved.
//

import Foundation

struct Constant {
    struct SegueID {
        static let createNewRouteVC = "createNewRouteVC"
        static let pickIcon = "pickIcon"
        static let selectSound = "selectSound"
    }
    
    struct soundExtension {
        static let mp3 = "mp3"
        static let caf = "caf"
    }
    
    struct KeySetting {
        static let alarm = "alarm"
        static let vibration = "vibration"
        static let volume = "volume"
        static let video = "video"
    }
    
    struct KeyProgram {
        static let activeRouteID = "activeRouteID"
        static let endTime = "endTimeOfTimer"
    }
    
    struct CellID {
        static let routeCell = "routeCell"
        static let iconCell = "iconCell"
        static let soundCell = "soundCell"
        static let childCell = "childCell"
        static let activeChildCell = "activeChildCell"
    }
    
    struct ImageName {
        static let backButton = "back"
    }
    
    struct Storyboard {
        static let iconCollectionVC = "iconCollection"
        static let soundSelectionVC = "soundSelection"
        static let setNamePopupVC = "namePopup"
        static let detailRouteVC = "detailRouteVC"
        static let newChildVC = "newChildVC"
        static let showErrorVC = "showErrorVC"
        static let playVC = "playVC"
        static let alertVC = "alertVC"
    }
}
