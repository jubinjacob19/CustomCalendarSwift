//
//  ViewController.swift
//  SampleCalendar
//
//  Created by ram on 30/06/15.
//  Copyright (c) 2015 XYZ. All rights reserved.
//

import UIKit


class ViewController: UIViewController,CalendarDelegate {

    lazy var calendar : CalendarView = {
        return CalendarView(parent: self)
    }()
    
    private lazy var reminderBarButton : UIBarButtonItem = {
        let addButton : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addReminder")
        addButton.enabled = false
        return addButton

    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder )
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.brownColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as [NSObject : AnyObject]
        self.title = "CALENDAR"
        self.addReminderButton()
        self.view.addSubview(self.calendar)
        let _heightConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.LessThanOrEqual, toItem: self.calendar, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        let _centreX = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.calendar, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let _top = NSLayoutConstraint(item: self.calendar, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 90)
        self.view.addConstraints([_heightConstraint,_centreX,_top])

        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    private func addReminderButton(){
        self.navigationItem.rightBarButtonItem = self.reminderBarButton
    }
    
    func addReminder(){
        self.navigationController?.pushViewController(NoteViewController(date: self.calendar.calendarDate), animated: true)
    }
    
    
    
    func clickedDate() {
        
    }
    
    func enableAddButton() {
        self.reminderBarButton.enabled = true
    }
    
    func disableAddButton() {
        self.reminderBarButton.enabled = false
    }

    
   
}

