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
        let subviews = self.view.subviews
        for view in subviews {
            if view as? UIButton != self.clearButton && view as? UIButton != self.persistButton {
                view.removeFromSuperview()
            } else {
                println("button pressed")
            }
        }
    }

    @IBAction func persistButtonPressed() {
        //
        if self.persist == false {
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
        //
        useTouchData(self.touchData)
        self.touchData.removeAll(keepCapacity: false)
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
    
    func makeCircle(location: CGPoint, radius: CGFloat) -> UIView {
        //
        var circleView = UIView(frame: CGRectMake(location.x, location.y, radius * 2, radius * 2))
        circleView.alpha = 0.75
        circleView.backgroundColor = UIColor.whiteColor()
        circleView.layer.cornerRadius = radius
        return circleView
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
        println("Circle Creation Intervals: \(sortedTouchArray)")
        for value in sortedTouchArray {
            let location = NSValue.CGPointValue(touchData[value]!)
            let delay = value * -1
            println("delay for addCircle function set to \(delay)")
            addCircleAtLocationAfterDelayWithOptionalTimedDestruction(location(), radius: 5, delay: delay, persist: self.persist)
        }
        println("\n")
    }
    
    func addCircleAtLocationAfterDelayWithOptionalTimedDestruction(location: CGPoint, radius: CGFloat, delay: NSTimeInterval, persist: Bool) {
        //
        println("addCircleAtLocationAfterDelayWithOptionalTimedDestruction called")
        let circle = makeCircle(location, radius: radius)
        let timer = NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: "addCircle:", userInfo: ["circle" : circle, "persist" : persist], repeats: false)
    }
    
    func addCircle(timer: NSTimer) {
        //
        println("addCircle called")
        let circle = timer.userInfo?["circle"] as UIView
        let persist = timer.userInfo?["persist"] as Bool
        
        if persist != true {
            let timer = NSTimer.scheduledTimerWithTimeInterval(self.destroyTime, target: circle, selector: "removeFromSuperview", userInfo: nil, repeats: false)
        }
        self.view.addSubview(circle)
        
    }
}

