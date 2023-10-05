//
//  Modals.swift
//  SpaceX Latest Launch Tracker
//
//  Created by BerkH on 6.10.2023.
//

import Foundation
import UIKit

class Modals: UIView {
    
    struct LauncherResponse: Codable {
        let name: String
        let details: String?
        let links: Links
        let date_utc: String
    }

    struct Links: Codable {
        let patch: Patch
    }

    struct Patch: Codable {
        let small: String
        let large: String
    }
    
}
