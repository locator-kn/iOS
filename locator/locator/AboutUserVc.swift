//
//  AboutUserVc.swift
//  locator
//
//  Created by Sergej Birklin on 09/01/16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import UIKit

class AboutUserVc: UIViewController {
    
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    
    let questions = Questions()
    
    var counter: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backButtonPressed(sender: UIButton) {
        counter -= 1
        changeViews()
    }
    
    @IBAction func firstButtonPressed(sender: UIButton) {
        counter += 1
        changeViews()
    }
    
    @IBAction func secondButtonPressed(sender: UIButton) {
        counter += 1
        changeViews()
    }
    
    func changeViews() {
        switch counter {
        case 0:
            print("First View")
            let question = Questions.First()
            setViews(question.color.first, secondColor: question.color.second, thirdColor: question.color.third, question: question.question, firstAnswer: question.firstAnswer, secondAnswer: question.secondAnswer)
        case 1:
            print("Second View")
            let question = Questions.Second()
            setViews(question.color.first, secondColor: question.color.second, thirdColor: question.color.third, question: question.question, firstAnswer: question.firstAnswer, secondAnswer: question.secondAnswer)
            
        case 2:
            print("Third View")
            let question = Questions.Third()
            setViews(question.color.first, secondColor: question.color.second, thirdColor: question.color.third, question: question.question, firstAnswer: question.firstAnswer, secondAnswer: question.secondAnswer)
        case 3:
            print("Fourth View")
            let question = Questions.Fourth()
            setViews(question.color.first, secondColor: question.color.second, thirdColor: question.color.third, question: question.question, firstAnswer: question.firstAnswer, secondAnswer: question.secondAnswer)
        case 4:
            print("Fifth View")
            let question = Questions.Fifth()
            setViews(question.color.first, secondColor: question.color.second, thirdColor: question.color.third, question: question.question, firstAnswer: question.firstAnswer, secondAnswer: question.secondAnswer)
        default:
            print("Error")
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func setViews(firstColor: UIColor, secondColor: UIColor, thirdColor: UIColor, question: String, firstAnswer: String, secondAnswer: String) {
        self.view.backgroundColor = firstColor
        questionLabel.text = question
        firstButton.setTitle(firstAnswer, forState: .Normal)
        firstButton.backgroundColor = secondColor
        secondButton.setTitle(secondAnswer, forState: .Normal)
        secondButton.backgroundColor = thirdColor
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
