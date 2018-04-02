//
//  ViewController.swift
//  DayFinderPuzzle
//
//  Created by Juber Moulvi Abdul on 29/03/18.
//  Copyright © 2018 Juber Moulvi Abdul. All rights reserved.
//

import UIKit


enum Month: Int {
    case Jan = 1, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec
}

enum Date:Int {
    case TwentyNine = 29
    case Thirty = 30
    case ThirtyOne = 31
}

class ViewController: UIViewController {
    
    let centuryArray = [0, 5, 3, 1] // Century codes
    let monthNormalYearArray = [0, 3, 3, 6, 1, 4, 6, 2, 5, 0, 3, 5] // Month Codes for normal year
    let dayArray = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"] // Day codes
    
    let days_in_a_week = 7 // Number of days in a week
    let leap_year = 4   // Every fourth year the leap year comes
    let leap_year_repeat = 400 // Every 400th year the whole calendar repeats
    let century = 100 //  1 Century
    
    let odd_days_normal_year = 1 // Number of odd days in one normal year - 365 days
    let odd_days_leap_year = 2 // Number of leap days in one normal year - 366 days
    
    let min_month = 1 // First month January
    let max_month = 12 // Last month December
    
    let min_year = 1 // First year
    let max_year = 3000 // Last year
    
    let min_day = 1 // First Day of the month
    let max_day = 31 // Last Day of the months
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Get the random date
        
        for var i in (0...10){
            var randomDate = (1, 1, 1)
            randomDate = getRandomDate()
            
            let yearR = randomDate.0
            let monthR = randomDate.1
            let dayR = randomDate.2
            
            // Get the day of the random date
            print("DD/MM/YYYY :\(dayR)/\(monthR)/\(yearR)")
            let day = dayFinder(year: yearR, month: monthR, date: dayR)
            //  let day = dayFinder(year: 1947, month: 8, date: 15)
            print(day)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getRandomDate() -> (c: Int, y: Int,m:Int){
        // Generate Random Numbers
        let randomYear = getRandomYear()
        let randomMonth = getRandomMonth()
        let randomDay = getRandomDay()
        
        // Check if it is a leap year or not...
        if !isLeapYear(year:randomYear){
            // It is not a leap year
            // Check Generated Random Numbers are valid or not...
            if (((randomMonth == Month.Feb.rawValue) && (randomDay == Date.TwentyNine.rawValue || randomDay == Date.Thirty.rawValue || randomDay == Date.ThirtyOne.rawValue)) ||
                ((randomMonth == Month.Apr.rawValue || randomMonth == Month.Jun.rawValue || randomMonth == Month.Sep.rawValue || randomMonth == Month.Nov.rawValue) && (randomDay == Date.ThirtyOne.rawValue))
                ){
                
                let _ = getRandomDate()
            }
            return(randomYear,randomMonth,randomDay)
        }
        else {
            // It is a leap year
            if (((randomMonth == Month.Feb.rawValue) && (randomDay == Date.Thirty.rawValue || randomDay == Date.ThirtyOne.rawValue)) ||
                ((randomMonth == Month.Apr.rawValue || randomMonth == Month.Jun.rawValue || randomMonth == Month.Sep.rawValue || randomMonth == Month.Nov.rawValue) && (randomDay == Date.ThirtyOne.rawValue))
                ){
                
              let _ = getRandomDate()
            }
            return(randomYear,randomMonth,randomDay)
        }
    }
    
    func getRandomYear() -> Int{
        return Int.random(interval: min_year...max_year)
    }
    
    func getRandomMonth() -> Int{
        return Int.random(interval: min_month...max_month)
    }
    
    func getRandomDay() -> Int{
        return Int.random(interval: min_day...max_day)
    }
    
    func isLeapYear(year: Int) -> Bool{
        return ((year % leap_year_repeat == 0 ) || ((year % century != 0 ) && (year % leap_year == 0))) ? true:false
    }
    
    func dayFinder(year:Int, month:Int, date:Int) -> String{
        
        var fullYear = (1, 1)
        // Split the given year into Century and Year
        fullYear = getCenturyAndYear(year: year)
        let century = fullYear.0 // Century Value
        let year = fullYear.1 - 1 // Year Value (Take the previous year)

        var monthCode = 0
        let centuryCode = centuryArray[ century % leap_year] // Century Code for the given century
        let leay_year_odd_days = ( (year / leap_year ) * odd_days_leap_year) // Leap Year Odd Days for given year
        let normal_year_odd_days = (year - ( year / leap_year ) )*odd_days_normal_year // Normal Year Odd Days for given Year
        let yearCode = ( leay_year_odd_days + normal_year_odd_days ) % days_in_a_week // Total Odd Days for given Year
    
        if !(isLeapYear(year:year+1) && ((month == Month.Mar.rawValue) || (month == Month.Apr.rawValue) || (month == Month.May.rawValue) || (month == Month.Jun.rawValue) || (month == Month.Jul.rawValue) || (month == Month.Aug.rawValue) || (month == Month.Sep.rawValue) || (month == Month.Oct.rawValue) || (month == Month.Nov.rawValue) || (month == Month.Dec.rawValue))){
            monthCode = monthNormalYearArray[month-1]
        } else {
            monthCode = monthNormalYearArray[month-1]+1
        }
        
        let dateCode = date
        let totalCode = (centuryCode + yearCode + monthCode + dateCode) % days_in_a_week
        return dayArray[totalCode]
    }
    
    func getCenturyAndYear(year:Int) -> (ct: Int, yrr: Int) {
        let yr = getLastNDigits(number: year, digits: 2)
        let cetry = (year - yr)/Int(pow(Double(10), Double(2)))
        return (cetry, yr)
    }
    
    func getLastNDigits(number:Int, digits:Int) -> Int {
        return number%Int(pow(Double(10), Double(digits)))
    }
}

extension Int {
    
    /// Generates a random `Int` inside of the closed interval.
    public static func random(interval: ClosedRange<Int>) -> Int {
        return interval.lowerBound + Int(arc4random_uniform(UInt32(interval.upperBound - interval.lowerBound + 1)))
    }
}
