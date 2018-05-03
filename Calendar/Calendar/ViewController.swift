//
//  ViewController.swift
//  Calendar
//
//  Created by huobanbengkui on 2018/3/2.
//  Copyright © 2018年 huobanbengkui. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(type: .custom);
        button.frame = CGRect.init(x: 10, y: 20, width: 100, height: 50);
        button.setTitle("显示日历", for: .normal);
        button.addTarget(self, action: #selector(clickButton), for: .touchUpInside);
        button.backgroundColor = UIColor.red;
        self.view.addSubview(button);
        

        self.view.backgroundColor = UIColor.yellow;
        // Do any additional setup after loading the view, typically from a nib.
    }
    @objc func clickButton(){
        let myCalendar = MyCalendarView(x:0,y:20);
        self.view.addSubview(myCalendar);
        myCalendar.resultDate = { (startStr, endStr) in
            print(startStr as Any, endStr as Any);
        };
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

