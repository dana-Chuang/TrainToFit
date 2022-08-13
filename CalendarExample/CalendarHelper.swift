import Foundation
import UIKit

class CalendarHelper
{
    //calendar uses your local time zone to get the component from date
    let calendar = Calendar.current
    
    func plusMonth(date: Date) -> Date
    {
        return calendar.date(byAdding: .month, value: 1, to: date)!
    }
    
    func minusMonth(date: Date) -> Date
    {
        return calendar.date(byAdding: .month, value: -1, to: date)!
    }
    
    func monthString(date: Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL" //January/February/March/April...
        return dateFormatter.string(from: date)
    }
    
    func yearString(date: Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }
    
    func daysInMonth(date: Date) -> Int
    {
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count //January -> 31, April -> 30
    }
    
    func dayOfMonth(date: Date) -> Int
    {
        //for example
        //input: 2 Jan 2020
        //result: 2
        let components = calendar.dateComponents([.day], from: date)
        return components.day!
    }
    
    func firstOfMonth(date: Date) -> Date
    {
        //for example
        //input: 15 Jan 2020
        //result: 1 Jan 2020
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components)!
    }
    
    func weekDay(date: Date) -> Int
    {
        //for example
        //input: 1 Jan 2021
        //result: 5 (Friday)
        let components = calendar.dateComponents([.weekday], from: date)
        return components.weekday! - 1
    }
}
