//
//  TagView.swift
//  SampleCalendar
//
//  Created by ram on 03/07/15.
//  Copyright (c) 2015 XYZ. All rights reserved.
//

import UIKit

class TagView: UIView {

    private var color : UIColor?
    private var radius : CGFloat?
    private var isSelected : Bool?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(radius : CGFloat, color : UIColor, isSelected : Bool){
        self.init(frame:CGRectZero)
        self.color = color
        self.radius = radius
        self.isSelected = isSelected
        self.backgroundColor = UIColor.clearColor()
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.userInteractionEnabled = false
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        self.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Width
            , relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.radius!))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Height
            , relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0))
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        if(self.isSelected == true){
            let outer : CGContextRef  = UIGraphicsGetCurrentContext();
            CGContextSetLineWidth(outer, 1.5);
            CGContextSetStrokeColorWithColor(outer, self.color?.CGColor);
            CGContextAddEllipseInRect(outer, CGRectMake(rect.origin.x + 5, rect.origin.y + 5, rect.size.width - 10, rect.size.height - 10));
            CGContextStrokePath(outer);
        }

        
        let inner : CGContextRef  = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(inner, 1.5);
        CGContextSetFillColorWithColor(inner, self.color?.CGColor);
        CGContextAddEllipseInRect(inner, CGRectMake(rect.origin.x + 10, rect.origin.y + 10, rect.size.width - 20, rect.size.height - 20));
        CGContextFillPath(inner);

    }
    
}
