//
//  ViewController.swift
//  FareCodeDocPicker
//
//  Created by  Robin George  on 10/12/21.
//

import UIKit
import UniformTypeIdentifiers
import QuickLook


class ViewController: UIViewController{
    
    //table veiw
    @IBOutlet weak var tableView: UITableView!
    
    // Get the document directory url
    let directoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    //contains array of urls
    var directoryContents :[URL]! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    //MARK: upload button
    @IBAction func uploadButton(_ sender: Any) {
        
        //setting the types of extentions that wants to be read also creates a copy of file
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.png,UTType.jpeg, UTType.pdf,UTType.svg,UTType.epub,UTType.gif,UTType.text],asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        documentPicker.modalPresentationStyle = .fullScreen
        self.present(documentPicker, animated: true, completion: nil )
        
    }
    
    //MARK: alert pop up
    func alert(string :String) {
        let alert = UIAlertController(title:string , message: nil,         preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}


//MARK: Document picker delegate
extension ViewController:UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else {return}
        
        let fileUrl  = directoryUrl.appendingPathComponent(url.lastPathComponent)
        
        if fileUrl.hasDirectoryPath{
            
            
        }
        else  {
            do {
                try FileManager.default.copyItem(at: url, to: fileUrl)
                //TODO: Add an alert
                print("successful")
                
                alert(string: "succesful")
                tableView.reloadData()
            }
            catch {
                
                alert(string: "File Already Exists")
            }
            
        }
        
        
    }
}

//MARK: Preview controller delegate
extension ViewController: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return directoryContents.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        directoryContents[index].absoluteURL as NSURL
    }
}


//MARK: table view data source
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            // Get the directory contents urls (including subfolders urls)
            directoryContents = try FileManager.default.contentsOfDirectory(at: directoryUrl, includingPropertiesForKeys: nil)
            return directoryContents.count
            
        } catch {
            print(error)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DictTableViewCell
        
        cell.cellConfig(directoryContents: directoryContents[indexPath.row].lastPathComponent)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //deleting swipe
        let delete = UIContextualAction(style: .destructive, title: "delete"){ [weak self]
            (action,view,completionHandler) in
            try! FileManager.default.removeItem(at: self!.directoryContents[indexPath.row].absoluteURL)
                //refresh
                tableView.reloadData()
            }
            return  UISwipeActionsConfiguration (actions: [delete])
        }
    }
    


//MARK: table view data delegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1
        let quickLookViewController = QLPreviewController()
        // 2
        quickLookViewController.dataSource = self
        // 3
        quickLookViewController.currentPreviewItemIndex = indexPath.row
        // 4
        present(quickLookViewController, animated: true)
        
    }
    
}
