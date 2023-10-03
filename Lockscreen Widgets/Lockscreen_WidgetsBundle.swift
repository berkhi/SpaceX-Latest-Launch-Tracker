//
//  Lockscreen_WidgetsBundle.swift
//  Lockscreen Widgets
//
//  Created by BerkH on 2.10.2023.
//

import WidgetKit
import SwiftUI

@main
struct Lockscreen_WidgetsBundle: WidgetBundle {
    var body: some Widget {
        Lockscreen_Widgets()
        Lockscreen_WidgetsLiveActivity()
    }
}
