//
//  StocksTableViewController.swift
//  Stocks App
//
//  Created by bhanuteja on 15/12/21.
//

import UIKit
import Alamofire
import PusherSwift
import PushNotifications
import NotificationBannerSwift

class StocksTableViewController: UITableViewController {

    var pusher: Pusher!
    var pushNotifications = PushNotifications.shared
    var notificationSettings = STNotificationSetting.shared
    var stocks = [Stock]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorInset.left = 0
        tableView.backgroundColor = .black
        tableView.tableFooterView = UIView()
        let customCell = UINib(nibName: "StockTableViewCell", bundle: nil)
        tableView.register(customCell, forCellReuseIdentifier: "stockCell")
        fetchStockPrices()
        pusher = Pusher(
            key: AppConstants.PUSHER_APP_KEY,
            options: PusherClientOptions(host: .cluster(AppConstants.PUSHER_APP_CLUSTER))
        )
        let channel = pusher.subscribe("Stocks")
        let _ = channel.bind(eventName: "update") { [unowned self] data in
            if let data = data as? [[String: AnyObject]] {
                if let encoded = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted) {
                    if let stocks = try? JSONDecoder().decode([Stock].self, from: encoded) {
                        self.stocks = stocks
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
        pusher.connect()
    }
    
    private func fetchStockPrices() {
            Alamofire.request(AppConstants.ENDPOINT + "/stocks")
                .validate()
                .responseJSON { [unowned self] resp in
                    guard let data = resp.data, resp.result.isSuccess else {
                        let msg = "Error fetching prices"
                        return StatusBarNotificationBanner(title: msg, style: .danger).show()
                    }
                    
                    if let stocks = try? JSONDecoder().decode([Stock].self, from: data) {
                        self.stocks = stocks
                        self.tableView.reloadData()
                    }
                }
        }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell", for: indexPath) as? StockTableViewCell else {
            return UITableViewCell()
        }
        cell.stock = stocks[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? StockTableViewCell else {
            return
        }
        cell.selectionStyle = .none
        if let stock = cell.stock {
            self.saveNotificationSetting(for: stock)
        }
    }
}

extension StocksTableViewController {
    func saveNotificationSetting(for stock: Stock) {
        let enabled = self.notificationSettings.enabled(for: stock.name)
        let title = "Notification settings"
        let message = "Change the notification settings for this stock. What would you like to do?"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let onButtonTitle = enabled ? "keep on" : "Turn on notification"
        let onAction = UIAlertAction(title: onButtonTitle, style: .default) { [weak self] action in
            guard enabled == false else {return}
            self?.notificationSettings.saveNotification(for: stock.name, enabled: true)
            let feedback = "Notfications turned on for \(stock.name)"
            StatusBarNotificationBanner(title: feedback, style: .success).show()
            
            try? self?.pushNotifications.subscribe(interest: stock.name.uppercased())
        }
        alert.addAction(onAction)
        let offTitle = enabled ? "Turn off notifications" : "Leave off"
        let offStyle: UIAlertAction.Style = enabled ? .destructive : .cancel
        let offAction = UIAlertAction(title: offTitle, style: offStyle) { [weak self] action in
            guard enabled else { return }
            self?.notificationSettings.saveNotification(for: stock.name, enabled: false)
            
            let feedback = "Notfications turned off for \(stock.name)"
            StatusBarNotificationBanner(title: feedback, style: .success).show()
            
            try? self?.pushNotifications.unsubscribe(interest: stock.name.uppercased())
        }
        alert.addAction(offAction)
        present(alert, animated: true, completion: nil)
    }
    
}
