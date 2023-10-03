//
//  Lockscreen_Widgets.swift
//  Lockscreen Widgets
//
//  Created by BerkH on 2.10.2023.
//

import WidgetKit
import SwiftUI
import Shared

struct Provider: AppIntentTimelineProvider {
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration, name: "")
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), remainingTime: "", name: "")
    }
    
    func getSnapshot(for configuration: ConfigurationAppIntent, in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), configuration: configuration, remainingTime: "", name: "")
        completion(entry)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        
        let currentDate = Date()
        
        // Access the launchers from the Launcher singleton
        if let launchers = Launcher.shared.launchers, let launcher = launchers.first {
            let dateUtc = launcher.date_utc
            let name = launcher.name
            print("dateUtc: \(String(describing: dateUtc))")
            print("currentDate: \(currentDate)")
            print("name: \(String(describing: name))")
            
            if let lastTaskDate = Date(fromUTCString: dateUtc!) {
                let timeDifference = Calendar.current.dateComponents([.hour, .minute], from: currentDate, to: lastTaskDate)
                let remainingTime = "\(timeDifference.hour ?? 0)h \(timeDifference.minute ?? 0)m"
                
                let entry = SimpleEntry(date: currentDate, configuration: configuration, remainingTime: remainingTime, name: name!)
                entries.append(entry)
            } else {
                print("Failed to convert date_utc string to Date")
            }
        } else {
            print("No-launchers-available")
        }
        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let remainingTime: String
    let shipName: String
    
    init(date: Date, configuration: ConfigurationAppIntent, remainingTime: String = "", name: String = "") {
        self.date = date
        self.configuration = configuration
        self.remainingTime = remainingTime
        self.shipName = name
    }
}

struct Lockscreen_WidgetsEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry
    
    var body: some View {
        
        switch widgetFamily {
            
        case .systemMedium:
            Text("Name: \(entry.shipName)")
                .font(.headline)
            
            Text("Remaining Time: \(entry.remainingTime)")
                .font(.subheadline)
            
        case .systemLarge:
            Text("Name: \(entry.shipName)")
                .font(.headline)
            
            Text("Remaining Time: \(entry.remainingTime)")
                .font(.subheadline)
            
        case .accessoryCircular:
            Text(entry.shipName)
                .font(.headline)
            
            Text(entry.remainingTime)
                .font(.subheadline)
                .gaugeStyle(.accessoryCircular)
            
        case .accessoryRectangular:
            Text(entry.shipName)
                .font(.headline)
            
            Text(entry.remainingTime)
                .font(.subheadline)
                .gaugeStyle(.accessoryLinear)
            
        default:
            Text("Not implemented!")
        }
    }
}

struct Lockscreen_Widgets: Widget {
    let kind: String = "Lockscreen_Widgets"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            Lockscreen_WidgetsEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
                .containerBackground(Color.orange, for: .widget)
        }
        .supportedFamilies([.systemMedium, .systemLarge, .accessoryInline, .accessoryCircular, .accessoryRectangular])
    }
}

extension Date {
    init?(fromUTCString utcString: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = dateFormatter.date(from: utcString) {
            self = date
        } else {
            return nil
        }
    }
}
