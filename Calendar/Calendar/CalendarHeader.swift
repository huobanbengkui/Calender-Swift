//
//  CalendarHeader.swift
//  Calendar
//
//  Created by huobanbengkui on 2018/3/2.
//  Copyright © 2018年 huobanbengkui. All rights reserved.
//

import UIKit

public let IPHONE_WIDTH:CGFloat = UIScreen.main.bounds.size.width;
public let IPHONE_HEIGHT:CGFloat = UIScreen.main.bounds.size.height;
public let IPHONE6SCALE:CGFloat = (IPHONE_WIDTH/375.0);

class CalendarHeader: NSObject {
    
    //使用HexColor 赋值
    class func HexColor(hexValue:UInt) -> UIColor{
        return UIColor.init(red: CGFloat((hexValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((hexValue & 0x00FF00) >> 8) / 255.0, blue: CGFloat(hexValue & 0x0000FF) / 255.0, alpha: 1.0);
    }
    
    class func RGBColor(r:Float, g:Float, b:Float, a:Float) -> UIColor{
        return UIColor.init(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue: CGFloat(b / 255.0), alpha: 1.0)
    }
    
}
