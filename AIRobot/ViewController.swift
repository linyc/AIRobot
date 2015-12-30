//
//  ViewController.swift
//  AIRobot
//
//  Created by yuecang on 15/12/7.
//  Copyright © 2015年 LINYC. All rights reserved.
//

import UIKit
import Parse

let messageFontSize:CGFloat = 17
let toolBarMinHeight:CGFloat = 44


class ViewController: UITableViewController ,UITextViewDelegate{

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
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
    }
    
    func initData(){
        var index = 0
        var section = 0
        var currentDate:NSDate?
        messages = [[]]
        //
        let query:PFQuery = PFQuery(className:"Messages")
        query.orderByAscending("sentDate")
        
        query.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil{
                for object in objects!{
                    let message = Message(incoming: object["incoming"] as! Bool, text: object["text"] as! String, sentDate: object["sentDate"] as! NSDate)

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
        
//        do{
//            let objs = try! query.findObjects()
//            for object in objs {
//                let message = Message(incoming: object["incoming"] as! Bool, text: object["text"] as! String, sentDate: object["sentDate"] as! NSDate)
//                
//                if index == 0{
//                    currentDate = message.sentDate
//                }
//                let timeInterval = message.sentDate.timeIntervalSinceDate(currentDate!)
//                
//                if timeInterval < 120{
//                    messages[section].append(message)
//                }
//                else{
//                    section++
//                    messages.append([message])
//                }
//                currentDate = message.sentDate
//                index++
//            }
//        }
//        catch is ErrorType {
//            
//        }
        
        
    }
    
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
                
                let message:Message = try messages[indexPath.section][0]
                
                //            cell.sentDateLabel.text = "\(message.sentDate)"
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


}

