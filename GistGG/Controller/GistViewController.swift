//
//  GistViewController.swift
//  GistGG
//
//  Created by Isaac Cavalcante on 01/04/21.
//

import UIKit
import SDWebImage

class GistViewController: UIViewController, UINavigationControllerDelegate, SpinnerDelegate {
    
    @IBOutlet weak var ownerImageView: UIImageView!
    @IBOutlet weak var commitsLabel: UILabel!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var filesTableView: UITableView!
    @IBOutlet weak var filesButton: UIButton!
    
    var gistUrl: String?
    var spinnerView = SpinnerViewController()
    private var gistManager = GistManager()
    private var comments = [(String, String, String, Date)]()
    private var files = [(String, String, String)]()
    private var showFiles = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filesTableView.delegate = self
        filesTableView.dataSource = self
        gistManager.delegate = self
        spinnerView.delegate = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        filesTableView.register(UINib(nibName: K.Cell.Nib.commentCellNibName, bundle: nil), forCellReuseIdentifier: K.Cell.commentCell)
        
        filesTableView.register(UINib(nibName: K.Cell.Nib.fileCellNibName, bundle: nil), forCellReuseIdentifier: K.Cell.fileCell)
        
        roundButton(button: commentsButton)
        roundButton(button: filesButton)
        
        loadGist(url: gistUrl!)
        
        ownerImageView.layer.cornerRadius = ownerImageView.frame.size.width/2
        ownerImageView.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.")
        }
        navBar.tintColor = UIColor.white
    }
    
    @IBAction func commentsButtonTapped(_ sender: UIButton) {
        showFiles = false
        reloadTableViewWithEffect(objects: comments, effect: .right)
    }
    
    @IBAction func filesButtonTapped(_ sender: UIButton) {
        showFiles = true
        reloadTableViewWithEffect(objects: files, effect: .left)
    }
    
    private func reloadTableViewWithEffect<T>(objects: [T], effect: UITableView.RowAnimation) {
        filesTableView.reloadData()
        
        var indexPathToReload = [IndexPath]()
        for index in objects.indices {
            let indexPath = IndexPath(row: index, section: 0)
            indexPathToReload.append(indexPath)
        }
        
        filesTableView.reloadRows(at: indexPathToReload, with: effect)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == K.Segue.gistToviewCodeSegue){
            let destinationVC = segue.destination as! CodeViewController
            
            if let indexPath = filesTableView.indexPathForSelectedRow {
                destinationVC.file = files[indexPath.row]
            }
        }
    }
    
    private func roundButton(button: UIButton) {
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
    }
    
    private func setUpAttributedString (withIcon icon: String, text: String, andColor color: UIColor) -> NSAttributedString{
        let imageAttributedString = NSTextAttachment()
        imageAttributedString.image = UIImage(systemName: icon)?.withTintColor(color)
        
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: text))
        attributedString.append(NSAttributedString(attachment: imageAttributedString))
        
        return attributedString
    }
    
    private func loadGist(url: String) {
        spinnerView.spinnerOn()
        
        let id = String(url.split(separator: "/").last!)
        gistManager.fetchRequest(with: id)
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
             
            let filesButtonAttributedString = self.setUpAttributedString(withIcon: "arrow.right.doc.on.clipboard", text: "\(numberOfFiles) ", andColor: .white)
            self.filesButton.setAttributedTitle(filesButtonAttributedString, for: .normal)
            
            let commentsButtonAttributedString = self.setUpAttributedString(withIcon: "text.bubble.fill", text: "\(numberOfComments) ", andColor: .white)
            self.commentsButton.setAttributedTitle(commentsButtonAttributedString, for: .normal)
            
            let commitsLabelAttributedString = self.setUpAttributedString(withIcon: "pencil", text: "\(numberOfCommits) ", andColor: .white)
            self.commitsLabel?.attributedText = commitsLabelAttributedString
            
            if let ownerImageUrl = gistManager.getGistUrlImage(){
                self.ownerImageView?.sd_setImage(with: URL(string: ownerImageUrl))
            } else {
                self.ownerImageView?.isHidden = true
            }
            
            self.spinnerView.spinnerOff()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(showFiles){
            performSegue(withIdentifier: K.Segue.gistToviewCodeSegue, sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        if(showFiles){
            let fileCell = tableView.dequeueReusableCell(withIdentifier: K.Cell.fileCell, for: indexPath) as! FileTableViewCell
            fileCell.fileNameLabel.text = files[indexPath.row].0
            fileCell.languageNameLabel.text = files[indexPath.row].1
            
            cell = fileCell
        } else {
            let commentCell = tableView.dequeueReusableCell(withIdentifier: K.Cell.commentCell, for: indexPath) as! CommentTableViewCell
            commentCell.ownerNameLabel.text = comments[indexPath.row].0
            if let ownerImageUrl = URL(string: comments[indexPath.row].1){
                commentCell.ownerImage.sd_setImage(with: ownerImageUrl)
            }else{
                commentCell.ownerImage.isHidden = true
            }
            commentCell.commentLabel.text = comments[indexPath.row].2
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/YY"
            commentCell.dateLabel.text = dateFormatter.string(from: comments[indexPath.row].3)
            
            cell = commentCell
        }   
        return cell
    }
}
