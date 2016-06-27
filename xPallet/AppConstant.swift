//
//  AppConstant.swift
//  xPallet
//
//  Created by ChengXian Lim on 11/23/15.
//  Copyright © 2015 xPallet Inc. All rights reserved.
//

import Foundation


//let GooglePlaceApiKey = "AIzaSyCxj2WOhDV69Dq4uKcd2oDAMLzPd9-woDc"
let GooglePlaceApiKey = "AIzaSyDpsDIPJtu_Hnc8tBSmaewqRyRXkfhlLdQ"

//API urls
let kUserLogIn = "http://b1.xpallet.com/users/sign_in.json"
let kUserSignUp = "http://b1.xpallet.com/users.json"
let kSMSVerify = "http://b1.xpallet.com/verify.json"
let kSMSVerifyResend = "http://b1.xpallet.com/resend_verification_code.json"
let kForgetPassword = "http://b1.xpallet.com/forgot_password"
let kChangePassword = "http://b1.xpallet.com/reset_password"

let kGetBrainTreeToken = "http://b1.xpallet.com/client_token"

//API Parameters
let pUserEmail = "user[email]"
let pUserPassword = "user[password]"
let pUserPasswordConfirm = "user[password_confirmation]"
let pUserFirstName = "user[first_name]"
let pUserLastName = "user[last_name]"
let pUserPhoneNumber = "user[phone_number]"
let pUserRole = "user[roles]"
let pUserVerificationCode = "verification_code"
let pUserToken = "user_token"
//let pUserAuthenticationToken = "authentication_token"
let pNewPassword = "password"
let pPasswordConfirm = "password_confirmation"
let pMobileFriendlyToken = "mobile_friendly_token"
let pBraintreeClientToken = "client_token"
let mPhoneNumber = "phone_number"

// API error messages
let eNotVerified = "You have to confirm your account before continuing"
let eEmailAreadyTaken = "has already been taken"
let eUserPhoneNumberNotFound = "User was not found with the phone number"

//Graphic
let placeholderTextColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.7)

//Others

let pickUpLatitude = "pickup latitude"
let pickUpLongitude = "pickup longitude"