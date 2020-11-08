//
//  FavoriteListViewController.swift
//  Exam
//
//  Created by Wade Wang on 2020/11/8.
//

import UIKit
import SafariServices

class FavoriteListViewController: UIViewController {

    @IBOutlet weak var favoriteTableView: UITableView!
    var viewModel = FavoriteViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        favoriteTableView.register(UINib(nibName: "TopListTableViewCell", bundle: nil), forCellReuseIdentifier: "FavoriteCellId")
        biding()
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func biding() {
        viewModel.start()
        viewModel.favorites.addObserver { [weak self] (_) in
            self?.favoriteTableView.reloadData()
        }
    }
}

extension FavoriteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.favorites.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCellId", for: indexPath) as! TopListTableViewCell
        cell.setup(self, top: viewModel.favorites.value[indexPath.row])
        return cell
    }
    
}

extension FavoriteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.favorites.value[indexPath.row]
        if let urlString = item.url, let url = URL(string: urlString) {
            let safariView = SFSafariViewController(url: url)
            present(safariView, animated: true, completion: nil)
        }
    }
}

extension FavoriteListViewController: TopListCellDelegate {
    func cell(_ cell: TopListTableViewCell, didClickedFavorite topItem: TopItem) {
        viewModel.unfavoriteMalId(malId: topItem.mal_id)
    }
    
}
