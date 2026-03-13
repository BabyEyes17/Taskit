// Authored by Jayden Lewis on 04/02/2026

import Foundation

struct Task: Identifiable, Codable, Equatable {
    
    let id: UUID
    var title: String
    var description: String
    var category: String
    var dueDate: Date
    
    var notificationsEnabled: Bool
    var notifyBeforeMinutes: Int?
    
    var repeatRule: RepeatRule
    
    var isCompleted: Bool = false
    var isFavourite: Bool = false
    
    var tags: [String]
    
    init (
        
        id: UUID = UUID(),
        title: String,
        description: String = "",
        category: String,
        dueDate: Date,
        
        notificationsEnabled: Bool = false,
        notifyBeforeMinutes: Int? = nil,
        
        repeatRule: RepeatRule = .none,
        
        isCompleted: Bool = false,
        isFavourite: Bool = false,
        
        tags: [String] = []
    ){
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.dueDate = dueDate
        self.notificationsEnabled = notificationsEnabled
        self.notifyBeforeMinutes = notifyBeforeMinutes
        self.repeatRule = repeatRule
        self.isCompleted = isCompleted
        self.isFavourite = isFavourite
        self.tags = tags
    }
}

enum RepeatRule: String, CaseIterable, Identifiable, Codable {
    
    case none = "Never"
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
    case yearly = "Yearly"
    
    var id: String { rawValue }
}
