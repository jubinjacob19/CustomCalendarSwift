//
//  LeftArrow.swift
//  SampleCalendar
//
//  Created by ram on 01/07/15.
//  Copyright (c) 2015 XYZ. All rights reserved.
//

import UIKit

protocol LeftArrowDelegate{
    func leftClicked()
}

class LeftArrow: UIButton {

    private let weight : CGFloat
    private let delegate : LeftArrowDelegate
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    init(weight:CGFloat, delegate:LeftArrowDelegate){
        self.weight = weight
        self.delegate = delegate
        super.init(frame: CGRectZero)
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addTarget(self, action: Selector("onClick"), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        self.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0))
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let width : CGFloat = self.frame.width
        let offset : CGFloat = 11.0
        let context = UIGraphicsGetCurrentContext()
        CGContextBeginPath(context)
        CGContextMoveToPoint(context, offset, offset)
        CGContextAddLineToPoint(context, self.weight + offset, offset)
        CGContextAddLineToPoint(context, width - offset, width/2)
        CGContextAddLineToPoint(context, self.weight + offset, width-offset)
        CGContextAddLineToPoint(context, offset, width-offset)
        CGContextAddLineToPoint(context, (width-offset) - self.weight, width/2)
        CGContextAddLineToPoint(context, offset, offset)
        CGContextSetFillColorWithColor(context, UIColor.brownColor().CGColor)
        CGContextFillPath(context)
    }
    
    func onClick(){
        self.delegate.leftClicked()
    }
    

}
