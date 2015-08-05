//
//  CalendarView.swift
//  SampleCalendar
//
//  Created by ram on 30/06/15.
//  Copyright (c) 2015 XYZ. All rights reserved.
//

import UIKit
import CoreData

protocol CalendarDelegate{
    func clickedDate()
    func enableAddButton()
    func disableAddButton()
}

class CalendarView: UIView,DateButtonDelegate,LeftArrowDelegate,RightArrowDelegate {
    
    var parent : CalendarDelegate?
    private let columns = 7
    private let originX : CGFloat = 0.0
    private let weekDaysHeight : CGFloat = 30.0
    private let originY : CGFloat = 100.0
    private let buttonWidth : CGFloat = 40.0
    
    private lazy var gregorian : NSCalendar = {
        let gregorian = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        gregorian.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        return gregorian
    }()
    
    lazy var calendarDate : NSDate = {
        var reduceComponents = self.gregorian.components((NSCalendarUnit.CalendarUnitEra | NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitDay ), fromDate: NSDate())
        var calendarDate = self.gregorian.dateFromComponents(reduceComponents)!
        return calendarDate

    }()
    private lazy var selectedMonth : Int = {
        return  self.gregorian.components((NSCalendarUnit.CalendarUnitEra | NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitDay), fromDate: self.calendarDate).month
    }()
    
    
    private lazy var selectedDate : Int = {
        return  self.gregorian.components((NSCalendarUnit.CalendarUnitEra | NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitDay), fromDate: self.calendarDate).day
    }()
    
    private lazy var selectedYear : Int = {
        return  self.gregorian.components((NSCalendarUnit.CalendarUnitEra | NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitDay), fromDate: self.calendarDate).year
    }()
    
