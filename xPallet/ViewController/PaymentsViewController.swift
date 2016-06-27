//
//  PaymentsViewController.swift
//  xPallet
//
//  Created by ChengXian Lim on 11/24/15.
//  Copyright © 2015 xPallet Inc. All rights reserved.
//

import UIKit
import Braintree

class PaymentsViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var txtPromoCode: UITextField!
    @IBOutlet weak var btnAddCard: UIButton!
    @IBOutlet weak var cardCarousel: iCarousel!
    @IBOutlet weak var cardPageControl: UIPageControl!
    
    var creditCards = Array<CardContentModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardCarousel.dataSource = self
        cardCarousel.delegate = self
        cardCarousel.type = iCarouselType.Rotary
        
        readCreditCards()
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    @IBAction func tapBackButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func tapAddCardButton(sender: AnyObject) {
        self.navigationController?.pushViewController(self.storyboard?.instantiateViewControllerWithIdentifier("addCardView") as! AddCardViewController, animated: true)
    }
    
    func numberOfItemsInCarousel(carousel: iCarousel!) -> Int {
        return self.creditCards.count
    }
    
    func carousel(carousel: iCarousel!, viewForItemAtIndex index: Int, reusingView view: UIView!) -> UIView! {
        var cardView: CreditCardView! = nil
        var v: UIView
        
        if view == nil {
            v = UIView(frame:CGRectMake(0, 0, cardCarousel.frame.size.width * 0.7, cardCarousel.frame.size.width * 0.4))
            cardView = NSBundle.mainBundle().loadNibNamed("CreditCardView", owner: self, options: nil)[0] as! CreditCardView
            cardView.frame = v.bounds
            cardView.tag = 1000 + index
            v.addSubview(cardView)
        } else {
            v = view
            cardView = view.viewWithTag(1000 + index) as! CreditCardView!
        }
        let cardNumber = self.creditCards[index].cardNumber
        cardView.cardNumber.text = "XXXX XXXX XXXX " + String(cardNumber.characters.suffix(4))
        cardView.cardExpireEndDate.text = self.creditCards[index].cardExpireEndDate
        
        return v
    }
    
    func carousel(carousel: iCarousel!, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == .Spacing {
            return value * 1.2
        }
        return value
    }
    
    func carousel(carousel: iCarousel!, didSelectItemAtIndex index: Int) {
        cardPageControl.currentPage = index
    }
    
    func carouselDidScroll(carousel: iCarousel!) {
        cardPageControl.currentPage = carousel.currentItemIndex
    }
    
    //Read credit cards : Update later (for test now)
    func readCreditCards(){
        
        creditCards.removeAll()
        let creditCard1 = CardContentModel()
        let creditCard2 = CardContentModel()
        let creditCard3 = CardContentModel()
        
        creditCard1.cardNumber = "1234  4567  7890  1234"
        creditCard1.cardExpireEndDate = "05/17"
        creditCards.append(creditCard1)
        
        creditCard2.cardNumber = "9876  5432  1098  7654"
        creditCard2.cardExpireEndDate = "06/17"
        creditCards.append(creditCard2)
        
        creditCard3.cardNumber = "1564  2466  5148  2545"
        creditCard3.cardExpireEndDate = "10/17"
        creditCards.append(creditCard3)
        
        cardPageControl.numberOfPages = creditCards.count
        cardPageControl.currentPage = 0
        
        cardCarousel.reloadData()
    }
}
