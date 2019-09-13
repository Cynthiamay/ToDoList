//
//  ViewController.swift
//  ToDo
//
//  Created by Treinamento on 9/4/19.
//  Copyright © 2019 cynthiamayumiwatanabeyamaoto. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    //criar um código para manter os dados e forma segura "dentro da caixa de areia"
    //let defaults = UserDefaults.standard
    
    //Definir o que será feito, o que estará na lista
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
        
    }
    //outra forma de manter os dados sem ser UserDefault
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
            
        }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory?.name
        
        guard let colourHex = selectedCategory?.colour else { fatalError()}
        
        updateNavBar(withHexCode: colourHex)
            
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        updateNavBar(withHexCode: "7A81FF")
    }
    
    //MARK: - Nav Bar Setup Methods
    
    func updateNavBar(withHexCode colourHexCode: String){
        
        guard let navBar = navigationController?.navigationBar else {fatalError(" Navigation controller does not exist.")}

        
        guard let navBarColour = UIColor(hexString: colourHexCode) else { fatalError()}
        
        navBar.barTintColor = navBarColour
        
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
        
        searchBar.barTintColor = navBarColour

    
    }
    
    
    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    //o próximo método é o index path com cellforrow
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        // quando coloca mais arrays, o codigo dá um bug na parte do checkmark, por isso, o melhor jeito de solucionar o problema, é criar um model. 
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        if let item = todoItems? [indexPath.row]{
            
            cell.textLabel?.text = item.title
            
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)){
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
            
            
            
            //arruma o checkmark
            
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    // A função responsável por fazer sumir quando se clica em qualquer célula na table view
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //update
        
        if let item = todoItems?[indexPath.row]{
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error savind done status, \(error)")
            }
        }
        tableView.reloadData()
        

        

//
        //arruma o checkmark, o codigo acima faz a mesma função
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//
//        }
//        else{
//            itemArray[indexPath.row].done = false
//        }
        
        //tableView.reloadData()
        
        //vai imprimir no console o número da row
        //print(indexPath.row)
        
        //o próximo imprime o texto
        //print(itemArray[indexPath.row])
        
        //colocar um chackmark, será no accessory que fica no mainstoryboard
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //sumir com o checkmark
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }
//        else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        
        // o código a seguir não vai grifar o texto de cinza quando a opção for selecionada, irá piscar a cor somente como uma animação
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    // MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // Para fazer com que o texto adicionado fique na lista, é preciso criar uma nova variável que esteja fora de uma closure
        var textField = UITextField()
        
        
        //mostrar uma janela como um pop up para adicionar novo item
        let alert = UIAlertController (title: "Adicionar Novo To Do", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction (title: "Adicionar item", style: .default) { (action) in
            
            //o que acontece quando o usuário clica no botão de mais no alerta
            //print("Success!")
            
            if let currentCategory = self.selectedCategory{
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
            }
        }
            
            self.tableView.reloadData()
    }
            // o codigo serve para colocar um campo de texto no alerta, inserir uma closure é só dar um enter
        alert.addTextField { (alertTextField) in
            //vai mostrar em cinza que irá sumir quando clicar no campo de texto
            alertTextField.placeholder = "Criar novo item"
            //inserir a variável
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        //mostra o alerta
        present (alert, animated: true, completion: nil)
        
        
    }
    //MARK: - Model Manipulation Methods
    
    
    
    //READ - Load up items from our system container, é preciso especificar o tipo do dado
    func loadItems(){
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath){
        if let item = todoItems?[indexPath.row]{
        
        do{
            try realm.write {
                realm.delete(item)
            }
            }catch{
                print("Error deleting item, \(error)")
                
            }
        }
        
    }
    
}
// MARK: - Search bar methods
extension TodoListViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //consultar no search bar 
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }


    
    //Depois que sai da pesquisa, a lista volta ao normal
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)  {
        if searchBar.text?.count == 0{
            loadItems()

            //não congela o usuário enquanto estiver procurando por dados da internet
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }


}

