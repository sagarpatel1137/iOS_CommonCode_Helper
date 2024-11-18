//
//  FirebaseEvents.swift
//  VoiceChanger
//
//  Created by iOS on 09/08/23.
//

import FirebaseAnalytics

func AddFirebaseEvent(eventName: EventsValues, parameters: [String:Any] = [:]) {
    let strEventName = "\(Pod_FirebaseAppName)\(eventName.rawValue)"
    Analytics.logEvent(strEventName, parameters: parameters)
    AppMetrica_Event.AddAppMetricaEvent(eventName: strEventName)
}

enum EventsValues: String {
    
    // Timeline
    case SubMonthltyTimeLimeShow            =    "_TIMELINE_SUBS"
    case SubMonthltyTimeLimeClick           =    "_TIMELINE_SUBS_CLICK"
    case SubMonthltyMonthTimeLimeTrial      =    "_TIMELINE_SUBS_TRIAL"
    
    // All Plan
    case SubAllPlanShow                     =    "_ALL_PLAN_SUBS"
    case SubAllPlanClick                    =    "_ALL_PLAN_SUBS_CLICK"
    case SubAllPlanSuccess                  =    "_ALL_PLAN_SUBS_SUCCESS"
    case SubAllPlanTrial                    =    "_ALL_PLAN_SUBS_TRIAL"
    
    // Six Box Plan
    case SubSixBoxShow                      =    "_SIX_BOX_SUBS"
    case SubSixBoxClick                     =    "_SIX_BOX_SUBS_CLICK"
    case SubSixBoxSuccess                   =    "_SIX_BOX_SUBS_SUCCESS"
    case SubSixBoxTrial                     =    "_SIX_BOX_SUBS_TRIAL"
    
    // Discount
    case SubDiscountShow                    =    "_DISCOUNT_SUBS"
    case SubDiscountClick                   =    "_DISCOUNT_SUBS_CLICK"
    case SubMonthDiscountPurchaseSuccess    =    "_DISCOUNT_SUBS_SUCCESS"
    
    // Thank You
    case SubThankYouShow                    =    "_THANK_YOU"
    
    // Rating
    case RatingShow                         =    "_RATING_DIALOG"
    case RatingPositive                     =    "_RATING_DIALOG_POSITIVE"
    case RatingNegative                     =    "_RATING_DIALOG_NEGATIVE"
    case RatingLater                        =    "_RATING_DIALOG_LATER"
    
    // Feedback
    case FeedbackSubmit                    =    "_FEEDBACK_SUBMIT"
}
