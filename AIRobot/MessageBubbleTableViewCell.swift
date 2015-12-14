//
//  MessageBubbleTableViewCell.swift
//  
//
//  Created by CY on 15/12/13.
//
//

import UIKit
import SnapKit

let incomingTag = 0, outgoingTag = 1
let bubbleTag = 8

class MessageBubbleTableViewCell: UITableViewCell {
    let bubbleImageView:UIImageView
    let messageLabel:UILabel
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        bubbleImageView = UIImageView(image: bubbleImage.incoming, highlightedImage: bubbleImage.incomingHighlighed)
        bubbleImageView.tag = bubbleTag
        bubbleImageView.userInteractionEnabled = true
        
        messageLabel = UILabel(frame: CGRectZero)
        messageLabel.font = UIFont.systemFontOfSize(messageFontSize)
        messageLabel.numberOfLines = 0
        messageLabel.userInteractionEnabled = false
        
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        
        contentView.addSubview(bubbleImageView)
        bubbleImageView.addSubview(messageLabel)
        
        bubbleImageView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(contentView.snp_left).offset(10)
            make.top.equalTo(contentView.snp_top).offset(4.5)
            make.width.equalTo(messageLabel.snp_width).offset(30)
            make.bottom.equalTo(contentView.snp_bottom).offset(-4.5)
        }
        messageLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(bubbleImageView.snp_centerX).offset(3)
            make.centerY.equalTo(bubbleImageView.snp_centerY).offset(-0.5)
            messageLabel.preferredMaxLayoutWidth = 218
            make.height.equalTo(bubbleImageView.snp_height).offset(-15)
        }
    }
    
    func configureWithMessage(message:Message){
        //1 设置消息内容
        messageLabel.text = message.text
        
        //2 删除聊天气泡的左右约束，根据消息类型重新设置
        let constr:NSArray = contentView.constraints

        let indexOfContraint = constr.indexOfObjectPassingTest{ (var contraint,idx,stop) in
            return (contraint.firstItem as! UIView).tag == bubbleTag && (contraint.firstAttribute == NSLayoutAttribute.Left || contraint.firstAttribute == NSLayoutAttribute.Right)
        }
        contentView.removeConstraint(constr[indexOfContraint] as! NSLayoutConstraint)
        
        //3
        bubbleImageView.snp_makeConstraints { (make) -> Void in
            if message.incoming{
                tag = incomingTag
                bubbleImageView.image = bubbleImage.incoming
                bubbleImageView.highlightedImage = bubbleImage.incomingHighlighed
                messageLabel.textColor = UIColor.blackColor()
                //接受消息的聊天气泡距离cell左边缘10点
                make.left.equalTo(contentView.snp_left).offset(10)
                //对应地，消息内容的Label也相应右移3点
                messageLabel.snp_updateConstraints{ (make) -> Void in
                    make.centerX.equalTo(bubbleImageView.snp_centerX).offset(3)
                }
            }
            else{
                tag = outgoingTag
                bubbleImageView.image = bubbleImage.outgoing
                bubbleImageView.highlightedImage = bubbleImage.outgoingHighlighed
                messageLabel.textColor = UIColor.whiteColor()
                //根据消息类型进行对应的设置，包括使用的图片还有约束条件。由于发送消息的聊天气泡是靠右的，而接受消息的聊天气泡是靠左的，所以发送消息的聊天气泡距离cell右边缘10点
                make.right.equalTo(contentView.snp_right).offset(-10)
                //对应地，消息内容的Label也相应左移3点
                messageLabel.snp_updateConstraints{ (make) -> Void in
                    make.centerX.equalTo(bubbleImageView.snp_centerX).offset(-3)
                }
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


let bubbleImage = bubbleImageMake()

func bubbleImageMake() -> (incoming:UIImage, incomingHighlighed:UIImage, outgoing:UIImage, outgoingHighlighed:UIImage){
    let maskOutgoing = UIImage(named: "MessageBubble")!
    let maskIncoming = UIImage(CGImage: maskOutgoing.CGImage!, scale: 2, orientation:.UpMirrored)
    
    let capInsetsIncoming = UIEdgeInsets(top: 17, left: 26.5, bottom: 17.5, right: 21)
    let capInsetsOutgoing = UIEdgeInsets(top: 17, left: 21, bottom: 17.5, right: 26.5)
    
    let incoming = coloredImage(maskIncoming, red: 229/255, green: 229/255, blue: 234/255, alpha: 1).resizableImageWithCapInsets(capInsetsIncoming)
    let incomingHighlighed = coloredImage(maskIncoming, red: 206/255, green: 206/255, blue: 210/255, alpha: 1).resizableImageWithCapInsets(capInsetsIncoming)
    
    let outgoing = coloredImage(maskOutgoing, red: 0.05, green: 0.47, blue: 0.91, alpha: 1).resizableImageWithCapInsets(capInsetsOutgoing)
    let outgoingHighlighed = coloredImage(maskOutgoing, red: 32/255, green: 96/255, blue: 200/255, alpha: 1).resizableImageWithCapInsets(capInsetsOutgoing)
    
    return (incoming,incomingHighlighed,outgoing,outgoingHighlighed)
}

func coloredImage(image: UIImage, red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIImage! {
    let rect = CGRect(origin: CGPointZero, size: image.size)
    UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
    let context = UIGraphicsGetCurrentContext()
    image.drawInRect(rect)
    CGContextSetRGBFillColor(context, red, green, blue, alpha)
    CGContextSetBlendMode(context, .SourceAtop)
    CGContextFillRect(context, rect)
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result
}