//
//  MyWidget.swift
//  MyWidget
//
//  Created by ZB on 2024/11/28.
//

import WidgetKit
import SwiftUI

private struct Provider: IntentTimelineProvider {
    /// 提供占位视图，用于在小组件加载内容之前显示的默认内容
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: MyConfigurationIntent())
    }

    /// 提供小组件的快照视图，用于小组件的预览或快速加载场景
    func getSnapshot(for configuration: MyConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    /// 提供小组件的时间线数据，用于定时刷新小组件的内容
    func getTimeline(for configuration: MyConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let entries = [SimpleEntry(date: Date(), configuration: configuration)]
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

private struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: MyConfigurationIntent
}

// 使用自定义视图显示小组件内容
private struct IntentWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        let configuration = entry.configuration
        ZStack {
            bgColor
            VStack(
                alignment: .leading,
                content: {
                    Text(entry.date, style: .date)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                    Text("姓名：\(configuration.name ?? "无")")
                    Text("年龄：\(configuration.age ?? 0)")
                    Text("性别：\(getGender())")
                })
        }
    }
    
    func getGender() -> String {
        switch entry.configuration.gender {
        case .man:
            return "男"
        case .woman:
            return "女"
        case .unknown:
            return "未知"
        }
    }
    
    @ViewBuilder
    private var bgColor: some View {
        switch entry.configuration.bgColor {
        case .blue:
            Color.blue
        case .red:
            Color.red
        case .green:
            Color.green
        case .orange:
            Color.orange
        default:
            Color.primary.colorInvert()
        }
    }
}

struct MyWidget: Widget {
    private let kind: String = "MyWidget"
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: MyConfigurationIntent.self, provider: Provider()) { entry in
            // 使用自定义视图显示小组件内容
            IntentWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("MyWidget")
        .description("可配置背景颜色的小部件")
        .supportedFamilies([.systemSmall])
    }
}

