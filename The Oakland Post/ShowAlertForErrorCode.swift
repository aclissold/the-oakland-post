//
//  ShowAlertForErrorCode.swift
//  The Oakland Post
//
//  UIAlertView messages for errors found in PFConstants.h. User-facing errors have a detailed
//  description. The other errors are provided for debugging purposes, but are kept generic in case
//  they find their way into the app.
//
//  Created by Andrew Clissold on 8/31/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

func showAlertForErrorCode(code: Int) {
    UIAlertView(title: "Error", message: messages[code], delegate: nil, cancelButtonTitle: "OK").show()
}

private let messages: [Int: String] = [
//    feedParserDidFailErrorCode: "Could not download posts. Please check your Internet connection and try again." // for MWFeedParser

//    PFErrorCode.ErrorAccountAlreadyLinked: "An error has occured. (\(PFErrorCode.ErrorAccountAlreadyLinked))", same as PFErrorCode.ErrorFacebookAccountAlreadyLinked
    PFErrorCode.ErrorCacheMiss.rawValue: "An error has occured. (\(PFErrorCode.ErrorCacheMiss.rawValue))",
    PFErrorCode.ErrorCommandUnavailable.rawValue: "An error has occured. (\(PFErrorCode.ErrorCommandUnavailable.rawValue))",
    PFErrorCode.ErrorConnectionFailed.rawValue: "The connection failed. Please try again later.",
    PFErrorCode.ErrorDuplicateValue.rawValue: "An error has occured. (\(PFErrorCode.ErrorDuplicateValue.rawValue))",
    PFErrorCode.ErrorExceededQuota.rawValue: "An error has occured. (\(PFErrorCode.ErrorExceededQuota.rawValue))",
    PFErrorCode.ErrorFacebookAccountAlreadyLinked.rawValue: "An error has occured. (\(PFErrorCode.ErrorFacebookAccountAlreadyLinked.rawValue))",
    PFErrorCode.ErrorFacebookIdMissing.rawValue: "An error has occured. (\(PFErrorCode.ErrorFacebookIdMissing.rawValue))",
    PFErrorCode.ErrorFacebookInvalidSession.rawValue: "An error has occured. (\(PFErrorCode.ErrorFacebookInvalidSession.rawValue))",
    PFErrorCode.ErrorFileDeleteFailure.rawValue: "An error has occured. (\(PFErrorCode.ErrorFileDeleteFailure.rawValue))",
    PFErrorCode.ErrorIncorrectType.rawValue: "An error has occured. (\(PFErrorCode.ErrorIncorrectType.rawValue))",
    PFErrorCode.ErrorInternalServer.rawValue: "Internal server error. Please try again later.",
    PFErrorCode.ErrorInvalidACL.rawValue: "An error has occured. (\(PFErrorCode.ErrorInvalidACL.rawValue))",
    PFErrorCode.ErrorInvalidChannelName.rawValue: "An error has occured. (\(PFErrorCode.ErrorInvalidChannelName.rawValue))",
    PFErrorCode.ErrorInvalidClassName.rawValue: "An error has occured. (\(PFErrorCode.ErrorInvalidClassName.rawValue))",
    PFErrorCode.ErrorInvalidDeviceToken.rawValue: "An error has occured. (\(PFErrorCode.ErrorInvalidDeviceToken.rawValue))",
    PFErrorCode.ErrorInvalidEmailAddress.rawValue: "Your email address appears to be invalid. Please correct and typos and try again.",
    PFErrorCode.ErrorInvalidFileName.rawValue: "An error has occured. (\(PFErrorCode.ErrorInvalidFileName.rawValue))",
    PFErrorCode.ErrorInvalidImageData.rawValue: "An error has occured. (\(PFErrorCode.ErrorInvalidImageData.rawValue))",
    PFErrorCode.ErrorInvalidJSON.rawValue: "An error has occured. (\(PFErrorCode.ErrorInvalidJSON.rawValue))",
    PFErrorCode.ErrorInvalidKeyName.rawValue: "An error has occured. (\(PFErrorCode.ErrorInvalidKeyName.rawValue))",
//    PFErrorCode.ErrorInvalidLinkedSession.rawValue: "An error has occured. (\(PFErrorCode.ErrorInvalidLinkedSession.rawValue))", same as PFErrorCode.ErrorFacebookInvalidSession
    PFErrorCode.ErrorInvalidNestedKey.rawValue: "An error has occured. (\(PFErrorCode.ErrorInvalidNestedKey.rawValue))",
    PFErrorCode.ErrorInvalidPointer.rawValue: "An error has occured. (\(PFErrorCode.ErrorInvalidPointer.rawValue))",
    PFErrorCode.ErrorInvalidProductIdentifier.rawValue: "An error has occured. (\(PFErrorCode.ErrorInvalidProductIdentifier.rawValue))",
    PFErrorCode.ErrorInvalidPurchaseReceipt.rawValue: "An error has occured. (\(PFErrorCode.ErrorInvalidPurchaseReceipt.rawValue))",
    PFErrorCode.ErrorInvalidQuery.rawValue: "An error has occured. (\(PFErrorCode.ErrorInvalidQuery.rawValue))",
    PFErrorCode.ErrorInvalidRoleName.rawValue: "An error has occured. (\(PFErrorCode.ErrorInvalidRoleName.rawValue))",
    PFErrorCode.ErrorInvalidServerResponse.rawValue: "An error has occured. (\(PFErrorCode.ErrorInvalidServerResponse.rawValue))",
//    PFErrorCode.ErrorLinkedIdMissing.rawValue: "An error has occured. (\(PFErrorCode.ErrorLinkedIdMissing.rawValue))", same as PFErrorCode.ErrorFacebookIdMissing
    PFErrorCode.ErrorMissingObjectId.rawValue: "An error has occured. (\(PFErrorCode.ErrorMissingObjectId.rawValue))",
    PFErrorCode.ErrorObjectNotFound.rawValue: "Unable to log in with the provided credentials. Please check your username and password.",
    PFErrorCode.ErrorObjectTooLarge.rawValue: "An error has occured. (\(PFErrorCode.ErrorObjectTooLarge.rawValue))",
    PFErrorCode.ErrorOperationForbidden.rawValue: "An error has occured. (\(PFErrorCode.ErrorOperationForbidden.rawValue))",
    PFErrorCode.ErrorPaymentDisabled.rawValue: "An error has occured. (\(PFErrorCode.ErrorPaymentDisabled.rawValue))",
    PFErrorCode.ErrorProductDownloadFileSystemFailure.rawValue: "An error has occured. (\(PFErrorCode.ErrorProductDownloadFileSystemFailure.rawValue))",
    PFErrorCode.ErrorProductNotFoundInAppStore.rawValue: "An error has occured. (\(PFErrorCode.ErrorProductNotFoundInAppStore.rawValue))",
    PFErrorCode.ErrorPushMisconfigured.rawValue: "An error has occured. (\(PFErrorCode.ErrorPushMisconfigured.rawValue))",
    PFErrorCode.ErrorReceiptMissing.rawValue: "An error has occured. (\(PFErrorCode.ErrorReceiptMissing.rawValue))",
    PFErrorCode.ErrorTimeout.rawValue: "The request timed out. Please try again.",
    PFErrorCode.ErrorUnsavedFile.rawValue: "An error has occured. (\(PFErrorCode.ErrorUnsavedFile.rawValue))",
    PFErrorCode.ErrorUserCanOnlyBeCreatedThroughSignUp.rawValue: "An error has occured. (\(PFErrorCode.ErrorUserCanOnlyBeCreatedThroughSignUp.rawValue))",
    PFErrorCode.ErrorUserCannotBeAlteredWithoutSession.rawValue: "An error has occured. (\(PFErrorCode.ErrorUserCannotBeAlteredWithoutSession.rawValue))",
    PFErrorCode.ErrorUserEmailMissing.rawValue: "The email is missing, and must be specified.",
    PFErrorCode.ErrorUserEmailTaken.rawValue: "The provided email address has already been taken. Please choose another or tap \"Forgot your password?\" on the login screen.",
    PFErrorCode.ErrorInvalidSessionToken.rawValue: "An error has occured. (\(PFErrorCode.ErrorInvalidSessionToken.rawValue))",
//    PFErrorCode.ErrorUserIdMismatch.rawValue: "An error has occured. (\(PFErrorCode.ErrorUserIdMismatch.rawValue))",
    PFErrorCode.ErrorUserPasswordMissing.rawValue: "Password is missing or empty. Please correct this and try again.",
    PFErrorCode.ErrorUserWithEmailNotFound.rawValue: "An account with the specified email was not found.",
    PFErrorCode.ErrorUsernameMissing.rawValue: "Username is missing or empty. Please correct this and try again.",
    PFErrorCode.ErrorUsernameTaken.rawValue: "The provided username has already been taken. Please choose another or tap \"Forgot your password?\" on the login screen.",
    PFErrorCode.ScriptError.rawValue: "An error has occured. (\(PFErrorCode.ScriptError.rawValue))",
    PFErrorCode.ValidationError.rawValue: "An error has occured. (\(PFErrorCode.ValidationError.rawValue))"
]
