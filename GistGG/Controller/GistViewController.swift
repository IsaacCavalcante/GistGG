//
//  GistViewController.swift
//  GistGG
//
//  Created by Isaac Cavalcante on 01/04/21.
//

import UIKit
import SDWebImage

class GistViewController: UIViewController {
    
    @IBOutlet weak var ownerImageView: UIImageView!
    @IBOutlet weak var commitsLabel: UILabel!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var filesTableView: UITableView!
    @IBOutlet weak var filesButton: UIButton!
    
    var gistUrl: String?
    private var gistManager = GistManager()
    private var comments = [(String, String, Date)]()
    private var files = [(String, String)]()
    private let child = SpinnerViewController()
    private var showFiles = false

    override func viewDidLoad() {
        super.viewDidLoad()
        filesTableView.delegate = self
        filesTableView.dataSource = self
        gistManager.delegate = self
        
        loadGist(url: gistUrl!)
        
        ownerImageView.layer.cornerRadius = ownerImageView.frame.size.width/2
        ownerImageView.clipsToBounds = true

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // add the spinner view controller
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.")
        }
        navBar.tintColor = UIColor.white
    }
    
    private func loadGist(url: String) {
        let id = String(url.split(separator: "/").last!)
        gistManager.fetchRequest(with: id)
        filesTableView.reloadData()
    }
    @IBAction func commentsButtonTapped(_ sender: UIButton) {
        showFiles = false
        comments = gistManager.getComments()
        filesTableView.reloadData()
    }
    @IBAction func filesButtonTapped(_ sender: UIButton) {
        showFiles = true
        files = gistManager.getFilesDictionary()
        filesTableView.reloadData()
    }
}

//MARK: - GistManagerDelegate
extension GistViewController: GistManagerDelegate {
    
    func updateGistInformation(_ gistManager: GistManager) {
        self.gistManager = gistManager
        
        let numberOfFiles = gistManager.getNumberOfFiles()
        let numberOfComments = gistManager.getNumberOfComments()
        let numberOfCommits = gistManager.getNumberOfCommits()
        
        comments = gistManager.getComments()
        files = gistManager.getFilesDictionary()
        
        DispatchQueue.main.async {

            if let ownerName = gistManager.getGistOwnerName(){
                self.navigationItem.title = ownerName
            }
            
            let textBubleImage = NSTextAttachment()
            textBubleImage.image = UIImage(systemName: "arrow.right.doc.on.clipboard")?.withTintColor(.white)
            
            let filesString = NSMutableAttributedString()
            filesString.append(NSAttributedString(string: "\(numberOfFiles) "))
            filesString.append(NSAttributedString(attachment: textBubleImage))
            self.filesButton.setAttributedTitle(filesString, for: .normal)
            
            self.filesButton.layer.borderWidth = 1
            self.filesButton.layer.borderColor = UIColor.white.cgColor
            self.filesButton.layer.cornerRadius = 15
            self.filesButton.layer.masksToBounds = true
         
            
            let commentImage = NSTextAttachment()
            commentImage.image = UIImage(systemName: "text.bubble.fill")?.withTintColor(.white)
            
            let comentsString = NSMutableAttributedString()
            comentsString.append(NSAttributedString(string: "\(numberOfComments) "))
            comentsString.append(NSAttributedString(attachment: commentImage))
            self.commentsButton.setAttributedTitle(comentsString, for: .normal)
            self.commentsButton.layer.borderWidth = 1
            self.commentsButton.layer.borderColor = UIColor.white.cgColor
            self.commentsButton.layer.cornerRadius = 15
            self.commentsButton.layer.masksToBounds = true
                
            
            let commitImage = NSTextAttachment()
            commitImage.image = UIImage(systemName: "pencil.circle")?.withTintColor(.white)

            let commitsString = NSMutableAttributedString()
            commitsString.append(NSAttributedString(string: "\(numberOfCommits) "))
            commitsString.append(NSAttributedString(attachment: commitImage))
            
            self.commitsLabel?.attributedText = commitsString
            
            
            if let ownerImageUrl = gistManager.getGistUrlImage(){
                self.ownerImageView?.sd_setImage(with: URL(string: ownerImageUrl))
            }
            
            self.child.willMove(toParent: nil)
            self.child.view.removeFromSuperview()
            self.child.removeFromParent()
            
            self.filesTableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension GistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = showFiles ? files.count : comments.count
        return numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Cell.fileCell, for: indexPath)
        let text = showFiles ?  files[indexPath.row].0 : comments[indexPath.row].1
        cell.textLabel?.text = text
        cell.textLabel?.textColor = UIColor.white

        return cell
    }


}
