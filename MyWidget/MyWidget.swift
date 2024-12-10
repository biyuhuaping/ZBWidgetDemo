//
//  MyWidget.swift
//  MyWidget
//
//  Created by ZB on 2024/11/28.
//

import WidgetKit
import SwiftUI

private struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), bgColor: .orange)
    }

    func getSnapshot(for configuration: BackgroundColorSelectionIntent, in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), bgColor: .orange)
        completion(entry)
    }

    func getTimeline(for configuration: BackgroundColorSelectionIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let entries = [SimpleEntry(date: Date(), bgColor: configuration.bgColor)]
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

private struct SimpleEntry: TimelineEntry {
    let date: Date
    let bgColor: BackgroundColor
}

private struct IntentWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            bgColor
            Text(entry.date, style: .date)
                .font(.subheadline)
                .multilineTextAlignment(.center)
        }
    }

    @ViewBuilder
    private var bgColor: some View {
        switch entry.bgColor {
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
        IntentConfiguration(kind: kind, intent: BackgroundColorSelectionIntent.self, provider: Provider()) { entry in
            IntentWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("MyWidget")
        .description("具有可配置背景颜色的小部件")
        .supportedFamilies([.systemSmall])
    }
}

