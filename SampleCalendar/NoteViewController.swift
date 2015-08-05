//
//  NoteViewController.swift
//  SampleCalendar
//
//  Created by ram on 03/07/15.
//  Copyright (c) 2015 XYZ. All rights reserved.
//

import UIKit

enum TagColors{
    case Green
    case Blue
    case Red
    case Gray
    
    static let allColors : [TagColors]  = [Green,Blue,Red,Gray]
    
    var color : UIColor? {
        get {
            switch(self){
            case .Green : return UIColor.greenColor()
            case .Blue : return UIColor.blueColor()
            case .Red : return UIColor.redColor()
            case .Gray : return UIColor.grayColor()
            }
        }
    }
}

class NoteViewController: UIViewController,UITextFieldDelegate,TagButtonDelegate,UITextViewDelegate {
    
    var date : NSDate?
    var selectedTag : TagButton?
    private var discardedNote : Bool = false
    private var selectedColor : UIColor?
    private var selectedNote : Note?
    private lazy var titleField : UITextField = {
       var textField = UITextField()
       textField.placeholder = "Title"
       textField.setTranslatesAutoresizingMaskIntoConstraints(false)
       textField.textColor = UIColor.brownColor()
       textField.font = UIFont(name: "Helvetica-Bold", size: 16)
       textField.delegate = self
       return textField
    }()
    
    private var dateFormatter : NSDateFormatter = {
        let dateFmtr = NSDateFormatter()
        dateFmtr.dateFormat = "dd MMMM yyyy"
        return dateFmtr
    }()
    
    private lazy var noteDescription : UITextView = {
        var textView = UITextView()
        textView.setTranslatesAutoresizingMaskIntoConstraints(false)
        textView.textColor = UIColor.lightGrayColor()
        textView.font = UIFont(name: "Helvetica", size: 14)
        textView.text = "Note"
        textView.delegate = self
        return textView
        }()


    convenience init(date : NSDate){
        self.init(nibName: nil, bundle: nil)
        self.date = date
        self.title = self.dateFormatter.stringFromDate(self.date!)
        self.selectedNote = CoreDataManager.sharedInstance.getNote(self.date!).note
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder )
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let trashButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Trash, target: self, action: "discardNote")
        self.navigationItem.rightBarButtonItem = trashButton
        self.view.backgroundColor = UIColor.whiteColor()
        self.addSubviews()
        self.setLayoutConstraints()

        // Do any additional setup after loading the view.
    }
    
    func addSubviews(){
        self.view.addSubview(self.titleField)
        self.view.addSubview(self.noteDescription)
        self.titleField.becomeFirstResponder()
        self.addTagOptions()
        if(self.selectedNote != nil){
            self.titleField.text = self.selectedNote?.title
            self.noteDescription.text = self.selectedNote?.noteDescription
        }
    }
    
    func setLayoutConstraints(){
        
        self.view.addConstraint(NSLayoutConstraint(item: self.titleField, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 160))
        self.view.addConstraint(NSLayoutConstraint(item: self.titleField, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 20))
        self.view.addConstraint(NSLayoutConstraint(item: self.titleField, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 20))
        self.view.addConstraint(NSLayoutConstraint(item: self.noteDescription, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.titleField, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 10))
        self.view.addConstraint(NSLayoutConstraint(item: self.noteDescription, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.titleField, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: -5))
        self.view.addConstraint(NSLayoutConstraint(item: self.noteDescription, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.noteDescription, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 80))
        

    }
    
    func addTagOptions(){
        
        for (index, value) in enumerate(TagColors.allColors){
           
            var selected : Bool? = false
            if(self.selectedNote == nil){
                selected = (index == 0)
            } else{
                let color : UIColor = value.color!
                var dbColor : UIColor?  = self.selectedNote?.color as! UIColor!
                selected = (color == dbColor)
            }
            let tagView : TagButton = TagButton(radius: 50, color: value.color!, isSelected: selected!, delegate : self)
            if(selected == true){
                self.selectedTag = tagView
                self.selectedColor = value.color
            }
            self.view.addSubview(tagView)
            self.view.addConstraint(NSLayoutConstraint(item: tagView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: CGFloat(50 * (index+1))))
            self.view.addConstraint(NSLayoutConstraint(item: tagView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 80))
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selectedTagWthColor(color: UIColor, sender: TagButton) {
        self.selectedTag?.markUnSelected()
        self.selectedTag = sender
        self.selectedColor = color
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if(true){
            textView.textColor = UIColor.blackColor()
            textView.text = ""
        }
        return true
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if(textView.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) == ""){
            textView.textColor = UIColor.lightGrayColor()
            textView.text = "Note"
        }
    }
    
    func discardNote(){
        self.discardedNote = true
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if(self.isMovingFromParentViewController()){
                if(!self.discardedNote){
                    if(self.selectedNote != nil){
                        CoreDataManager.sharedInstance.modifyNote(self.selectedNote!, title : self.titleField.text, noteDescripton: self.noteDescription.text, date: self.date!, color: self.selectedColor!)
                    }else{
                        CoreDataManager.sharedInstance.addNote(self.titleField.text, noteDescripton: self.noteDescription.text, date: self.date!, color: self.selectedColor!)
                    }
                    
                }else{
                    if(self.selectedNote != nil){
                        CoreDataManager.sharedInstance.deleteNote(self.selectedNote!)
                    }
                }
            }
        }
    }
    


