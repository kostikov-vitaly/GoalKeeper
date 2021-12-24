//
//  Model.swift
//  GoalKeeper
//
//  Created by Vitaly on 18/12/21.
//

import Foundation

struct Area: Identifiable, Codable {
    let id: UUID
    var name: String
    var emoji: String
    var goals: [Goal] = []
    
    init(id: UUID = UUID(), name: String, emoji: String, goals: [Goal]) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.goals = goals
    }
}

extension Area {
    
    struct Data {
        var name: String = ""
        var emoji: String = ""
        var goals: [Goal] = []
    }
    
    var data: Data {
        Data(name: name, emoji: emoji, goals: goals)
    }
    
    mutating func update(from data: Data) {
        name = data.name
        emoji = data.emoji
        goals = data.goals
    }
    
    init(data: Data) {
        id = UUID()
        name = data.name
        emoji = data.emoji
        goals = data.goals
    }
    
}

struct Goal: Identifiable, Codable {
    var name: String
    var id: String
    var tasks: [Task]
    var isActive: Bool
    
    init(name: String, tasks: [Task], isActive: Bool) {
        self.id = name
        self.name = name
        self.tasks = tasks
        self.isActive = isActive
    }
}

extension Goal {
    static var emptyGoal = Goal(name: "", tasks: [], isActive: true)
}

struct Task: Identifiable, Codable {
    var name: String
    var id: String
    var taskDays: [Date]
    
    init(name: String, taskDays: [Date]) {
        self.id = name
        self.name = name
        self.taskDays = taskDays
    }
}

extension Task {
    static var emptyTask = Task(name: "", taskDays: [])
}

extension Area {
    static let loadingData: [Area] =
    [
        Area(name: "Health", emoji: "💪", goals: []),
        Area(name: "Work", emoji: "📁", goals: []),
        Area(name: "Family", emoji: "👪", goals: []),
        Area(name: "Self-development", emoji: "🧘‍♂️", goals: []),
        Area(name: "Finance", emoji: "💵", goals: [])
    ]
}

struct Day: Identifiable, Codable {
    var id = UUID()
    var dayOffset: Int
    var currentDay: Date {
        guard let day = Calendar.current.date(byAdding: .day, value: dayOffset, to: Date()) else {
            print("Calendar error")
            return Date()
        }
        return day
    }
    
    var dayAsString: String {
        currentDay.description(with: Locale(identifier: "en-US"))
    }
    
    var dayComponents: DateComponents {
        Calendar.current.dateComponents([.month, .weekday, .day], from: currentDay)
    }
    
    var weekday: String {
        var weekday: String
        if dayOffset == 0 {
            weekday = "Today"
        } else if dayOffset == 1 {
            weekday = "Tomorrow"
        } else {
            weekday = dayAsString.components(separatedBy: ",")[0]
        }
        return weekday
    }
    
    var day: Int {
        guard let day = dayComponents.day else {
            print("Day choose error")
            return 0
        }
        return day
    }
    
    var dayForText: String {
        return String(format: "%.2d", day)
    }
    
    var shortMonth: String {
        var shortForm: String = dayAsString.components(separatedBy: ",")[1].trimmingCharacters(in: [" "]).components(separatedBy: " ")[0]
        shortForm.removeSubrange(shortForm.index(shortForm.startIndex, offsetBy: 3)..<shortForm.endIndex)
        return shortForm
    }
    
    var unionText: String {
        return "\(dayForText), \(shortMonth)"
    }
    
    var taskCount: Int {
        var count: Int = 0
        for area in Area.loadingData {
            for goal in area.goals {
                count += goal.tasks.count
            }
        }
        return count
    }
}

extension Day {
    static var loadingData: [Day] {
        var array: [Day] = []
        for i in 0..<7 {
            array.append(Day(dayOffset: i))
        }
        return array
    }
}

struct WeeklyDate: Identifiable, Codable {
    let id: String
    let weekday: String
    var label: String
    var isActive: Bool
    
    init(label: String, weekday: String, isActive: Bool) {
        self.id = weekday
        self.weekday = weekday
        self.label = label
        self.isActive = isActive
    }
}
