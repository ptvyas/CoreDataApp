//
//  ViewController.swift
//  CoreDataApp
//
//  Created by MAC on 30/03/19.
//  Copyright © 2019 MAC. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    //MARK:- Outlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblData: UITableView!
    
    //MARK:- Variable
    var arrData : NSMutableArray = NSMutableArray.init()
    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
                
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getData()
    }
   
    //MARK:-
    func getData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "USERINFO")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            self.arrData.removeAllObjects()
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let name =  data.value(forKey: "name") as? String ?? ""
                let contactNo =  data.value(forKey: "contactnumber") as? String ?? ""
                
                let dic = ["name":name,
                           "contactno":contactNo]
                self.arrData.add(dic)
            }
            self.tblData.reloadData()
            
        } catch {
            print("Failed")
        }
    }
    
    //MARK:- Button Action
    @IBAction func btnMoreOptionAction(_ sender: UIButton) {
    }
    
    @IBAction func btnAddAction(_ sender: UIButton) {
        let objVC = self.storyboard?.instantiateViewController(withIdentifier: "AddUpdateVC") as! AddUpdateVC
        self.navigationController?.pushViewController(objVC, animated: true)
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrData.count
        //return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblData.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let dic = self.arrData.object(at: indexPath.row) as! [String : Any]
        cell.textLabel?.text = dic["name"] as? String ?? "--- --- ---"
        cell.detailTextLabel?.text = dic["contactno"] as? String ?? "0000-00000"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dic = self.arrData.object(at: indexPath.row) as! [String : Any]
        let name = dic["name"] as? String ?? ""
        
        
        let objVC = self.storyboard?.instantiateViewController(withIdentifier: "AddUpdateVC") as! AddUpdateVC
        objVC.strUpdateRecord = name
        self.navigationController?.pushViewController(objVC, animated: true)
    }
    
}

