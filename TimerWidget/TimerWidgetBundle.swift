//
//  TimerWidgetBundle.swift
//  TimerWidget
//
//  Created by Manya Gupta on 5/28/24.
//

import WidgetKit
import SwiftUI

@main
struct TimerWidgetBundle: WidgetBundle {
    var body: some Widget {
        TimerWidget()
        TimerWidgetLiveActivity()
    }
}
