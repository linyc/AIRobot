//
//  ViewController.swift
//  AIRobot
//
//  Created by yuecang on 15/12/7.
//  Copyright © 2015年 LINYC. All rights reserved.
//

import UIKit
import Alamofire
import Parse
import SafariServices

let messageFontSize:CGFloat = 17
let toolBarMinHeight:CGFloat = 44

let textViewMaxHeight: (portrait: CGFloat, landscape: CGFloat) = (portrait: 272, landscape: 90)

class ViewController: UITableViewController ,UITextViewDelegate,SFSafariViewControllerDelegate{

    var toolBar:UIToolbar!
    var textView:UITextView!
    var sendButton:UIButton!
    
    var messages:[[Message]]!
    
    override var inputAccessoryView:UIView!{
        get{
            if toolBar == nil{
                toolBar = UIToolbar(frame: CGRectMake(0,0,UIScreen.mainScreen().bounds.size.width,toolBarMinHeight-0.5))
                
                textView = InputTextView(frame:CGRectZero)
                textView.backgroundColor = UIColor(white: 250/255, alpha: 1)
                textView.delegate = self
                textView.font = UIFont.systemFontOfSize(messageFontSize)
                textView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha: 1).CGColor
                textView.layer.borderWidth = 0.5
                textView.layer.cornerRadius = 5
                textView.scrollsToTop = false
                textView.textContainerInset = UIEdgeInsetsMake(4, 3, 3, 3)
                toolBar.addSubview(textView)
                
                sendButton = UIButton(type: .System)
                sendButton.enabled = false
                sendButton.titleLabel?.font = UIFont.boldSystemFontOfSize(15)
                sendButton.setTitle("发送", forState: .Normal)
                sendButton.setTitleColor(UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1), forState: .Disabled)
                sendButton.setTitleColor(UIColor(red: 0.05, green: 0.47, blue: 0.91, alpha: 1.0), forState: .Normal)
                sendButton.contentEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6)
                sendButton.addTarget(self, action: "sendAction", forControlEvents: .TouchUpInside)
                toolBar.addSubview(sendButton)
                
                textView.translatesAutoresizingMaskIntoConstraints = false
                sendButton.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint(item: textView, attribute: .Leading, relatedBy: .Equal, toItem: toolBar, attribute: .Leading, multiplier: 1, constant: 8).active = true
                NSLayoutConstraint(item: textView, attribute: .Top, relatedBy: .Equal, toItem: toolBar, attribute: .Top, multiplier: 1, constant: 7.5).active = true
                NSLayoutConstraint(item: textView, attribute: .Trailing, relatedBy: .Equal, toItem: sendButton, attribute: .Leading, multiplier: 1, constant: -2).active = true
                NSLayoutConstraint(item: textView, attribute: .Bottom, relatedBy: .Equal, toItem: toolBar, attribute: .Bottom, multiplier: 1, constant: -8).active = true
                
                NSLayoutConstraint(item: sendButton, attribute: .Trailing, relatedBy: .Equal, toItem: toolBar, attribute: .Trailing, multiplier: 1, constant: 0).active = true
                NSLayoutConstraint(item: sendButton, attribute: .Top, relatedBy: .Equal, toItem: toolBar, attribute: .Top, multiplier: 1, constant: 4.5).active = true
                NSLayoutConstraint(item: sendButton, attribute: .Bottom, relatedBy: .Equal, toItem: toolBar, attribute: .Bottom, multiplier: 1, constant: -4.5).active = true
            }
            
            return toolBar;
        }
    }
    
    func saveMessage(message:Message){
        var saveObj = PFObject(className: "Messages")
        saveObj["incoming"] = message.incoming
        saveObj["text"] = message.text
        saveObj["sentDate"] = message.sentDate
        saveObj["url"] = message.url==nil ? "" : message.url
        saveObj["createdBy"] = PFUser.currentUser()
        saveObj.saveEventually { (success, error) -> Void in
            if success{
                print("Save to server success")
            }
            else{
                print("Save to server fail:\(error)")
            }
        }
    }

    func sendAction(){
        var sentMsg = Message(incoming: false, text: self.textView.text, sentDate: NSDate())
        self.messages.append([sentMsg])
        self.saveMessage(sentMsg)
        
        var question = self.textView.text
        self.textView.text = nil
        updateTextViewHeight()
        self.sendButton.enabled = false
        
        let lastSection = self.tableView.numberOfSections
        self.tableView.beginUpdates()
        self.tableView.insertSections(NSIndexSet(index: lastSection), withRowAnimation: .Automatic)
        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: lastSection),NSIndexPath(forRow: 1, inSection: lastSection)], withRowAnimation: .Automatic)
        self.tableView.endUpdates()
        tableViewScrollToBottomAnimated(true)
        
        
