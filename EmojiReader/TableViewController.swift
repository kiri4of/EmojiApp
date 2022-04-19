//
//  TableViewController.swift
//  EmojiReader
//
//  Created by Kiri4of on 03.02.2022.
//

import UIKit

class TableViewController: UITableViewController {
    
    var objects = [
        Emoji(emoji: "🥰", name: "Love" , description: "Let's love each other"),
        Emoji(emoji: "👻", name: "Ghost" , description: "Let's scare together"),
        Emoji(emoji: "🤡", name: "Clown" , description: "Let's joke together")
    ] 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "Emoju Reader"
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    @IBAction func unwindToViewController(_ unwindSegue: UIStoryboardSegue) {
        guard unwindSegue.identifier == "saveSegue" else {return} // с какого сигвея переходим
        
        guard let sourceViewController = unwindSegue.source as? NewEmojiTableViewController else {return}
        let emoji = sourceViewController.emoji
        if let selectedIndexPath = tableView.indexPathForSelectedRow { //индексПаф запишется тогда как нажмешь на строку, если же не, то он будет пустой
            objects[selectedIndexPath.row] = emoji
            tableView.reloadRows(at: [selectedIndexPath], with: .fade)
        } else {
        let newIndexPath = IndexPath(row: objects.count, section: 0)
        objects.append(emoji)
        tableView.insertRows(at: [newIndexPath], with: .fade) //добавляет строку по адресу(индексПафу) / увеличивает строки по инлексПафу
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "editEmojiSegue" else {return}
        let indexPath =  tableView.indexPathForSelectedRow! //текущий индексПаф
        let emoji = objects[indexPath.row]
        let navigationVC = segue.destination as! UINavigationController //Тк второй  экран находиться в Навигейшн Контролере
        let newEmojiVC = navigationVC.topViewController as! NewEmojiTableViewController
        newEmojiVC.emoji = emoji
        newEmojiVC.title = "Edit"
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return objects.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmojiTableViewCell", for: indexPath) as? EmojiTableViewCell else {return UITableViewCell() }
        let object = objects[indexPath.row]
        cell.configurate(object: object)
        return cell
    }
    //delete
    override func tableView(_ tableView: UITableView,editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {     //Разрешает удалять
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .middle)
        }
    }
    //Move
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
     
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedEmoji = objects.remove(at: sourceIndexPath.row) //сохраняет удаленный елемент
        objects.insert(movedEmoji, at: destinationIndexPath.row)//вставляем на то самое время
        tableView.reloadData()  //по сути мы снова делаем ячейку уже из измененного массива и обновляем ее
    }
    
    //swipe actions
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let done = doneAction(at: indexPath)
        let favorite = favoriteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [done,favorite])
    }
    
    func doneAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Done") { action, view, complition in
            self.objects.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            complition(true) // после этого не выполняется никакие действияб, все действия завершаться
        }
        action.backgroundColor = .systemGreen
        action.image = UIImage(systemName: "checkmark.circle")
        return action
    }
    
    func favoriteAction(at indexPath: IndexPath) -> UIContextualAction {
        var object = objects[indexPath.row]
        let action = UIContextualAction(style: .normal, title: "Fav", handler: { action, view, complition in
                object.isFavourite = !object.isFavourite
                self.objects[indexPath.row] = object //даби вернуть результат (а так ми работаем с копией)
                complition(true)
        })
        action.backgroundColor = object.isFavourite ? .systemPurple : .systemGray //if else (тернарный оператор)
        action.image = UIImage(systemName: "heart")
        return action
    }

}
