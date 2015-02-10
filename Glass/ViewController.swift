//
//  ViewController.swift
//  Glass
//
//  Created by Nick McCardel on 1/16/15.
//  Copyright (c) 2015 Nicholas McCardel. All rights reserved.
//

typealias TouchData = [NSTimeInterval: NSValue]

import UIKit

class ViewController: UIViewController {

    var destroyTime: NSTimeInterval = 1.5
    var touchData: TouchData = [:]
    var touchDate: NSDate!
    var persist = false
    
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var persistButton: UIButton!
    
    override func viewDidLoad() {
        //
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        //
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clearButtonPressed() {
        //
        for view in self.view.subviews {
            if view is UIButton {
                println("button pressed")
            } else {
                view.removeFromSuperview()
            }
        }
    }

    @IBAction func persistButtonPressed() {
        //
        if self.persist != true {
            self.persist = true
            self.persistButton.titleLabel?.textColor = UIColor.redColor()
            self.persistButton.backgroundColor = UIColor.grayColor()
        } else {
            self.persist = false
            self.persistButton.titleLabel?.textColor = UIColor.whiteColor()
            self.persistButton.backgroundColor = UIColor.blackColor()
        }
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        //
        for touch in touches {
            let touch = touch as UITouch
            self.touchDate = NSDate()
            addTouchData(touch)
            println("touch")
            addCircleAtTouchWithTimedDestruction(touch, radius: 5, time: self.destroyTime)
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        //
        for touch in touches {
            let touch = touch as UITouch
            addTouchData(touch)
            addCircleAtTouchWithTimedDestruction(touch, radius: 5, time: self.destroyTime)
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        // needs to be hooked up to backend pass
        for touch in touches {
            let touch = touch as UITouch
            println("touch timestamp = \(touch.timestamp)")
        }
        let timer = NSTimer.scheduledTimerWithTimeInterval(3
            , target: self, selector: "useTouchDataFromTimer:", userInfo: self.touchData, repeats: true)
        self.touchData.removeAll(keepCapacity: false)
    }
    
    func addTouchData(touch: UITouch) {
        //
        let location = touch.locationInView(self.view)
        let value = NSValue(CGPoint: location)
        let interval = self.touchDate.timeIntervalSinceNow
        self.touchData.updateValue(value, forKey: interval)
    }
    
    func useTouchData(touchData: TouchData) {
        let sortedTouchArray = Array(touchData.keys).sorted(>)
        for value in sortedTouchArray {
            let location = NSValue.CGPointValue(touchData[value]!)
            let delay = value * -1
            addCircleAtLocationAfterDelayWithOptionalTimedDestruction(location(), radius: 5, delay: delay, persist: self.persist)
        }
    }
    
    func useTouchDataFromTimer(timer: NSTimer) {
        let touchData = timer.userInfo as TouchData
        let sortedTouchArray = Array(touchData.keys).sorted(>)
        for value in sortedTouchArray {
            let location = NSValue.CGPointValue(touchData[value]!)
            let delay = value * -1
            addCircleAtLocationAfterDelayWithOptionalTimedDestruction(location(), radius: 5, delay: delay, persist: self.persist)
        }
    }
    
    func makeCircle(location: CGPoint, radius: CGFloat) -> UIView {
        //
        var circleView = UIView(frame: CGRectMake(location.x, location.y, radius * 2, radius * 2))
        circleView.alpha = 0.75
        circleView.backgroundColor = UIColor.whiteColor()
        circleView.layer.cornerRadius = radius
        return circleView
    }
    
    func addCircleAtTouchWithTimedDestruction(touch: UITouch, radius: CGFloat, time: NSTimeInterval) {
        //
        let location = touch.locationInView(self.view)
        let circle = makeCircle(location, radius: radius)
        if persist == false {
            let timer = NSTimer.scheduledTimerWithTimeInterval(time, target: circle, selector: "removeFromSuperview", userInfo: nil, repeats: false)
        }
        self.view.addSubview(circle)
    }
    
    func addCircleAtLocationAfterDelayWithOptionalTimedDestruction(location: CGPoint, radius: CGFloat, delay: NSTimeInterval, persist: Bool) {
        //
        let circle = makeCircle(location, radius: radius)
        let timer = NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: "addCircle:", userInfo: ["circle" : circle, "persist" : persist], repeats: false)
    }
    
    func addCircle(timer: NSTimer) {
        //
        let circle = timer.userInfo?["circle"] as UIView
        let persist = timer.userInfo?["persist"] as Bool
        
        if persist != true {
            let timer = NSTimer.scheduledTimerWithTimeInterval(self.destroyTime, target: circle, selector: "removeFromSuperview", userInfo: nil, repeats: false)
        }
        self.view.addSubview(circle)
        
    }
}

