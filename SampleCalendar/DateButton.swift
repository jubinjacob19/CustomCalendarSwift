//
//  DateButton.swift
//  SampleCalendar
//
//  Created by ram on 30/06/15.
//  Copyright (c) 2015 XYZ. All rights reserved.
//

import UIKit

protocol DateButtonDelegate{
    func selectedDate(date : Int , sender : DateButton)
}


let tagIndex = 1000

class DateButton: UIButton {
    
    private let cellWidth : CGFloat = 40.0
    private var cellDate : Int
    private let delegate : DateButtonDelegate
    private let borderThickness : CGFloat = 4.0
    private let btnEnabled : Bool
    private var highLightColor : UIColor?
    private var highlightView : HighlightView?
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    init(date:Int, enabled:Bool, delegate:DateButtonDelegate, color : UIColor?){
        
        self.cellDate = date
        self.delegate = delegate
        self.btnEnabled = enabled
        self.highLightColor = color
        super.init(frame: CGRectZero)
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.layer.borderColor = UIColor.brownColor().CGColor
        self.layer.borderWidth = 2.0
        let bgColor = self.btnEnabled ? UIColor.brownColor() : UIColor(red: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha: 1)
        self.enabled = self.btnEnabled
        self.setTitleColor(bgColor, forState: UIControlState.Normal)
        self.setTitle("\(cellDate)", forState: UIControlState.Normal)
        self.addTarget(self, action: Selector("onClick"), forControlEvents: UIControlEvents.TouchUpInside)
        if(self.highLightColor != nil){
            self.addHighlight()
        }
        self.tag = tagIndex + date
    
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        self.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.cellWidth))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0))
        
    }
    
    private func addHighlight(){
        self.highlightView =  HighlightView(radius: 7, color: self.highLightColor!)
        self.addSubview(self.highlightView!)
        self.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.highlightView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 5))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.highlightView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 5))
        
    }
    
    func reloadHighlight(color:UIColor){
        self.removeHighlight()
        self.updateHighlight(color)
    }
    
    func updateHighlight(color:UIColor){

        self.highLightColor = color
        self.addHighlight()
    }
    
    func removeHighlight(){
        self.highlightView?.removeFromSuperview()
    }
    
    func addTopBorder(){
        
        let border = self.getBorder()
        self.addSubview(border)
        let _borderLeading = NSLayoutConstraint(item: border, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
        let _borderTrailing = NSLayoutConstraint(item: border, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        let _borderTop = NSLayoutConstraint(item: border, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        let _borderHeight = NSLayoutConstraint(item: border, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.borderThickness)
        self.addConstraints([_borderHeight,_borderLeading,_borderTop,_borderTrailing])
        
        
    }
    
    func addLeftBorder(){
        let border = self.getBorder()
        self.addSubview(border)
        let _borderLeading = NSLayoutConstraint(item: border, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
        let _borderBottom = NSLayoutConstraint(item: border, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        let _borderTop = NSLayoutConstraint(item: border, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        let _borderWidth = NSLayoutConstraint(item: border, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.borderThickness)
        self.addConstraints([_borderWidth,_borderLeading,_borderTop,_borderBottom])
    }
    
    func addBottomBorder(){
        let border = self.getBorder()
        self.addSubview(border)
        let _borderLeading = NSLayoutConstraint(item: border, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
        let _borderTrailing = NSLayoutConstraint(item: border, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        let _borderBottom = NSLayoutConstraint(item: border, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        let _borderHeight = NSLayoutConstraint(item: border, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.borderThickness)
        self.addConstraints([_borderHeight,_borderLeading,_borderBottom,_borderTrailing])
    }
    
    func addRightBorder(){
        let border = self.getBorder()
        self.addSubview(border)
        let _borderTrailing = NSLayoutConstraint(item: border, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        let _borderBottom = NSLayoutConstraint(item: border, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        let _borderTop = NSLayoutConstraint(item: border, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        let _borderWidth = NSLayoutConstraint(item: border, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.borderThickness)
        self.addConstraints([_borderWidth,_borderTrailing,_borderTop,_borderBottom])
    }
    
    func highlight(){
        self.backgroundColor = UIColor.brownColor()
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    }
    func unHighlight(){
        self.backgroundColor = UIColor.whiteColor()
        self.setTitleColor(UIColor.brownColor(), forState: UIControlState.Normal)
    }
    
    private func getBorder()->UIView{
        let border = UIView()
        border.setTranslatesAutoresizingMaskIntoConstraints(false)
        border.backgroundColor = UIColor.brownColor()
        return border
    }
    
    func onClick() {
        self.highlight()
        self.delegate.selectedDate(self.cellDate,sender: self)
    }



}
