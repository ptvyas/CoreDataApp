//
//  AddUpdateVC.swift
//  CoreDataApp
//
//  Created by MAC on 30/03/19.
//  Copyright © 2019 MAC. All rights reserved.
//

import UIKit
import CoreData

class AddUpdateVC: UIViewController {

    //MARK:- Outlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblData: UITableView!
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtContactNo: UITextField!
    @IBOutlet weak var lblMess: UILabel!
    
    @IBOutlet weak var btnAddUpdate: UIButton!
    
    //MARK:- Variable
    var strUpdateRecord : String = ""
    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblMess.text = ""
        
        if self.strUpdateRecord.count == 0 {
            self.lblTitle.text = "Add"
            
            self.txtName.text = ""
            self.txtContactNo.text = ""
            self.btnAddUpdate.setTitle("Add", for: .normal)
        } else {
            self.lblTitle.text = "Update"
            
            self.getRecord(strName: self.strUpdateRecord)
            self.btnAddUpdate.setTitle("Update", for: .normal)
        }
    }
    
    //MARK:-
    func addRecord(strName : String, strContactNo: String) -> Void {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "USERINFO", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        
        newUser.setValue(self.txtName.text ?? "", forKey: "name")
        newUser.setValue(self.txtContactNo.text ?? "", forKey: "contactnumber")
        
        do {
            try context.save()
            
            self.txtName.text = ""
            self.txtContactNo.text = ""
            self.lblMess.text = "Add Record Sucess"
        } catch {
            print("Failed saving")
            self.lblMess.text = "Error : Failed saving"
        }
    }
    
    func updateRecord(strName : String, strContactNo: String) -> Void {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "USERINFO")
        request.predicate = NSPredicate(format: "name = %@",self.strUpdateRecord)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if result.count != 0 {
            let updateObj = result.first as! NSManagedObject
            updateObj.setValue(strName, forKey: "name")
            updateObj.setValue(strContactNo, forKey: "contactnumber")
            
            do {
                try context.save()
                self.btnBackAction(UIButton.init())
            } catch  {
                print("Failed")
            }
            } else {
                self.lblMess.text = "Error...."
            }
        } catch {
            print("Failed")
        }
    }
    
    func getRecord(strName : String) -> Void {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
         let context = appDelegate.persistentContainer.viewContext
         
         let request = NSFetchRequest<NSFetchRequestResult>(entityName: "USERINFO")
         request.predicate = NSPredicate(format: "name = %@",strName)
         request.returnsObjectsAsFaults = false
         do {
         let result = try context.fetch(request)
         for data in result as! [NSManagedObject] {
         let name =  data.value(forKey: "name") as? String ?? ""
         let contactNo =  data.value(forKey: "contactnumber") as? String ?? ""
         
         self.txtName.text = name
         self.txtContactNo.text = contactNo
         }
         } catch {
         print("Failed")
         }
    }
    
    //MARK:- Button Action
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddAction(_ sender: UIButton) {
        self.lblMess.text = ""
        
        let name : String = self.txtName.text ?? ""
        let no : String = self.txtContactNo.text ?? ""
        
        if name.count == 0 {
            self.lblMess.text = "Add name"
            return
        }
        
        if no.count == 0 {
            self.lblMess.text = "Add contact number"
            return
        }
        
        
        if self.strUpdateRecord.count == 0 {
            self.addRecord(strName: name, strContactNo: no)
        } else {
            self.updateRecord(strName: name, strContactNo: no)
        }
    }
}
