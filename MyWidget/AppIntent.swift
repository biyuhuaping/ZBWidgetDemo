//
//  AppIntent.swift
//  MyWidget
//
//  Created by ZB on 2024/11/28.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    // An example configurable parameter.
    @Parameter(title: "最喜爱的表情：", default: "😃")
    var favoriteEmoji: String
}
