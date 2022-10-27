import Foundation

extension Date {
    
    func descriptiveString(style: DateFormatter.Style = .short) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        
        let daysBetween = daysBetween(date: Date())
        
        if daysBetween == 0 {
            return "Today"
        } else if daysBetween == 1 {
            return "Yesterday"
        } else if daysBetween < 5 {
            let weekdayIndex = Calendar.current.component(.weekday, from: self) - 1
            return formatter.weekdaySymbols[weekdayIndex]
        }
        return formatter.string(from: self)
    }
    
    func daysBetween(date: Date) -> Int {
        let calendar = Calendar.current
        let firstDate = calendar.startOfDay(for: self)
        let lastDate = calendar.startOfDay(for: date)
        if let daysBetween = calendar.dateComponents([.day], from: firstDate, to: lastDate).day {
            return daysBetween
        }
        return 0
    }
}
