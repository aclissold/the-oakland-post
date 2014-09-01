//
//  ShowAlertForErrorCode.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 8/31/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

func showAlertForErrorCode(code: Int) {
    UIAlertView(title: "Error", message: messages[code], delegate: nil, cancelButtonTitle: "OK").show()
}

// UIAlertView messages for errors found in PFConstants.h. User-facing errors have a detailed
// description. The other errors are provided for debugging purposes, but are kept generic in case
// they find their way into the app.
private let messages = [
    kPFErrorAccountAlreadyLinked: "An error has occured. (\(kPFErrorAccountAlreadyLinked))",
    kPFErrorCacheMiss: "An error has occured. (\(kPFErrorCacheMiss))",
    kPFErrorCommandUnavailable: "An error has occured. (\(kPFErrorCommandUnavailable))",
    kPFErrorConnectionFailed: "The connection failed. Please try again later.",
    kPFErrorDuplicateValue: "An error has occured. (\(kPFErrorDuplicateValue))",
    kPFErrorExceededQuota: "An error has occured. (\(kPFErrorExceededQuota))",
    // kPFErrorFacebookAccountAlreadyLinked: "An error has occured. (\(kPFErrorFacebookAccountAlreadyLinked))", same as kPFErrorAccountAlreadyLinked
    kPFErrorFacebookIdMissing: "An error has occured. (\(kPFErrorFacebookIdMissing))",
    kPFErrorFacebookInvalidSession: "An error has occured. (\(kPFErrorFacebookInvalidSession))",
    kPFErrorFileDeleteFailure: "An error has occured. (\(kPFErrorFileDeleteFailure))",
    kPFErrorIncorrectType: "An error has occured. (\(kPFErrorIncorrectType))",
    kPFErrorInternalServer: "Internal server error. Please try again later.",
    kPFErrorInvalidACL: "An error has occured. (\(kPFErrorInvalidACL))",
    kPFErrorInvalidChannelName: "An error has occured. (\(kPFErrorInvalidChannelName))",
    kPFErrorInvalidClassName: "An error has occured. (\(kPFErrorInvalidClassName))",
    kPFErrorInvalidDeviceToken: "An error has occured. (\(kPFErrorInvalidDeviceToken))",
    kPFErrorInvalidEmailAddress: "Your email address appears to be invalid. Please correct and typos and try again.",
    kPFErrorInvalidFileName: "An error has occured. (\(kPFErrorInvalidFileName))",
    kPFErrorInvalidImageData: "An error has occured. (\(kPFErrorInvalidImageData))",
    kPFErrorInvalidJSON: "An error has occured. (\(kPFErrorInvalidJSON))",
    kPFErrorInvalidKeyName: "An error has occured. (\(kPFErrorInvalidKeyName))",
    // kPFErrorInvalidLinkedSession: "An error has occured. (\(kPFErrorInvalidLinkedSession))", same as kPFErrorFacebookInvalidSession
    kPFErrorInvalidNestedKey: "An error has occured. (\(kPFErrorInvalidNestedKey))",
    kPFErrorInvalidPointer: "An error has occured. (\(kPFErrorInvalidPointer))",
    kPFErrorInvalidProductIdentifier: "An error has occured. (\(kPFErrorInvalidProductIdentifier))",
    kPFErrorInvalidPurchaseReceipt: "An error has occured. (\(kPFErrorInvalidPurchaseReceipt))",
    kPFErrorInvalidQuery: "An error has occured. (\(kPFErrorInvalidQuery))",
    kPFErrorInvalidRoleName: "An error has occured. (\(kPFErrorInvalidRoleName))",
    kPFErrorInvalidServerResponse: "An error has occured. (\(kPFErrorInvalidServerResponse))",
    // kPFErrorLinkedIdMissing: "An error has occured. (\(kPFErrorLinkedIdMissing))", same as kPFErrorFacebookIdMissing
    kPFErrorMissingObjectId: "An error has occured. (\(kPFErrorMissingObjectId))",
    kPFErrorObjectNotFound: "Unable to log in with the provided credentials. Please check your username and password.",
    kPFErrorObjectTooLarge: "An error has occured. (\(kPFErrorObjectTooLarge))",
    kPFErrorOperationForbidden: "An error has occured. (\(kPFErrorOperationForbidden))",
    kPFErrorPaymentDisabled: "An error has occured. (\(kPFErrorPaymentDisabled))",
    kPFErrorProductDownloadFileSystemFailure: "An error has occured. (\(kPFErrorProductDownloadFileSystemFailure))",
    kPFErrorProductNotFoundInAppStore: "An error has occured. (\(kPFErrorProductNotFoundInAppStore))",
    kPFErrorPushMisconfigured: "An error has occured. (\(kPFErrorPushMisconfigured))",
    kPFErrorReceiptMissing: "An error has occured. (\(kPFErrorReceiptMissing))",
    kPFErrorTimeout: "The request timed out. Please try again.",
    kPFErrorUnsavedFile: "An error has occured. (\(kPFErrorUnsavedFile))",
    kPFErrorUserCanOnlyBeCreatedThroughSignUp: "An error has occured. (\(kPFErrorUserCanOnlyBeCreatedThroughSignUp))",
    kPFErrorUserCannotBeAlteredWithoutSession: "An error has occured. (\(kPFErrorUserCannotBeAlteredWithoutSession))",
    kPFErrorUserEmailMissing: "The email is missing, and must be specified.",
    kPFErrorUserEmailTaken: "The provided email address has already been taken. Please choose another or tap \"Forgot your password?\" on the login screen.",
    kPFErrorUserIdMismatch: "An error has occured. (\(kPFErrorUserIdMismatch))",
    kPFErrorUserPasswordMissing: "Password is missing or empty. Please correct this and try again.",
    kPFErrorUserWithEmailNotFound: "An account with the specified email was not found.",
    kPFErrorUsernameMissing: "Username is missing or empty. Please correct this and try again.",
    kPFErrorUsernameTaken: "The provided username has already been taken. Please choose another or tap \"Forgot your password?\" on the login screen.",
    kPFScriptError: "An error has occured. (\(kPFScriptError))",
    kPFValidationError: "An error has occured. (\(kPFValidationError))",
]
