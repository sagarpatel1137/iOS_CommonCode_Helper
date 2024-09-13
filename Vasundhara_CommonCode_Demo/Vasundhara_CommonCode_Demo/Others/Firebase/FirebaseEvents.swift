//
//  FirebaseEvents.swift
//  VoiceChanger
//
//  Created by iOS on 09/08/23.
//

import FirebaseAnalytics
import iOS_CommonCode_Helper

func AddFirebaseEvent(eventName: EventsValues) {
    Analytics.logEvent(EventsName.AppName.rawValue, parameters: [EventsName.AppName.rawValue : eventName.rawValue])
    AppMetrica_Event.AddAppMetricaEvent(eventName: eventName.rawValue)
}

func AddFirebaseActionEvent(eventName: EventsValues, value: String) {
    let name = eventName.rawValue + value.uppercased()
    Analytics.logEvent(EventsName.AppName.rawValue, parameters: [EventsName.AppName.rawValue : name])
    AppMetrica_Event.AddAppMetricaEvent(eventName: name)
}

enum EventsName: String {
    case AppName                         = "VOICE_CHANGER"
}

enum EventsValues: String {
    
    //MARK: - Subscription
    case SubMonthltyShowTimeLime         = "VOICE_CHANGER_SUBS_MONTHLY_TIMELIME"
    case SubMonthltyClickTimeLime        = "VOICE_CHANGER_SUBS_MONTHLY_CLICK_TIMELIME"
    case SubMonthltyMonthTrialTimeLime   = "VOICE_CHANGER_SUBS_MONTHLY_MONTH_TRIAL_TIMELIME"
    
    case SubMoreShow                     = "VOICE_CHANGER_SUBS_MORE_PLAN"
    case SubMoreMonthClick               = "VOICE_CHANGER_SUBS_MORE_PLAN_MONTHLY_CLICK"
    case SubMoreMonthTrial               = "VOICE_CHANGER_SUBS_MORE_PLAN_MONTH_TRIAL"
    case SubMoreMonthPurchase            = "VOICE_CHANGER_SUBS_MORE_PLAN_MONTH_SUCCESS"
    case SubMoreYearClick                = "VOICE_CHANGER_SUBS_MORE_PLAN_YEARLY_CLICK"
    case SubMoreYearTrial                = "VOICE_CHANGER_SUBS_MORE_PLAN_YEAR_TRIAL"
    case SubMoreYearPurchase             = "VOICE_CHANGER_SUBS_MORE_PLAN_YEAR_SUCCESS"
    case SubMoreLifeTimeClick            = "VOICE_CHANGER_SUBS_MORE_PLAN_LIFETIME_CLICK"
    case SubMoreLifeTimePurchase         = "VOICE_CHANGER_SUBS_MORE_PLAN_LIFETIME_SUCCESS"
    case SubMoreWeekClick                = "VOICE_CHANGER_SUBS_MORE_PLAN_WEEKLY_CLICK"
    case SubMoreWeekTrial                = "VOICE_CHANGER_SUBS_MORE_PLAN_WEEK_TRIAL"
    case SubMoreWeekPurchase             = "VOICE_CHANGER_SUBS_MORE_PLAN_WEEK_SUCCESS"

    case SubDiscountShow                 = "VOICE_CHANGER_SUBS_DISCOUNT"
    case SubDiscountClick                = "VOICE_CHANGER_SUBS_DISCOUNT_CLICK"
    case SubMonthDiscountPurchase        = "VOICE_CHANGER_SUBS_DISCOUNT_MONTH_SUCCESS"
    
    case SubThankYou                     = "VOICE_CHANGER_SUBS_THANK_YOU"
    
    //MARK: - Rating
    case RatingShow                      = "VOICE_CHANGER_RATE_SHOW"
    case RatingAwesome                   = "VOICE_CHANGER_RATE_AWESOME"
    case RatingImprovement               = "VOICE_CHANGER_RATE_IMPROVEMENT"
    case RatingLater                     = "VOICE_CHANGER_RATE_LATER"
    
    //MARK: - Intro
    case SplashShow                   = "VOICE_CHANGER_SPLASH_SHOW"
}