    private lazy var weekDaySymbols :[String] = {
        return NSDateFormatter().shortWeekdaySymbols as! [String]
    }()
    private var selectedDateButton : DateButton?
    
    
    
    
    override init(frame: CGRect) {
        
        super.init(frame:CGRectZero)
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: (7 * buttonWidth)))
        
    }
    
     convenience init(parent : CalendarDelegate){
        
        self.init(frame:CGRectZero)
        self.addModelObservers()
        self.parent = parent
        self.addSubviews()
    }
    
    func addModelObservers(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("noteInserted:"), name:InsertedModelNotification , object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("noteUpdated:"), name:UpdatedModelNotification , object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("noteDeleted:"), name:DeletedModelNotification , object:nil)
    }
    
    func noteInserted(notification:NSNotification){
        let insertedNote = self.noteForNotification(notification, key: InsertedModelKey)!
        self.getDateButtonForNote(insertedNote).updateHighlight(insertedNote.color as! UIColor)
    }
    func noteUpdated(notification:NSNotification){
        let updatedNote = self.noteForNotification(notification, key: UpdatedModelKey)
        self.getDateButtonForNote(updatedNote!).reloadHighlight(updatedNote?.color as! UIColor)
    }
    func noteDeleted(notification:NSNotification){
        let deletedNote = self.noteForNotification(notification, key: DeletedModelKey)
        self.getDateButtonForNote(deletedNote!).removeHighlight()
    }
    
    func noteForNotification(notification : NSNotification, key : NSString)->(Note?){
        let dict : NSDictionary = notification.userInfo!
        let modelSet : Set = dict[key] as! Set<Note>
        return modelSet.first
        
    }
    
    func getDateButtonForNote(note:Note)->(DateButton){
        let components = self.gregorian.components(NSCalendarUnit.CalendarUnitEra | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitDay, fromDate: note.createdOn)
        let dateBtn : DateButton = self.viewWithTag(components.day + tagIndex) as! DateButton!
        return dateBtn
    }
    
    private func addSubviews(){
        self.parent?.disableAddButton()
        self.addTitle()
        self.addWeekDays()
        self.addDates()
    }
    
        
    
    private func addTitle(){
        let titleLabel = UILabel()
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        let dateFmtr = NSDateFormatter()
        dateFmtr.dateFormat = "MMMM yyyy"
        
        self.addSubview(titleLabel)
        self.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 40))
        titleLabel.text = dateFmtr.stringFromDate(self.calendarDate).uppercaseString
        titleLabel.font = UIFont(name: "Helvetica-Bold", size: 15)
        titleLabel.textColor = UIColor.brownColor()
        
        let left = LeftArrow(weight: 5, delegate: self)
        self.addSubview(left)
        self.addConstraint(NSLayoutConstraint(item: left, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: titleLabel, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: left, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: titleLabel, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: left, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: titleLabel, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0))
        
        let right = RightArrow(weight: 5, delegate: self)
        self.addSubview(right)
        self.addConstraint(NSLayoutConstraint(item: right, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: titleLabel, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: right, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: titleLabel, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: right, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: titleLabel, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0))
        
    }
    
    private func addWeekDays(){
        for (index,weekDay) in enumerate(self.weekDaySymbols){
            var label = UILabel()
            label.setTranslatesAutoresizingMaskIntoConstraints(false)
            label.textAlignment = NSTextAlignment.Center
            label.textColor = UIColor.brownColor()
            self.addSubview(label)
            label.text = weekDay
            let _labelLeading = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: originX + CGFloat(index*40))
            let _labelTop = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: originY)
            let _labelWidth = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.buttonWidth)
            self.addConstraints([_labelLeading,_labelTop,_labelWidth])
            
            
        }

    }
    
    private func addDates(){
        
        let components = self.gregorian.components(NSCalendarUnit.CalendarUnitEra | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitDay, fromDate: self.calendarDate)
        self.selectedDate - components.day
        components.day = 1;
        let firsDayOfMonth = self.gregorian.dateFromComponents(components)
        let newComponents : NSDateComponents = self.gregorian.components(NSCalendarUnit.CalendarUnitWeekday, fromDate: firsDayOfMonth!)
        var weekDay = newComponents.weekday
        weekDay -= 2
        if(weekDay<0){
            weekDay += 7
        }
        let calendar = NSCalendar.currentCalendar()
        let days = calendar.rangeOfUnit(NSCalendarUnit.CalendarUnitDay, inUnit: NSCalendarUnit.CalendarUnitMonth, forDate: self.calendarDate)
        let monthLength = days.length
        
        let allNotes : [Note] = CoreDataManager.sharedInstance.getNotesBetween(firsDayOfMonth!, endDate: self.calendarDate.dateByAddingTimeInterval (Double(monthLength * 24 * 60 * 60)))
        
        for i in 0..<monthLength{
            
            let dateComponents = self.gregorian.components(NSCalendarUnit.CalendarUnitEra | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitDay, fromDate: self.calendarDate)
            dateComponents.day = i+1
            let filteredNotes : [Note] = allNotes.filter{$0.createdOn == self.gregorian.dateFromComponents(dateComponents)}
            let note : Note? = filteredNotes.first
            var highlightColor : UIColor?
            if(note != nil){
               highlightColor = note?.color as? UIColor
            }else{
                highlightColor = nil
            }
            let dateBtn = DateButton(date: (i+1), enabled: true, delegate: self, color: highlightColor)
            self.addSubview(dateBtn)
            let _xOffset = self.buttonWidth * CGFloat(((i+weekDay)%columns))
            let _yOffset = self.buttonWidth * CGFloat((i+weekDay)/columns)
            
            let _btnLeading = NSLayoutConstraint(item: dateBtn, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: self.originX + _xOffset)
            let _btnTop = NSLayoutConstraint(item: dateBtn, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.originY + self.weekDaysHeight + _yOffset)
            self.addConstraints([_btnLeading,_btnTop])
           
            if(((i+weekDay)/columns)==0){
                dateBtn.addTopBorder()
            }
            if(((i+weekDay)/columns)==((monthLength+weekDay-1)/columns)){
                dateBtn.addBottomBorder()
            }
          

            if((i+weekDay)%7==0){
                dateBtn.addLeftBorder()
            }
            else if((i+weekDay)%7==6){
                dateBtn.addRightBorder()
            }
            
            if(i+1 == self.selectedDate && components.month == self.selectedMonth && components.year == self.selectedYear)
            {
                dateBtn.highlight()
                self.selectedDateButton = dateBtn
                self.parent?.enableAddButton()
            }

        }
        let previousMonthComponents = self.gregorian.components(NSCalendarUnit.CalendarUnitEra | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitDay, fromDate: self.calendarDate)
        previousMonthComponents.month -= 1
        let previousMonthDate = self.gregorian.dateFromComponents(previousMonthComponents)
        let previousMonthDays : NSRange = calendar.rangeOfUnit(NSCalendarUnit.CalendarUnitDay, inUnit: NSCalendarUnit.CalendarUnitMonth, forDate: previousMonthDate!)
        let maxDate = previousMonthDays.length - weekDay
        for i in 0..<weekDay{
            
            let dateBtn = DateButton(date: (maxDate+i+1), enabled: false, delegate: self, color: nil)
            self.addSubview(dateBtn)
            let _xOffset = self.buttonWidth * CGFloat(i%columns)
            let _yOffset = self.buttonWidth * CGFloat(i/columns)
            let _btnLeading = NSLayoutConstraint(item: dateBtn, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: self.originX + _xOffset)
            let _btnTop = NSLayoutConstraint(item: dateBtn, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.originY + self.weekDaysHeight + _yOffset)
            self.addConstraints([_btnLeading,_btnTop])
            if(i == 0){
                dateBtn.addLeftBorder()
            }
            dateBtn.addTopBorder()
            
        }
        
        let remainingDays = (monthLength + weekDay) % columns
        if(remainingDays>0){
            for i in remainingDays..<columns{
                let dateBtn = DateButton(date: (i+1)-remainingDays, enabled: false, delegate: self, color: nil)
                self.addSubview(dateBtn)
                let _xOffset = self.buttonWidth * CGFloat(i%columns)
                let _yOffset = self.buttonWidth * CGFloat((monthLength+weekDay)/columns)
                let _btnLeading = NSLayoutConstraint(item: dateBtn, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: self.originX + _xOffset)
                let _btnTop = NSLayoutConstraint(item: dateBtn, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.originY + self.weekDaysHeight + _yOffset)
                self.addConstraints([_btnLeading,_btnTop])
                if(i==columns - 1){
                    dateBtn.addRightBorder()
                }
                dateBtn.addBottomBorder()

            }
        }
        
    }
    
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    override func layoutSubviews() {
        
        super.layoutSubviews()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
    }
    
    func selectedDate(date: Int, sender: DateButton) {
        if(self.selectedDate != date){
            self.selectedDate = date
            self.selectedDateButton?.unHighlight()
            self.selectedDateButton = sender
            var components : NSDateComponents = gregorian.components((NSCalendarUnit.CalendarUnitEra | NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitDay), fromDate: self.calendarDate)
            components.day = date
            self.calendarDate = self.gregorian.dateFromComponents(components)!
            self.parent?.enableAddButton()
        }

    }
    
    func leftClicked() {
        var components : NSDateComponents = gregorian.components((NSCalendarUnit.CalendarUnitEra | NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitDay), fromDate: self.calendarDate)
        components.day = 1
        components.month += 1
        self.calendarDate = self.gregorian.dateFromComponents(components)!
            for view in self.subviews as! [UIView] {
            view.removeFromSuperview()
        }
        self.addSubviews()
    }
    
    func rightClicked() {
        var components : NSDateComponents = gregorian.components((NSCalendarUnit.CalendarUnitEra | NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitDay), fromDate: self.calendarDate)
        components.day = 1
        components.month -= 1
        self.calendarDate = self.gregorian.dateFromComponents(components)!
        for view in self.subviews as! [UIView] {
            view.removeFromSuperview()
        }
        self.addSubviews()

    }
    
}
