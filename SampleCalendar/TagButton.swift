//
//  TagButton.swift
//  SampleCalendar
//
//  Created by ram on 03/07/15.
//  Copyright (c) 2015 XYZ. All rights reserved.
//

import UIKit

protocol TagButtonDelegate{
    func selectedTagWthColor(color:UIColor , sender : TagButton)
}

class TagButton: UIButton {

    var color : UIColor?
    private var radius : CGFloat?
    var isSelected : Bool?
    private var innerTag : TagView?
    private var delegate : TagButtonDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(radius : CGFloat, color : UIColor, isSelected : Bool, delegate : TagButtonDelegate){
        self.init(frame:CGRectZero)
        self.color = color
        self.radius = radius
        self.isSelected = isSelected
        self.delegate = delegate
        self.backgroundColor = UIColor.clearColor()
        self.innerTag = TagView(radius: radius, color: color, isSelected: isSelected)
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addTarget(self, action: Selector("onClick"), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(self.innerTag!)
        self.setLayoutConstraints()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
     func setLayoutConstraints() {
        super.updateConstraints()
        self.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Width
            , relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.radius!))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Height
            , relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.innerTag!, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.innerTag!, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
    }
    

    
    func onClick(){
        if(self.isSelected == false){
            self.isSelected   = true
            self.delegate?.selectedTagWthColor(self.color!, sender: self)
            self.reloadView()
        }
    }
    
    func markUnSelected(){
        self.isSelected   = false
        self.reloadView()
    }
    
    func reloadView(){
        self.innerTag?.removeFromSuperview()
        self.innerTag = TagView(radius: self.radius!, color: self.color! , isSelected: self.isSelected!)
        self.addSubview(self.innerTag!)
        self.setLayoutConstraints()
    }
    
}
