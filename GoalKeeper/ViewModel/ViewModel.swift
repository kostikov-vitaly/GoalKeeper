//
//  ViewModel.swift
//  GoalKeeper
//
//  Created by Vitaly on 18/12/21.
//

import SwiftUI

class ViewModel: ObservableObject {
    
    @Environment(\.dismiss) var dismiss
    
    @Published var areas: [Area] = []
    @Published var days: [Day] = Day.loadingData
    
    // calendar stuff
    func isToday(day: Day) -> Bool {
        let thisDay = day.currentDay
        return Calendar.current.dateComponents([.day], from: thisDay).day == Calendar.current.dateComponents([.day], from: Date()).day
    }
    
    // working with objects
    
    //index finding
    func findAreaIndex(area: Area) -> Int {
        guard let areaIndex = areas.firstIndex(where: { item -> Bool in
            item.id == area.id
        }) else {
            print("finding area index... couldn't find this area in areas array")
            return 0
        }
        return areaIndex
    }
    
    func findAreaIndex(goal: Goal) -> Int {
        guard let areaIndex = areas.firstIndex(where: { item -> Bool in
            item.goals.contains(where: { item -> Bool in
                item.id == goal.id
            })
        }) else {
            print("finding area index... couldn't find an area for this goal")
            return 0
        }
        return areaIndex
    }
    
    func findGoalIndex(goal: Goal) -> Int {
        
        let areaIndex = findAreaIndex(goal: goal)
        
        guard let goalIndex = areas[areaIndex].goals.firstIndex(where: { item -> Bool in
            item.id == goal.id
        }) else {
            print("finding goal index... couldn't find this goal")
            return 0
        }
        return goalIndex
    }
    
    //adding
    func addGoalToArea(area: Area, name: String) {
        
        let goal = Goal(name: name, tasks: [], isActive: true)
        let areaIndex = findAreaIndex(area: area)
        areas[areaIndex].goals.append(goal)
    }
    
    func addTaskToGoal(goal: Goal, name: String) {
        
        let task = Task(name: name, taskDays: [Date()])
        let areaIndex = findAreaIndex(goal: goal)
        let goalIndex = findGoalIndex(goal: goal)
        areas[areaIndex].goals[goalIndex].tasks.append(task)
    }
    
    //removing
    func removeGoal(area: Area, goal: Goal) {
        
        let areaIndex = findAreaIndex(area: area)
        areas[areaIndex].goals.removeAll(where: { item -> Bool in
            item.id == goal.id
        })
    }
    
    func removeTask(goal: Goal, task: Task) {
        
        let areaIndex = findAreaIndex(goal: goal)
        let goalIndex = findGoalIndex(goal: goal)
        areas[areaIndex].goals[goalIndex].tasks.removeAll(where: { item -> Bool in
            item.id == task.id
        })
    }
    
    //goal counting
    func activeGoalsCount(area: Area) -> Int {
        areas.flatMap( {$0.goals} ).filter( {$0.isActive == true} ).count
    }
    
    func inactiveGoalsCount(area: Area) -> Int {
        areas.flatMap( {$0.goals} ).filter( {$0.isActive == false} ).count
    }
    
    func checkGoalsNumberWhenAdd(area: Area) -> Bool {
        activeGoalsCount(area: area) == 5 || inactiveGoalsCount(area: area) == 4
    }
    
    func checkGoalsNumberWhenArchive(area: Area) -> Bool {
        inactiveGoalsCount(area: area) == 4
    }
    
    func checkGoalsNumberWhenReturn(area: Area) -> Bool {
        activeGoalsCount(area: area) == 5
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
                        completion(.success(Area.loadingData))
                    }
                    return
                }
                let areas = try JSONDecoder().decode([Area].self, from: file.availableData)
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
