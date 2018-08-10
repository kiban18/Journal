//
//  ViewController.swift
//  Journal
//
//  Created by JinSeo Yoon on 2018. 7. 21..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import UIKit

extension DateFormatter {
    static var entryDateFormatter: DateFormatter = {
        let df = DateFormatter.init()
        df.dateFormat = "yyyy. M. dd. EEE"
        return df
    }()
}

class EntryViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var button: UIBarButtonItem!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
    var environment: Environment!
    var entry: Entry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = entry?.text
        let date = entry?.createdAt ?? Date()
        title = DateFormatter.entryDateFormatter.string(from: date)
        button.image = entry == nil
            ? #imageLiteral(resourceName: "baseline_save_white_24pt")
            : #imageLiteral(resourceName: "baseline_edit_white_24pt")
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardAppearance(note:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardAppearance(note:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateSubviews(for: entry == nil)
    }
    
    @objc private func handleKeyboardAppearance(note: Notification) {
        guard
            let userInfo = note.userInfo,
            let keyboardFrameValue = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let animationCurve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt
            else { return }
        
        let keyboardHeight: CGFloat = note.name == Notification.Name.UIKeyboardWillShow
            ? keyboardFrameValue.cgRectValue.height
            : 0
        let animationOption = UIViewAnimationOptions(rawValue: animationCurve)
        
        UIView.animate(
            withDuration: duration,
            delay: 0.0,
            options: animationOption,
            animations: {
                self.textViewBottomConstraint.constant = -keyboardHeight
                self.view.layoutIfNeeded()
            },
            completion: nil
        )
    }
    
    @objc private func saveEntry(_ sender: Any) {
        if let oldEntry = self.entry {
            oldEntry.text = textView.text
            environment.entryRepository.update(oldEntry)
        } else {
            let newEntry: Entry = Entry(text: textView.text)
            environment.entryRepository.add(newEntry)
            entry = newEntry
        }
        
        updateSubviews(for: false)
    }
    
    @objc private func editEntry() {
        updateSubviews(for: true)
    }
    
    private func updateSubviews(for isEditing: Bool) {
        button.image = isEditing ? #imageLiteral(resourceName: "baseline_save_white_24pt") : #imageLiteral(resourceName: "baseline_edit_white_24pt")
        button.target = self
        button.action = isEditing ? #selector(saveEntry(_:)) : #selector(editEntry)
        
        textView.isEditable = isEditing
        _ = isEditing ? textView.becomeFirstResponder() : textView.resignFirstResponder()
    }
}