//        这种也可以
//        Alamofire.request(.GET, NSURL(string: api_url)!, parameters: ["key":api_key,"info":question,"userid":userId]).response { (_,_,data,error) -> Void in
        
        Alamofire.request(.GET, NSURL(string: api_url)!, parameters: ["key":api_key,"info":question,"userid":userId]).responseJSON(options: .MutableContainers) { response in
        
            guard response.result.error == nil else{
                print("Error occured! \(response.result.error?.userInfo)")
                return
            }
            
            do{
                let d = try NSJSONSerialization.JSONObjectWithData(response.data!, options: NSJSONReadingOptions())
                
                guard let text = d.valueForKey("text") as? String else{
                    return
                }
                //                    self.messages[lastSection].append(Message(incoming: true, text: text, sentDate: NSDate()))
                if let url = d.valueForKey("url") as? String{
                    var msg = Message(incoming: true, text: text+"\n(点击查看消息)", sentDate: NSDate())
                    msg.url = url
                    self.messages[lastSection].append(msg)
                }
                else{
                    var msg = Message(incoming: true, text: text, sentDate: NSDate())
                    self.messages[lastSection].append(msg)
                }
                self.tableView.beginUpdates()
                self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 2, inSection: lastSection)], withRowAnimation: .Automatic)
                self.tableView.endUpdates()
                self.tableViewScrollToBottomAnimated(true)
            }
            catch is ErrorType{
                print("try error: \(ErrorType.self)")
            }
        }
    }

    func updateTextViewHeight(){
        let oldHeight = self.tableView.frame.height
        let maxHeight = UIInterfaceOrientationIsPortrait(interfaceOrientation) ? textViewMaxHeight.portrait : textViewMaxHeight.landscape
        var newHeight = min(textView.sizeThatFits(CGSize(width: self.textView.frame.width, height: CGFloat.max)).height, maxHeight)
        #if arch(x86_64) || arch(arm64)
            newHeight = ceil(newHeight)
        #else
            newHeight = CGFloat(ceilf(newHeight.native))
        #endif
        
        if newHeight != oldHeight{
            toolBar.frame.size.height = newHeight + 8 * 2 - 0.5
        }
    }
    func tableViewScrollToBottomAnimated(animated: Bool){
        let sectionCount = self.tableView.numberOfSections
        let rowCount = messages[sectionCount-1].count
        if rowCount>0{
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: rowCount, inSection: sectionCount-1), atScrollPosition: .Bottom, animated: animated)
        }
    }
    
    
    func textViewDidChange(textView: UITextView) {
        self.updateTextViewHeight()
        self.sendButton.enabled = textView.hasText()
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    func firstView()->CAShapeLayer{
        let layer = CAShapeLayer()
        
        let star1Path = UIBezierPath()
        star1Path.moveToPoint(CGPointMake(164.43, 243.35))
        star1Path.addLineToPoint(CGPointMake(79.49, 288))
        star1Path.addLineToPoint(CGPointMake(95.71, 193.42))
        star1Path.addLineToPoint(CGPointMake(27, 126.44))
        star1Path.addLineToPoint(CGPointMake(121.96, 112.65))
        star1Path.addLineToPoint(CGPointMake(164.43, 26.6))
        star1Path.addLineToPoint(CGPointMake(206.9, 112.65))
        star1Path.addLineToPoint(CGPointMake(301.86, 126.44))
        star1Path.addLineToPoint(CGPointMake(233.14, 193.42))
        star1Path.addLineToPoint(CGPointMake(249.36, 288))
        star1Path.addLineToPoint(CGPointMake(164.43, 243.35))
        star1Path.closePath()
        
        layer.path = star1Path.CGPath
        layer.bounds = CGPathGetBoundingBox(layer.path)
        
        return layer
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = firstView()
//        logo.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).CGColor
        logo.fillColor = UIColor(red: 0, green: 0, blue: 3, alpha: 0.2).CGColor
        logo.position = CGPoint(x: self.tableView.bounds.width/2, y: self.tableView.bounds.height/2)
        
        self.navigationController?.view.layer.addSublayer(logo)

        self.tableView.registerClass(MessageSentDateTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(MessageSentDateTableViewCell))
        
        self.tableView.keyboardDismissMode = .Interactive
        self.tableView.estimatedRowHeight = 44
        //对tableView进行一些必要的设置,由于tableView底部有一个输入框，因此会遮挡cell，所以要将tableView的内容inset增加一些底部位移
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: toolBarMinHeight, right: 0)
        self.tableView.separatorStyle = .None

//        messages = [
//            [
//                Message(incoming: true, text: "你叫什么名字？", sentDate: NSDate(timeIntervalSinceNow: -12*60*60*24)),
//                Message(incoming: false, text: "我叫灵灵，聪明又可爱的灵灵", sentDate: NSDate(timeIntervalSinceNow:-12*60*60*24))
//            ],
//            [
//                Message(incoming: true, text: "你爱不爱我？", sentDate: NSDate(timeIntervalSinceNow: -6*60*60*24 - 200)),
//                Message(incoming: false, text: "爱你么么哒", sentDate: NSDate(timeIntervalSinceNow: -6*60*60*24 - 100))
//            ],
//            [
//                Message(incoming: true, text: "北京今天天气", sentDate: NSDate(timeIntervalSinceNow: -60*60*18)),
//                Message(incoming: false, text: "北京:08/30 周日,19-27° 21° 雷阵雨转小雨-中雨 微风小于3级;08/31 周一,18-26° 中雨 微风小于3级;09/01 周二,18-25° 阵雨 微风小于3级;09/02 周三,20-30° 多云 微风小于3级", sentDate: NSDate(timeIntervalSinceNow: -60*60*18))
//            ],
//            [
//                Message(incoming: true, text: "你在干嘛", sentDate: NSDate(timeIntervalSinceNow: -60)),
//                Message(incoming: false, text: "我会逗你开心啊", sentDate: NSDate(timeIntervalSinceNow: -65))
//            ],
//        ]
        initData()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
    }
    func keyboardWillShow(notif: NSNotification){
//        let rect = notif.userInfo![UIKeyboardFrameBeginUserInfoKey]!.CGRectValue
//        self.tableView.contentOffset.y = UIScreen.mainScreen().bounds.height - rect.height
    }
    func keyboardDidShow(notif: NSNotification){
        self.tableViewScrollToBottomAnimated(true)
    }
    
    func initData(){
        var index = 0
        var section = 0
        var currentDate:NSDate?
        messages = [[]]
        //
        let query:PFQuery = PFQuery(className:"Messages")
        query.orderByAscending("sentDate")
        if let user = PFUser.currentUser(){
            query.whereKey("createdBy", equalTo: user)
            messages = [[Message(incoming: true, text: "Hello~\(user.username)", sentDate: NSDate())]]
        }
        
        query.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil{
                for object in objects!{
                    let message = Message(incoming: object["incoming"] as! Bool, text: object["text"] as! String, sentDate: object["sentDate"] as! NSDate)
                    if let url = object["url"] as? String{
                        message.url = url
                    }

                    if index == 0{
                        currentDate = message.sentDate
                    }
                    let timeInterval = message.sentDate.timeIntervalSinceDate(currentDate!)
                    
                    if timeInterval < 120{
                        self.messages[section].append(message)
                    }
                    else{
                        section++
                        self.messages.append([message])
                    }
                    currentDate = message.sentDate
                    index++

                }
                self.tableView.reloadData()
            }
            else{
                print("Error:\(error?.userInfo)")
            }
        }
        
        
    }
    

    func formatDate(date:NSDate)->String{
        let calendar = NSCalendar.currentCalendar()
        let dateFmt = NSDateFormatter()
        dateFmt.locale = NSLocale(localeIdentifier: "zh_CN")
        
        let last18hours = (-18*60*60 < date.timeIntervalSinceNow)
        let isToday = calendar.isDateInToday(date)
        let isLast7Days = (calendar.compareDate(NSDate(timeIntervalSinceNow: -7*24*3600), toDate: date, toUnitGranularity:.Day) == NSComparisonResult.OrderedAscending)
        
        if last18hours || isToday{
            dateFmt.dateFormat = "a HH:mm"
        }
        else if isLast7Days{
            dateFmt.dateFormat = "MM月dd日 a HH:mm EEEE"
        }
        else{
            dateFmt.dateFormat = "YYYY年MM月dd日 a HH:mm"
        }
        
        return dateFmt.stringFromDate(date)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK: tableview delegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return messages.count
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages[section].count + 1
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (messages[0].count>0){
            if indexPath.row == 0{
                
                let cellIdentifier = NSStringFromClass(MessageSentDateTableViewCell)
                let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MessageSentDateTableViewCell
                
                let message:Message = messages[indexPath.section][0]
                cell.sentDateLabel.text = formatDate(message.sentDate)
                
                return cell
            }
            else{
                let cellIdentifier = NSStringFromClass(MessageBubbleTableViewCell)
                var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! MessageBubbleTableViewCell!
                if cell == nil{
                    cell = MessageBubbleTableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
                }
                
                let message = messages[indexPath.section][indexPath.row - 1]
                cell.configureWithMessage(message)
                
                return cell
            }
        }
        return UITableViewCell()
    }
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if let url = messages[indexPath.section][indexPath.row-1].url{
//            UIApplication.sharedApplication().openURL(NSURL(string: url)!)
            let webVC = SFSafariViewController(URL: NSURL(string: url)!, entersReaderIfAvailable: true)
            self.presentViewController(webVC, animated: true, completion: nil)
        }
        return nil
    }
    
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}

