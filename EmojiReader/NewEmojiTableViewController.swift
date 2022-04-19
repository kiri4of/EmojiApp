//
//  NewEmojiTableViewController.swift
//  EmojiReader
//
//  Created by Kiri4of on 07.02.2022.
//

import UIKit

class NewEmojiTableViewController: UITableViewController {
    var emoji = Emoji(emoji: "", name: "", description: "", isFavourite: false)
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var descriptionTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emojiTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.backgroundColor = .white
        updateUI()
        updateSaveButtonState()
    }
    private func updateSaveButtonState(){
        let emojiText = emojiTF.text ?? ""
        let nameText = nameTF.text ?? ""
        let descriptionText = descriptionTF.text ?? ""
        
        saveButton.isEnabled = !emojiText.isEmpty && !nameText.isEmpty && !descriptionText.isEmpty //проверка на пустоту во всей строках
    }
    
    private func updateUI() {
        emojiTF.text = emoji.emoji
        nameTF.text = emoji.name
        descriptionTF.text = emoji.description
    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //когда переходи на другой экран
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveSegue" else {return}
        
        let emoji = emojiTF.text ?? ""
        let name = nameTF.text ?? ""
        let description = descriptionTF.text ?? ""
        
        self.emoji = Emoji(emoji: emoji, name: name, description: description)
    }
}
