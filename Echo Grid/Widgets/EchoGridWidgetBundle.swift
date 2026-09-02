//
//  EchoGridWidgetBundle.swift
//  Echo Grid
//

import WidgetKit
import SwiftUI

public struct EchoGridWidgetEntry: TimelineEntry {
    public let date: Date
    public let streak: Int
    public let isTodayCompleted: Bool
    public let totalStars: Int

    public init(date: Date = Date(), streak: Int = 0, isTodayCompleted: Bool = false, totalStars: Int = 0) {
        self.date = date
        self.streak = streak
        self.isTodayCompleted = isTodayCompleted
        self.totalStars = totalStars
    }
}

public struct EchoGridTimelineProvider: TimelineProvider {
    public typealias Entry = EchoGridWidgetEntry

    public init() {}

    public func placeholder(in context: Context) -> EchoGridWidgetEntry {
        EchoGridWidgetEntry(date: Date(), streak: 5, isTodayCompleted: false, totalStars: 18)
    }

    public func getSnapshot(in context: Context, completion: @escaping (EchoGridWidgetEntry) -> Void) {
        let entry = loadCurrentEntry()
        completion(entry)
    }

    public func getTimeline(in context: Context, completion: @escaping (Timeline<EchoGridWidgetEntry>) -> Void) {
        let entry = loadCurrentEntry()

        // Refresh at next midnight UTC
        let calendar = Calendar(identifier: .gregorian)
        let nextMidnight = calendar.nextDate(after: Date(), matching: DateComponents(hour: 0, minute: 0), matchingPolicy: .nextTime) ?? Date().addingTimeInterval(3600)

        let timeline = Timeline(entries: [entry], policy: .after(nextMidnight))
        completion(timeline)
    }

    private func loadCurrentEntry() -> EchoGridWidgetEntry {
        let suiteName = "group.tygon.org.echogrid"
        let defaults = UserDefaults(suiteName: suiteName) ?? .standard
        let streak = defaults.integer(forKey: "echo_grid_daily_streak_v1")
        let totalStars = defaults.integer(forKey: "echo_grid_total_stars_v1")

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "UTC") ?? TimeZone(secondsFromGMT: 0)!
        let todayStr = formatter.string(from: Date())

        var isTodayCompleted = false
        if let data = defaults.data(forKey: "echo_grid_daily_history_v1"),
           let history = try? JSONDecoder().decode([String: DailyChallengeRecord].self, from: data) {
            isTodayCompleted = history[todayStr]?.isCompleted ?? false
        }

        return EchoGridWidgetEntry(date: Date(), streak: streak, isTodayCompleted: isTodayCompleted, totalStars: totalStars)
    }
}

public struct EchoGridWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    var entry: EchoGridTimelineProvider.Entry

    public var body: some View {
        switch family {
        case .systemSmall:
            EchoGridWidgetSmallView(
                streak: entry.streak,
                isTodayCompleted: entry.isTodayCompleted
            )
        default:
            EchoGridWidgetMediumView(
                streak: entry.streak,
                isTodayCompleted: entry.isTodayCompleted,
                totalStars: entry.totalStars
            )
        }
    }
}

public struct EchoGridWidget: Widget {
    let kind: String = "EchoGridWidget"

    public init() {}

    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: EchoGridTimelineProvider()) { entry in
            EchoGridWidgetEntryView(entry: entry)
                .containerBackground(Color(white: 0.08), for: .widget)
        }
        .configurationDisplayName("Daily Echo Streak")
        .description("Track your daily resonance streak and puzzle completion.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

public struct EchoGridWidgetBundle: WidgetBundle {
    public init() {}

    public var body: some Widget {
        EchoGridWidget()
    }
}
