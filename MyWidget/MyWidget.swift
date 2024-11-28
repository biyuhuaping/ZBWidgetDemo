//
//  MyWidget.swift
//  MyWidget
//
//  Created by ZB on 2024/11/28.
//

import WidgetKit
import SwiftUI

/// 负责为小组件提供数据
struct Provider: AppIntentTimelineProvider {
    /// 1 在首次显示小组件，没有数据时使用占位
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    /// 2 获取小组件的快照，例如在小组件库中预览时会调用
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    /// 3 这个方法来获取当前时间和（可选）未来时间的时间线的小组件数据以更新小部件。也就是说你在这个方法中设置在什么时间显示什么内容。
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

/// 小组件的数据模型
struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

/// 小组件的视图
struct MyWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)

            Text("最喜爱的表情：")
            Text(entry.configuration.favoriteEmoji)
        }
    }
}

/// 小组件的配置部分
struct MyWidget: Widget {
    let kind: String = "MyWidget"// 唯一标识

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            MyWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

/// 提供小组件在 Xcode 中的预览
#Preview(as: .systemSmall) {
    MyWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
