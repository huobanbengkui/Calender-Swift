//
//  MyCalendarView.swift
//  Calendar
//
//  Created by huobanbengkui on 2018/3/2.
//  Copyright © 2018年 huobanbengkui. All rights reserved.
//

import UIKit

class MyCalendarView: UIView {
    private let height = 50*IPHONE6SCALE;
    private let dateHeight = 270*IPHONE6SCALE;
    private let viewHeight = 420*IPHONE6SCALE;
    private var firstView:UIView!;
    private var secondView:UIView!;
    private var headLabel: UILabel!;
    private var leftButton: UIButton!;
    private var rightButton: UIButton!;
    private var startDateStr: String?;
    private var endDateStr: String?;
    private var useDate = Date();
    var resultDate:((String?, String?) -> Void)?;
    
    init(x:CGFloat?, y:CGFloat?) {
        super.init(frame: CGRect.zero);
        var left:CGFloat = 0
        var top:CGFloat = 0
        if x != nil {
            left = x!;
        }
        if y != nil {
            top = y!;
        }
        self.frame = CGRect.init(x: left, y: top, width: IPHONE_WIDTH, height: viewHeight);
        createCalendarView(date: useDate);
    }
    //MARK:-- 创建视图
    private func createCalendarView(date: Date){
        let titleView: UIView = UIView();
        titleView.frame = CGRect.init(x: 0, y: 0, width: IPHONE_WIDTH, height: height);
        titleView.backgroundColor = CalendarHeader.RGBColor(r: 255, g: 255, b: 255, a: 1.0);
        self.addSubview(titleView);
        
        let titleLabel:UILabel = UILabel();
        titleLabel.frame = CGRect.init(x: 0, y: 0, width: IPHONE_WIDTH, height: height);
        titleLabel.text = "选择日期";
        titleLabel.textAlignment = .center;
        titleLabel.font = UIFont.systemFont(ofSize: 18.0);
        titleView.addSubview(titleLabel);
        
        let cancelButton:UIButton = createPrivateButton(title: "返回", font: 16.0, color: CalendarHeader.RGBColor(r: 83, g: 83, b: 83, a: 1.0), frame: CGRect.init(x: 20*IPHONE6SCALE, y: 0, width: 46*IPHONE6SCALE, height: height));
        cancelButton.addTarget(self, action: #selector(clickCancelButton), for: .touchUpInside);
        titleView.addSubview(cancelButton);
        
        let sureButton: UIButton = createPrivateButton(title: "确定", font: 16.0, color: CalendarHeader.RGBColor(r: 98, g: 159, b: 255, a: 1.0), frame: CGRect.init(x: IPHONE_WIDTH - 66*IPHONE6SCALE, y: 0, width: 46*IPHONE6SCALE, height: height));
        sureButton.addTarget(self, action: #selector(clickSureButton), for: .touchUpInside);
        titleView.addSubview(sureButton);
        
//        let selectView:UIView = UIView();
//        selectView.frame = CGRect.init(x: 0, y: titleView.frame.maxY, width: IPHONE_WIDTH, height: height);
//        selectView.backgroundColor = CalendarHeader.RGBColor(r: 55, g: 143, b: 247, a: 1.0);
//        self.addSubview(selectView);
//        let selectArray: Array = ["昨天", "近7日", "近30日"];
//        for i in 0..<selectArray.count {
//            let number: CGFloat = CGFloat.init(i);
//            let button:UIButton = createPrivateButton(title: selectArray[i], font: 14.0, color: nil, frame: CGRect.init(x: 105*IPHONE6SCALE + 55*number*IPHONE6SCALE, y: 0, width: 55*IPHONE6SCALE, height: height));
//            button.layer.cornerRadius = 2.0;
//            button.layer.masksToBounds = true;
//            selectView.addSubview(button);
//        }
        
        headLabel = UILabel();
        headLabel.frame = CGRect.init(x: 0, y: titleView.frame.maxY - 1, width: IPHONE_WIDTH, height: height);
        headLabel.font = UIFont.systemFont(ofSize: 14.0);
        headLabel.backgroundColor = CalendarHeader.RGBColor(r: 85, g: 161, b: 252, a: 1.0);
        headLabel.textAlignment = .center;
        headLabel.textColor = CalendarHeader.RGBColor(r: 255, g: 255, b: 255, a: 1.0);
        let dateM = getDayMonthAndYear(date: date);
        headLabel.text = "\(dateM.year)年\(dateM.month)月";
        self.addSubview(headLabel);
        
        leftButton = UIButton(type: UIButtonType.custom);
        leftButton.frame = CGRect.init(x: 0, y: headLabel.frame.minY, width: height, height: height);
        leftButton.setImage(UIImage.init(named: "triangleft"), for: .normal);
        leftButton.addTarget(self, action: #selector(clickLastMonth), for: UIControlEvents.touchUpInside);
        self.addSubview(leftButton);
        
        rightButton = UIButton(type: .custom);
        rightButton.frame = CGRect.init(x: IPHONE_WIDTH - height, y: headLabel.frame.minY, width: height, height: height);
        rightButton.setImage(UIImage.init(named: "triangleright"), for: .normal);
        rightButton.addTarget(self, action: #selector(clickNextMonth), for: UIControlEvents.touchUpInside);
        self.addSubview(rightButton);
        
        
        let weekArray = ["日", "一", "二", "三", "四", "五", "六"];
        let weekBgView:UIView = UIView();
        weekBgView.frame = CGRect.init(x: 0, y: headLabel.frame.maxY, width: IPHONE_WIDTH, height: height);
        weekBgView.backgroundColor = CalendarHeader.RGBColor(r: 255, g: 255, b: 255, a: 1.0);
        self.addSubview(weekBgView);
        for i in 0..<weekArray.count{
            let number = CGFloat.init(i);
            let label:UILabel = UILabel();
            label.frame = CGRect.init(x: 12.5*IPHONE6SCALE + 50*number*IPHONE6SCALE, y: 0, width: 50*IPHONE6SCALE, height: height);
            label.text = weekArray[i];
            label.font = UIFont.systemFont(ofSize: 12.0);
            label.textColor = CalendarHeader.RGBColor(r: 0, g: 0, b: 0, a: 1.0);
            label.backgroundColor = UIColor.clear;
            label.textAlignment = .center;
            weekBgView.addSubview(label);
        }
        
        firstView = createDayView();
        firstView.frame = CGRect.init(x: 0, y: weekBgView.frame.maxY, width: IPHONE_WIDTH, height: viewHeight - weekBgView.frame.maxY);
        firstView.backgroundColor = CalendarHeader.RGBColor(r: 255, g: 255, b: 255, a: 1.0);
        self.addSubview(firstView);
        setMessageOnButton(date: date, view: firstView);
        
        secondView = createDayView();
        secondView.isHidden = true;
        secondView.frame = CGRect.init(x: 0, y: weekBgView.frame.maxY, width: IPHONE_WIDTH, height: viewHeight - weekBgView.frame.maxY);
        secondView.backgroundColor = CalendarHeader.RGBColor(r: 255, g: 255, b: 255, a: 1.0);
        self.addSubview(secondView);
        //添加手势
        addGestureOnView(view: firstView);
        addGestureOnView(view: secondView);
    }
    
    private func createDayView() -> UIView!{
        let baseView = UIView();
        baseView.backgroundColor = CalendarHeader.RGBColor(r: 255, g: 255, b: 255, a: 1.0);
        for i in 0..<42 {
            let x = CGFloat.init(i%7)*50*IPHONE6SCALE + 12.5*IPHONE6SCALE;
            let y = CGFloat.init(i/7)*45*IPHONE6SCALE;
            let viewBase = UIView();
            viewBase.frame = CGRect.init(x: x, y: y, width: 50*IPHONE6SCALE, height: 45*IPHONE6SCALE);
            baseView.addSubview(viewBase);
            
            let button:UIButton = createPrivateButton(title: nil, font: 12.0, color: nil, frame: CGRect.init(x: 0, y: 5*IPHONE6SCALE, width: 50*IPHONE6SCALE, height: 35*IPHONE6SCALE));
            button.tag = 100 + i;
            button.addTarget(self, action: #selector(clickDayButton), for: UIControlEvents.touchUpInside);
            button.titleLabel?.textAlignment = .center;
            setRadius(button: button, isAll: true, radious: 2.0);
            viewBase.addSubview(button);
        }
        return baseView;
    }
    
    //MARK:-- 添加滑动事件
    private func addGestureOnView(view: UIView){
        let swipeNext = UISwipeGestureRecognizer(target: self, action: #selector(clickNextMonth));
        swipeNext.direction = .left;
        view.addGestureRecognizer(swipeNext);
        
        let swipeLast = UISwipeGestureRecognizer(target: self, action: #selector(clickLastMonth));
        swipeLast.direction = .right;
        view.addGestureRecognizer(swipeLast);
    }
    
    @objc private func clickNextMonth(){
        rightButton.isEnabled = false;
        useDate = nextMonth(date: useDate);
        let dateM = getDayMonthAndYear(date: useDate);
        headLabel.text = "\(dateM.year)年\(dateM.month)月";
        if firstView.frame.origin.x == 0{
            var frame = secondView.frame;
            frame.origin.x = IPHONE_WIDTH;
            secondView.frame = frame;
            secondView.isHidden = false;
            setMessageOnButton(date: useDate, view: secondView);
            UIView.animate(withDuration: 0.5, animations: {[weak self]()->Void in
                if let strongSelf = self{
                    var frame = strongSelf.firstView.frame;
                    frame.origin.x = -IPHONE_WIDTH;
                    strongSelf.firstView.frame = frame;
                    
                    var frameNext = strongSelf.secondView.frame;
                    frameNext.origin.x = 0;
                    strongSelf.secondView.frame = frameNext;
                }
            }) { [weak self](finished) in
                if let strongSelf = self{
                    strongSelf.firstView.isHidden = true;
                    strongSelf.rightButton.isEnabled = true;
                }
            }
        }else{
            var frame = firstView.frame;
            frame.origin.x = IPHONE_WIDTH;
            firstView.frame = frame;
            firstView.isHidden = false;
            setMessageOnButton(date: useDate, view: firstView);
            UIView.animate(withDuration: 0.5, animations: {[weak self]()->Void in
                if let strongSelf = self{
                    var frame = strongSelf.secondView.frame;
                    frame.origin.x = -IPHONE_WIDTH;
                    strongSelf.secondView.frame = frame;
                    
                    var frameNext = strongSelf.firstView.frame;
                    frameNext.origin.x = 0;
                    strongSelf.firstView.frame = frameNext;
                }
            }) { [weak self](finished) in
                if let strongSelf = self{
                    strongSelf.secondView.isHidden = true;
                    strongSelf.rightButton.isEnabled = true;
                }
            }
        }
    }
    @objc private func clickLastMonth(){
        leftButton.isEnabled = false;
        useDate = lastMonth(date: useDate);
        let dateM = getDayMonthAndYear(date: useDate);
        headLabel.text = "\(dateM.year)年\(dateM.month)月";
        if firstView.frame.origin.x == 0{
            var frame = secondView.frame;
            frame.origin.x = -IPHONE_WIDTH;
            secondView.frame = frame;
            secondView.isHidden = false;
            setMessageOnButton(date: useDate, view: secondView);
            UIView.animate(withDuration: 0.5, animations: {[weak self]()->Void in
                if let strongSelf = self{
                    var frame = strongSelf.firstView.frame;
                    frame.origin.x = IPHONE_WIDTH;
                    strongSelf.firstView.frame = frame;
                    
                    var frameNext = strongSelf.secondView.frame;
                    frameNext.origin.x = 0;
                    strongSelf.secondView.frame = frameNext;
                }
            }) { [weak self](finished) in
                if let strongSelf = self{
                    strongSelf.firstView.isHidden = true;
                    strongSelf.leftButton.isEnabled = true;
                }
            }
        }else{
            var frame = firstView.frame;
            frame.origin.x = -IPHONE_WIDTH;
            firstView.frame = frame;
            firstView.isHidden = false;
            setMessageOnButton(date: useDate, view: firstView);
            UIView.animate(withDuration: 0.5, animations: {[weak self]()->Void in
                if let strongSelf = self{
                    var frame = strongSelf.secondView.frame;
                    frame.origin.x = IPHONE_WIDTH;
                    strongSelf.secondView.frame = frame;
                    
                    var frameNext = strongSelf.firstView.frame;
                    frameNext.origin.x = 0;
                    strongSelf.firstView.frame = frameNext;
                }
            }) { [weak self](finished) in
                if let strongSelf = self{
                    strongSelf.secondView.isHidden = true;
                    strongSelf.leftButton.isEnabled = true;
                }
            }
        }
    }
    
    //MARK:-- 设置数据
    private func setMessageOnButton(date:Date, view:UIView){
        let daysInThisMonth = totalDaysInMonth(date: date);
        let firstWeekday = firstWeekDayIntThisMonth(date: date);
        let useDateMessage = getDayMonthAndYear(date: date);
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "MM dd, yyyy";
        let nowDate = getDayMonthAndYear(date: Date());
        let zoneNowDate = dateFormatter.date(from: "\(nowDate.month) \(nowDate.day), \(nowDate.year)")
        var day = 0;
        for i in 0..<42 {
            let button = view.viewWithTag(100 + i) as! UIButton;
            //复位
            button.setTitle(nil, for: .normal);
            button.setTitleColor(UIColor.clear, for: .normal);
            button.backgroundColor = UIColor.clear;
            //填写日期 不在本月的不显示
            if (i >= firstWeekday) && (i <= firstWeekday + daysInThisMonth - 1){
                day = i - firstWeekday + 1;
                button.setTitle("\(day)", for: .normal);
                
                //已经过去的日子可以点击
                let zoneDate = dateFormatter.date(from: "\(useDateMessage.month) \(day), \(useDateMessage.year)");
                if zoneDate! <= zoneNowDate!{
                    button.isEnabled = true;
                    button.setTitleColor(CalendarHeader.RGBColor(r: 0, g: 0, b: 0, a: 1.0), for: .normal);
                    if zoneDate! == zoneNowDate! {
                        button.backgroundColor = CalendarHeader.RGBColor(r: 232, g: 121, b: 124, a: 1.0)
                    }
                }else{
                    button.isEnabled = false;
                    button.setTitleColor(CalendarHeader.RGBColor(r: 125, g: 125, b: 125, a: 1.0), for: .normal);
                }
            }
        }
        setBackgroundColorOnButton(view: view);
    }
    
    //MARK:-- 获取年 月 日  元组
    private func getDayMonthAndYear(date: Date) -> (day: NSInteger, month: NSInteger, year: NSInteger){
        let components = NSCalendar.current.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day], from: date as Date)
        return (day: components.day!, month: components.month!, year: components.year!);
    }
    //MARK:-- 获取本月的相关天数，星期
    private func firstWeekDayIntThisMonth(date: Date) -> NSInteger{
        var calendar = Calendar.current;
        //1:Sun 2.Mon  3.Thes 4.Wed 5.Thur 6.Fri 7.Sat
        calendar.firstWeekday = 1;
        var compents:DateComponents = calendar.dateComponents([.year, .month, .day], from: date as Date);
        compents.day = 1;
        let firstDayOfMonthDate: Date = calendar.date(from: compents)!;
        let firstWeekDay: NSInteger = calendar.ordinality(of: Calendar.Component.weekday, in: Calendar.Component.weekOfMonth, for: firstDayOfMonthDate)!;
        return firstWeekDay - 1;
    }
    private func totalDaysInMonth(date: Date) -> NSInteger{
        let daysInMonth:Range = Calendar.current.range(of: Calendar.Component.day, in: .month, for: date)!;
        return daysInMonth.count;
    }
    //MARK:-- 上一个月，下一个月的月份
    private func lastMonth(date: Date) -> Date{
        var dateCompoents:DateComponents = DateComponents();
        dateCompoents.month = -1;
        let lastDate = Calendar.current.date(byAdding: dateCompoents, to: date);
        return lastDate!;
    }
    private func nextMonth(date: Date) -> Date{
        var dateCompoents: DateComponents = DateComponents();
        dateCompoents.month = 1;
        let nextDate = Calendar.current.date(byAdding: dateCompoents, to: date);
        return nextDate!;
    }
    
    //MARK:-- 渲染选中的日期
    @objc private func clickDayButton(button: UIButton){
        if button.title(for: .normal) == nil {
            return;
        }
        let selectDay: String = button.title(for: .normal)!;
        let dateM = getDayMonthAndYear(date: useDate);
        if  startDateStr != nil && endDateStr != nil {
            //如果两个值都有，则清空所有的选择
            startDateStr = nil;
            endDateStr = nil;
            setBackgroundColorOnButton(view: nil);
        }else{
            if startDateStr == nil{
                startDateStr = "\(dateM.month) \(selectDay), \(dateM.year)";
                button.backgroundColor = CalendarHeader.RGBColor(r: 205, g: 209, b: 225, a: 1.0);
            }else{
                endDateStr = "\(dateM.month) \(selectDay), \(dateM.year)";
            }
            if startDateStr != nil && endDateStr != nil{
                //如果两个参数都有，先判断大小，然后刷新UI
                let dateFormatter = DateFormatter();
                dateFormatter.dateFormat = "MM dd, yyyy";
                if dateFormatter.date(from: startDateStr!)! > dateFormatter.date(from: endDateStr!)!{
                    let midDateStr = startDateStr;
                    startDateStr = endDateStr;
                    endDateStr = midDateStr;
                }
                setBackgroundColorOnButton(view: nil);
            }
        }
    }
    private func setBackgroundColorOnButton(view: UIView?){
        var useView: UIView!;
        if view == nil {
            useView = firstView.frame.origin.x == 0 ? firstView:secondView;
        }else{
            useView = view!;
        }
        let useDateMessage = getDayMonthAndYear(date: useDate);
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "MM dd, yyyy";
        let nowDate = getDayMonthAndYear(date: Date());
        let zoneNowDate = dateFormatter.date(from: "\(nowDate.month) \(nowDate.day), \(nowDate.year)");
        var startDate: Date?;
        var endDate: Date?;
        var zoneDate: Date?;
        for i in 0..<42 {
            let button = useView.viewWithTag(100 + i) as! UIButton;
            if button.title(for: .normal) == nil {
                continue;
            }
            let selectDay: String = button.title(for: .normal)!;
            if startDateStr == nil || endDateStr == nil{
                setRadius(button: button, isAll: true, radious: 2.0);
                button.backgroundColor = CalendarHeader.RGBColor(r: 255, g: 255, b: 255, a: 1.0);
                zoneDate = dateFormatter.date(from: "\(useDateMessage.month) \(selectDay), \(useDateMessage.year)");
                if zoneDate! == zoneNowDate! {
                    button.backgroundColor = CalendarHeader.RGBColor(r: 232, g: 121, b: 124, a: 1.0)
                }
            }else{
                if startDate == nil || endDate == nil{
                    startDate = dateFormatter.date(from: startDateStr!);
                    endDate = dateFormatter.date(from: endDateStr!);
                }
                zoneDate = dateFormatter.date(from: "\(useDateMessage.month) \(selectDay), \(useDateMessage.year)");
                if zoneDate! > startDate! && zoneDate! < endDate!{
                    setRadius(button: button, isAll: true, radious: 0.0);
                    button.backgroundColor = CalendarHeader.RGBColor(r: 205, g: 209, b: 225, a: 1.0);
                }else if(zoneDate! == startDate!){
                    setRadius(button: button, isAll: nil, radious: 2.0);
                    button.backgroundColor = CalendarHeader.RGBColor(r: 205, g: 209, b: 225, a: 1.0);
                }else if(zoneDate! == endDate!){
                    setRadius(button: button, isAll: false, radious: 2.0);
                    button.backgroundColor = CalendarHeader.RGBColor(r: 205, g: 209, b: 225, a: 1.0);
                }
            }
        }
    }
    
    //MARK:--快捷方式创建Button
    private func createPrivateButton(title: String?, font: CGFloat, color: UIColor?, frame: CGRect) -> UIButton{
        let button:UIButton = UIButton(type: .custom);
        button.setTitle(title, for: .normal);
        button.titleLabel?.font = UIFont.systemFont(ofSize: font);
        button.setTitleColor(color, for: .normal);
        button.frame = frame;
        return button;
    }
    
    //MARK:-- 返回 、 确定
    @objc private func clickCancelButton(){
        if resultDate != nil{
            resultDate!(nil, nil);
        }
        self.removeFromSuperview();
    }
    @objc private func clickSureButton(){
        if startDateStr == nil {
            let alertView = UIAlertController(title: "请选择开始日期", message: nil, preferredStyle: .alert);
            let okAction = UIAlertAction(title: "好的", style: .default, handler: nil);
            alertView.addAction(okAction);
            (UIApplication.shared.keyWindow?.rootViewController)!.present(alertView, animated: true, completion: nil);
        }else if endDateStr == nil{
            let alertView = UIAlertController(title: "请选择结束日期", message: nil, preferredStyle: .alert);
            let okAction = UIAlertAction(title: "好的", style: .default, handler: nil);
            alertView.addAction(okAction);
            (UIApplication.shared.keyWindow?.rootViewController)!.present(alertView, animated: true, completion: nil);
        }else{
            if resultDate != nil{
                resultDate!(startDateStr, endDateStr);
            }
            self.removeFromSuperview();
        }
    }
    //MARK:-- 设置圆角
    private func setRadius(button: UIButton!, isAll: Bool?, radious:CGFloat){
        var corners: UIRectCorner!;
        if isAll == nil {
            corners = [.topLeft, .bottomLeft];
        }else if isAll!{
            corners = .allCorners;
        }else{
            corners = [.topRight, .bottomRight];
        }
        let maskPath = UIBezierPath(roundedRect: button.bounds, byRoundingCorners: corners, cornerRadii: CGSize.init(width: radious, height: radious));
        let maskLayer = CAShapeLayer();
        maskLayer.frame = button.bounds;
        maskLayer.path = maskPath.cgPath;
        button.layer.mask = maskLayer;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("页面被释放");
    }
    /*
    1，在 Swift 中, 类的初始化器有两种, 分别是Designated Initializer（指定初始化器）和Convenience Initializer（便利初始化器）
    2，如果子类没有定义任何的指定初始化器, 那么会默认继承所有来自父类的指定初始化器。
    3，如果子类提供了所有父类指定初始化器的实现, 那么自动继承父类的便利初始化器
    4，如果子类只实现部分父类初始化器，那么父类其他的指定初始化器和便利初始化器都不会继承。
    5，子类的指定初始化器必须要调用父类合适的指定初始化器。
     */
    
    /*2
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
