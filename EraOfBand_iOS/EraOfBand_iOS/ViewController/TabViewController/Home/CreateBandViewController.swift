//
//  CreateBandViewController.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/25.
//

import UIKit

class CreateBandViewController: UIViewController{
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var shortIntroTextField: UITextField!
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var introTextView: UITextView!
    @IBOutlet weak var chatLinkTextField: UITextField!
    @IBOutlet weak var vocalTextField: UITextField!
    @IBOutlet weak var guitarTextField: UITextField!
    @IBOutlet weak var bassTextField: UITextField!
    @IBOutlet weak var keyboardTextField: UITextField!
    @IBOutlet weak var drumTextField: UITextField!
    @IBOutlet weak var vocalNumView: UIView!
    
    func setLayout(){
        titleTextField.borderStyle = .none
        titleTextField.layer.cornerRadius = 15
        shortIntroTextField.borderStyle = .none
        shortIntroTextField.layer.cornerRadius = 15
        chatLinkTextField.borderStyle = .none
        chatLinkTextField.layer.cornerRadius = 15
        vocalTextField.borderStyle = .none
        vocalTextField.layer.cornerRadius = 15
        guitarTextField.borderStyle = .none
        guitarTextField.layer.cornerRadius = 15
        bassTextField.borderStyle = .none
        bassTextField.layer.cornerRadius = 15
        keyboardTextField.borderStyle = .none
        keyboardTextField.layer.cornerRadius = 15
        drumTextField.borderStyle = .none
        drumTextField.layer.cornerRadius = 15
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
    }
}
