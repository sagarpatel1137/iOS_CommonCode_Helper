//
//  FirebaseEvents.swift
//  VoiceChanger
//
//  Created by iOS on 09/08/23.
//

import FirebaseAnalytics

func AddFirebaseEvent(eventName: EventsValues) {
    let eventName = "\(Pod_FirebaseAppName)\(eventName.rawValue)"
    Analytics.logEvent(Pod_FirebaseAppName, parameters: [Pod_FirebaseAppName : eventName])
    AppMetrica_Event.AddAppMetricaEvent(eventName: eventName)
}

enum EventsValues: String {
    
    //MARK: - Subscription
    case SubMonthltyShowTimeLime         = "_SUBS_MONTHLY_TIMELIME"
    case SubMonthltyClickTimeLime        = "_SUBS_MONTHLY_CLICK_TIMELIME"
    case SubMonthltyMonthTrialTimeLime   = "_SUBS_MONTHLY_MONTH_TRIAL_TIMELIME"
    case SubMoreShow                     = "_SUBS_MORE_PLAN"
    case SubMoreMonthClick               = "_SUBS_MORE_PLAN_MONTHLY_CLICK"
    case SubMoreMonthTrial               = "_SUBS_MORE_PLAN_MONTH_TRIAL"
    case SubMoreMonthPurchase            = "_SUBS_MORE_PLAN_MONTH_SUCCESS"
    case SubMoreYearClick                = "_SUBS_MORE_PLAN_YEARLY_CLICK"
    case SubMoreYearTrial                = "_SUBS_MORE_PLAN_YEAR_TRIAL"
    case SubMoreYearPurchase             = "_SUBS_MORE_PLAN_YEAR_SUCCESS"
    case SubMoreLifeTimeClick            = "_SUBS_MORE_PLAN_LIFETIME_CLICK"
    case SubMoreLifeTimePurchase         = "_SUBS_MORE_PLAN_LIFETIME_SUCCESS"
    case SubMoreWeekClick                = "_SUBS_MORE_PLAN_WEEKLY_CLICK"
    case SubMoreWeekTrial                = "_SUBS_MORE_PLAN_WEEK_TRIAL"
    case SubMoreWeekPurchase             = "_SUBS_MORE_PLAN_WEEK_SUCCESS"
    case SubDiscountShow                 = "_SUBS_DISCOUNT"
    case SubDiscountClick                = "_SUBS_DISCOUNT_CLICK"
    case SubMonthDiscountPurchase        = "_SUBS_DISCOUNT_MONTH_SUCCESS"
    case SubThankYou                     = "_SUBS_THANK_YOU"
    
    //MARK: - Rating
    case RatingShow                      = "_RATE_SHOW"
    case RatingAwesome                   = "_RATE_AWESOME"
    case RatingImprovement               = "_RATE_IMPROVEMENT"
    case RatingLater                     = "_RATE_LATER"
}
