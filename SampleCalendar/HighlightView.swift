//
//  HighlightView.swift
//  SampleCalendar
//
//  Created by ram on 06/07/15.
//  Copyright (c) 2015 XYZ. All rights reserved.
//

import UIKit

class HighlightView: UIView {

    private var color : UIColor?
    private var radius : CGFloat?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(radius : CGFloat, color : UIColor){
        self.init(frame:CGRectZero)
        self.color = color
        self.radius = radius
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
     
        
        
        let inner : CGContextRef  = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(inner, 1.5);
        CGContextSetFillColorWithColor(inner, self.color?.CGColor);
        CGContextAddEllipseInRect(inner, CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height));
        CGContextFillPath(inner);
        
    }

}
