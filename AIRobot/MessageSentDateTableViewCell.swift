//
//  MessageSentDateTableViewCell.swift
//  AIRobot
//
//  Created by CY on 15/12/13.
//  Copyright © 2015年 LINYC. All rights reserved.
//

import UIKit
import SnapKit

class MessageSentDateTableViewCell: UITableViewCell {

    let sentDateLabel:UILabel
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        sentDateLabel = UILabel(frame: CGRectZero)
        sentDateLabel.backgroundColor = UIColor.clearColor()
        sentDateLabel.font = UIFont.systemFontOfSize(10)
        sentDateLabel.textAlignment = .Center
        sentDateLabel.textColor = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1)
        
        super.init(style:style, reuseIdentifier:reuseIdentifier)
        selectionStyle = .None
        contentView.addSubview(sentDateLabel)
        
        sentDateLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(contentView.snp_centerX)
            make.top.equalTo(contentView.snp_top).offset(13)
            make.bottom.equalTo(contentView.snp_bottom).offset(-4.5)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
