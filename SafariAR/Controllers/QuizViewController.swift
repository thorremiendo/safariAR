//
//  QuizViewController.swift
//  SafariAR
//
//  Created by Thor Remiendo on 05/09/2019.
//  Copyright © 2019 ZET. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    let allQuestions = QuestionList()
    var pickedAnswer : Bool = false
    var questionNumber : Int = 0
    var score : Int = 0
    
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var progressBar: UIView!
    @IBOutlet weak var progressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstQuestion = allQuestions.list[0]
        questionLabel.text = firstQuestion.questionText
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func answerPressed(_ sender: UIButton) {
        if sender.tag == 1 {
            pickedAnswer = true
        }
        else if sender.tag == 2 {
            pickedAnswer = false
        }
        
        checkAnswer()
        
        questionNumber = questionNumber + 1
        
        nextQuestion()
    }
    
    
    func updateUI() {
        scoreLabel.text = "Score: \(score)"
        progressLabel.text = "\(questionNumber + 1) / 20"
        progressBar.frame.size.width = (view.frame.size.width / 20) * CGFloat(questionNumber + 1)
        
    }
    
    
    func nextQuestion() {
        if questionNumber <= 19 {
            questionLabel.text = allQuestions.list[questionNumber].questionText
            
            updateUI()
            
        } else {
            let alert = UIAlertController(title: "Quiz Finished", message: "Start Over?", preferredStyle: .alert)
            let restartAction = UIAlertAction(title: "Restart", style: .default, handler: {
                (UIAlertAction) in
                self.startOver()
            })
            
            alert.addAction(restartAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    func checkAnswer() {
        let correctAnswer = allQuestions.list[questionNumber].answer
        if correctAnswer == pickedAnswer{
            ProgressHUD.showSuccess("Correct!")
            score = score + 1
        } else {
            ProgressHUD.showError("Wrong!")
            
        }
        
    }
    
    
    func startOver() {
        score = 0
        questionNumber = 0
        nextQuestion()
    }
}
