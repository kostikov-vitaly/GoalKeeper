//
//  ViewModel.swift
//  GoalKeeper
//
//  Created by Vitaly on 18/12/21.
//

import SwiftUI

class ViewModel: ObservableObject {
    
    @Published var areas: [Area] = []
    @Published var days: [Day] = Day.loadingData
    @Environment(\.dismiss) var dismiss
    
    // calendar stuff
    func isToday(day: Day) -> Bool {
        let thisDay = day.currentDay
        return Calendar.current.dateComponents([.day], from: thisDay).day == Calendar.current.dateComponents([.day], from: Date()).day
    }
    
    // working with objects
    
    //index finding
    func findAreaIndex(area: Area) -> Int? {
        guard let areaIndex = areas.firstIndex(where: { item -> Bool in
            item.id == area.id
        }) else {
            print("finding... area index error")
            return nil
        }
        return areaIndex
    }
    
    func findAreaIndex(goal: Goal) -> Int? {
        guard let areaIndex = areas.firstIndex(where: { item -> Bool in
            item.goals.contains(where: { item -> Bool in
                item.id == goal.id
            })
        }) else {
            print("finding... area index error")
            return nil
        }
        return areaIndex
    }
    
    func findGoalIndex(goal: Goal) -> Int? {
        
        guard let areaIndex = findAreaIndex(goal: goal) else {
            print("finding... area index error")
            return nil
        }
        
        guard let goalIndex = areas[areaIndex].goals.firstIndex(where: { item -> Bool in
            item.id == goal.id
        }) else {
            print("finding... goal index error")
            return nil
        }
        return goalIndex
    }
    
    //adding
    func addGoalToArea(area: Area, name: String) {
        
        let goal = Goal(name: name, tasks: [])
        
        guard let areaIndex = findAreaIndex(area: area) else {
            print("adding... area index error")
            return
        }
        areas[areaIndex].goals.append(goal)
    }
    
    func addTaskToGoal(goal: Goal, name: String) {
        
        let task = Task(name: name, taskDays: [Date()])
        
        guard let areaIndex = findAreaIndex(goal: goal) else {
            print("adding... area index error")
            return
        }
        
        guard let goalIndex = findGoalIndex(goal: goal) else {
            print("adding... goal index error")
            return
        }
        
        areas[areaIndex].goals[goalIndex].tasks.append(task)
    }
    
    //removing
    func removeGoal(area: Area, item: IndexSet) {
        guard let areaIndex = findAreaIndex(area: area) else {
            print("deleting... area index error")
            return
        }
        areas[areaIndex].goals.remove(atOffsets: item)
    }
    
    func removeTask(goal: Goal, item: IndexSet) {
        guard let areaIndex = findAreaIndex(goal: goal) else {
            print("deleting... area index error")
            return
        }
        guard let goalIndex = findGoalIndex(goal: goal) else {
            print("deleting... goal index error")
            return
        }
        areas[areaIndex].goals[goalIndex].tasks.remove(atOffsets: item)
    }
    
    // data processing
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil,
                                       create: false)
            .appendingPathComponent("areas.data")
    }
    
    static func load(completion: @escaping (Result<[Area], Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                var areas = try JSONDecoder().decode([Area].self, from: file.availableData)
                if areas.isEmpty {
                    areas = Area.loadingData
                }
                DispatchQueue.main.async {
                    completion(.success(areas))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    static func save(areas: [Area], completion: @escaping (Result<Int, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(areas)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(areas.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
