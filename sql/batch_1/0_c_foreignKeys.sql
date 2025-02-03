USE RepairMart
GO

-------------
-- DELETE FKs
-------------
-- emails
IF EXISTS(SELECT 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID('emails'))
BEGIN
    ALTER TABLE emails DROP CONSTRAINT IF EXISTS FK_Emails_EmailFromID;
    ALTER TABLE emails DROP CONSTRAINT IF EXISTS FK_Emails_ListingID;
    ALTER TABLE emails DROP CONSTRAINT IF EXISTS FK_Emails_OrderID;
    ALTER TABLE emails DROP CONSTRAINT IF EXISTS FK_Emails_QuoteID;
END
GO

-- emails_attachments
IF EXISTS(SELECT 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID('emails_attachments'))
BEGIN
    ALTER TABLE emails_attachments DROP CONSTRAINT IF EXISTS FK_EmailsAttachments_EmailID;
    ALTER TABLE emails_attachments DROP CONSTRAINT IF EXISTS FK_EmailsAttachments_AttachmentID;
END
GO

-- emails_recipients
IF EXISTS(SELECT 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID('emails_recipients'))
BEGIN
    ALTER TABLE emails_recipients DROP CONSTRAINT IF EXISTS FK_EmailsRecipients_EmailID;
    ALTER TABLE emails_recipients DROP CONSTRAINT IF EXISTS FK_EmailsRecipients_RecipientUserID;
END
GO

-- listings
IF EXISTS(SELECT 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID('listings'))
BEGIN
    ALTER TABLE listings DROP CONSTRAINT IF EXISTS FK_Listings_UserID;
    ALTER TABLE listings DROP CONSTRAINT IF EXISTS FK_Listings_ListingStatusID;
    ALTER TABLE listings DROP CONSTRAINT IF EXISTS FK_Listings_OverrideCountryID;
	ALTER TABLE listings DROP CONSTRAINT IF EXISTS FK_Listings_ListingBudgetCurrencyID;
	ALTER TABLE listings DROP CONSTRAINT IF EXISTS FK_Listings_ManufacturerID;
END
GO

-- listings_attachments
IF EXISTS(SELECT 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID('listings_attachments'))
BEGIN
    ALTER TABLE listings_attachments DROP CONSTRAINT IF EXISTS FK_ListingsAttachments_ListingID;
    ALTER TABLE listings_attachments DROP CONSTRAINT IF EXISTS FK_ListingsAttachments_AttachmentID;
END
GO

-- listings_productClassification
IF EXISTS(SELECT 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID('listings_productClassification'))
BEGIN
    ALTER TABLE listings_productClassification DROP CONSTRAINT IF EXISTS FK_ListingsProductClassification_ListingID;
    ALTER TABLE listings_productClassification DROP CONSTRAINT IF EXISTS FK_ListingsProductClassification_ProductClassificationID;
END
GO

-- orders
IF EXISTS(SELECT 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID('orders'))
BEGIN
    ALTER TABLE orders DROP CONSTRAINT IF EXISTS FK_Orders_ListingID;
    ALTER TABLE orders DROP CONSTRAINT IF EXISTS FK_Orders_QuoteDeliveryMethodID;
    ALTER TABLE orders DROP CONSTRAINT IF EXISTS FK_Orders_OrderStatusID;
END
GO

-- orders_attachments
IF EXISTS(SELECT 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID('orders_attachments'))
BEGIN
    ALTER TABLE orders_attachments DROP CONSTRAINT IF EXISTS FK_OrdersAttachments_OrderID;
    ALTER TABLE orders_attachments DROP CONSTRAINT IF EXISTS FK_OrdersAttachments_AttachmentID;
END
GO

-- orders_feedback
IF EXISTS(SELECT 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID('orders_feedback'))
BEGIN
    ALTER TABLE orders_feedback DROP CONSTRAINT IF EXISTS FK_OrdersFeedback_OrderID;
    ALTER TABLE orders_feedback DROP CONSTRAINT IF EXISTS FK_OrdersFeedback_UserID;
    ALTER TABLE orders_feedback DROP CONSTRAINT IF EXISTS FK_OrdersFeedback_FeedbackTypeID;
END
GO

-- quotes
IF EXISTS(SELECT 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID('quotes'))
BEGIN
    ALTER TABLE quotes DROP CONSTRAINT IF EXISTS FK_Quotes_UserID;
    ALTER TABLE quotes DROP CONSTRAINT IF EXISTS FK_Quotes_ListingID;
    ALTER TABLE quotes DROP CONSTRAINT IF EXISTS FK_Quotes_QuoteStatusID;
    ALTER TABLE quotes DROP CONSTRAINT IF EXISTS FK_Quotes_QuoteCurrencyID;
    ALTER TABLE quotes DROP CONSTRAINT IF EXISTS FK_Quotes_OverrideCountryID;
END
GO

-- quotes_deliveryMethod
IF EXISTS(SELECT 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID('quotes_deliveryMethod'))
BEGIN
    ALTER TABLE quotes_deliveryMethod DROP CONSTRAINT IF EXISTS FK_QuoteDeliveryMethod_QuoteID;
    ALTER TABLE quotes_deliveryMethod DROP CONSTRAINT IF EXISTS FK_QuoteDeliveryMethod_DeliveryMethodID;
END
GO

-- runIds
IF EXISTS(SELECT 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID('runIds'))
BEGIN
    ALTER TABLE runIds DROP CONSTRAINT IF EXISTS FK_RunIDs_UpdatedBy;
END
GO

-- users
IF EXISTS(SELECT 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID('users'))
BEGIN
    ALTER TABLE users DROP CONSTRAINT IF EXISTS FK_Users_CountryID;
    ALTER TABLE users DROP CONSTRAINT IF EXISTS FK_Users_AccountTypeID;
END
GO

-- userAuth
IF EXISTS(SELECT 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID('userAuth'))
BEGIN
    ALTER TABLE userAuth DROP CONSTRAINT IF EXISTS FK_UserAuth_UserID;
END
GO