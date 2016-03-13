//
//  AboutUserVc.swift
//  locator
//
//  Created by Sergej Birklin on 09/01/16.
//  Copyright © 2016 Locator. All rights reserved.
//

import UIKit

class AboutUserVc: UIViewController {
    
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var thirdLabel: UILabel!
    
    let questions = Questions()
    
    var counter: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let firstTapGesture = UITapGestureRecognizer(target: self, action: Selector("firstAnswerPressed:"))
        let secondTapGesture = UITapGestureRecognizer(target: self, action: Selector("secondAnswerPressed:"))
        secondLabel.userInteractionEnabled = true
        secondLabel.addGestureRecognizer(firstTapGesture)
        thirdLabel.userInteractionEnabled = true
        thirdLabel.addGestureRecognizer(secondTapGesture)
        changeViews()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func crossButtonPressed(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func backButtonPressed(sender: UIButton) {
        counter -= 1
        changeViews()
    }
    
    func firstAnswerPressed(sender:UITapGestureRecognizer){
        counter += 1
        changeViews()
    }
    
    func secondAnswerPressed(sender:UITapGestureRecognizer){
        counter += 1
        changeViews()
    }
    
    func changeViews() {
        switch counter {
        case 0:
            let question = Questions.First()
            setViews(question.color.first, secondColor: question.color.second, thirdColor: question.color.third, question: question.question, firstAnswer: question.firstAnswer, secondAnswer: question.secondAnswer)
        case 1:
            let question = Questions.Second()
            setViews(question.color.first, secondColor: question.color.second, thirdColor: question.color.third, question: question.question, firstAnswer: question.firstAnswer, secondAnswer: question.secondAnswer)
            
        case 2:
            let question = Questions.Third()
            setViews(question.color.first, secondColor: question.color.second, thirdColor: question.color.third, question: question.question, firstAnswer: question.firstAnswer, secondAnswer: question.secondAnswer)
        case 3:
            let question = Questions.Fourth()
            setViews(question.color.first, secondColor: question.color.second, thirdColor: question.color.third, question: question.question, firstAnswer: question.firstAnswer, secondAnswer: question.secondAnswer)
        case 4:
            let question = Questions.Fifth()
            setViews(question.color.first, secondColor: question.color.second, thirdColor: question.color.third, question: question.question, firstAnswer: question.firstAnswer, secondAnswer: question.secondAnswer)
        case 5:
            performSegueWithIdentifier("showPreLogin", sender: self)
        default:
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func setViews(firstColor: UIColor, secondColor: UIColor, thirdColor: UIColor, question: String, firstAnswer: String, secondAnswer: String) {
        firstView.backgroundColor = firstColor
        firstLabel.text = question
        secondView.backgroundColor = secondColor
        secondLabel.text = firstAnswer
        thirdView.backgroundColor = thirdColor
        thirdLabel.text = secondAnswer
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
