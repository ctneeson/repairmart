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
END
GO

-- listings_attachments
IF EXISTS(SELECT 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID('listings_attachments'))
BEGIN
    ALTER TABLE listings_attachments DROP CONSTRAINT IF EXISTS FK_ListingsAttachments_ListingID;
    ALTER TABLE listings_attachments DROP CONSTRAINT IF EXISTS FK_ListingsAttachments_AttachmentID;
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


----------
-- ADD FKs
----------
-- emails
ALTER TABLE dbo.emails ADD CONSTRAINT FK_Emails_EmailFromID FOREIGN KEY (emailFromId) REFERENCES users(userId);
ALTER TABLE dbo.emails ADD CONSTRAINT FK_Emails_ListingID FOREIGN KEY (listingId) REFERENCES listings(listingId);
ALTER TABLE dbo.emails ADD CONSTRAINT FK_Emails_OrderID FOREIGN KEY (orderId) REFERENCES orders(orderId);
ALTER TABLE dbo.emails ADD CONSTRAINT FK_Emails_QuoteID FOREIGN KEY (quoteId) REFERENCES quotes(quoteId);

-- emails_attachments
ALTER TABLE dbo.emails_attachments ADD CONSTRAINT FK_EmailsAttachments_EmailID FOREIGN KEY (emailId) REFERENCES emails(emailId);
ALTER TABLE dbo.emails_attachments ADD CONSTRAINT FK_EmailsAttachments_AttachmentID FOREIGN KEY (attachmentId) REFERENCES attachments(attachmentId);

-- emails_recipients
ALTER TABLE dbo.emails_recipients ADD CONSTRAINT FK_EmailsRecipients_EmailID FOREIGN KEY (emailId) REFERENCES emails(emailId);
ALTER TABLE dbo.emails_recipients ADD CONSTRAINT FK_EmailsRecipients_RecipientUserID FOREIGN KEY (recipientUserId) REFERENCES users(userId);

-- listings
ALTER TABLE dbo.listings ADD CONSTRAINT FK_Listings_UserID FOREIGN KEY (userId) REFERENCES users(userId);
ALTER TABLE dbo.listings ADD CONSTRAINT FK_Listings_ListingStatusID FOREIGN KEY (listingStatusId) REFERENCES listingStatus(listingStatusId);
ALTER TABLE dbo.listings ADD CONSTRAINT FK_Listings_ListingBudgetCurrencyID FOREIGN KEY (listingBudgetCurrencyId) REFERENCES currency(currencyId);
ALTER TABLE dbo.listings ADD CONSTRAINT FK_Listings_OverrideCountryID FOREIGN KEY (overrideCountryId) REFERENCES country(countryId);

-- listings_attachments
ALTER TABLE dbo.listings_attachments ADD CONSTRAINT FK_ListingsAttachments_ListingID FOREIGN KEY (listingId) REFERENCES listings(listingId);
ALTER TABLE dbo.listings_attachments ADD CONSTRAINT FK_ListingsAttachments_AttachmentID FOREIGN KEY (attachmentId) REFERENCES attachments(attachmentId);

-- orders
ALTER TABLE dbo.orders ADD CONSTRAINT FK_Orders_ListingID FOREIGN KEY (listingId) REFERENCES listings(listingId);
ALTER TABLE dbo.orders ADD CONSTRAINT FK_Orders_QuoteDeliveryMethodID FOREIGN KEY (quote_deliveryMethodId) REFERENCES quotes_deliveryMethod(quote_deliveryMethodId);
ALTER TABLE dbo.orders ADD CONSTRAINT FK_Orders_OrderStatusID FOREIGN KEY (orderStatusId) REFERENCES orderStatus(orderStatusId);

-- orders_feedback
ALTER TABLE dbo.orders_feedback ADD CONSTRAINT FK_OrdersFeedback_OrderID FOREIGN KEY (orderId) REFERENCES orders(orderId);
ALTER TABLE dbo.orders_feedback ADD CONSTRAINT FK_OrdersFeedback_UserID FOREIGN KEY (userId) REFERENCES users(userId);
ALTER TABLE dbo.orders_feedback ADD CONSTRAINT FK_OrdersFeedback_FeedbackTypeID FOREIGN KEY (feedbackTypeId) REFERENCES feedbackType(feedbackTypeId);

-- quotes
ALTER TABLE dbo.quotes ADD CONSTRAINT FK_Quotes_UserID FOREIGN KEY (userId) REFERENCES users(userId);
ALTER TABLE dbo.quotes ADD CONSTRAINT FK_Quotes_ListingID FOREIGN KEY (listingId) REFERENCES listings(listingId);
ALTER TABLE dbo.quotes ADD CONSTRAINT FK_Quotes_QuoteStatusID FOREIGN KEY (quoteStatusId) REFERENCES quoteStatus(quoteStatusId);
ALTER TABLE dbo.quotes ADD CONSTRAINT FK_Quotes_QuoteCurrencyID FOREIGN KEY (quoteCurrencyId) REFERENCES currency(currencyId);
ALTER TABLE dbo.quotes ADD CONSTRAINT FK_Quotes_OverrideCountryID FOREIGN KEY (overrideCountryId) REFERENCES country(countryId);

-- quotes_deliveryMethod
ALTER TABLE dbo.quotes_deliveryMethod ADD CONSTRAINT FK_QuoteDeliveryMethod_QuoteID FOREIGN KEY (quoteId) REFERENCES quotes(quoteId);
ALTER TABLE dbo.quotes_deliveryMethod ADD CONSTRAINT FK_QuoteDeliveryMethod_DeliveryMethodID FOREIGN KEY (deliveryMethodId) REFERENCES deliveryMethod(deliveryMethodId);

-- users
ALTER TABLE dbo.users ADD CONSTRAINT FK_Users_CountryID FOREIGN KEY (countryId) REFERENCES country(countryId);
ALTER TABLE dbo.users ADD CONSTRAINT FK_Users_AccountTypeID FOREIGN KEY (accountTypeId) REFERENCES accountType(accountTypeId);

-- userAuth
ALTER TABLE dbo.userAuth ADD CONSTRAINT FK_UserAuth_UserID FOREIGN KEY (userId) REFERENCES users(userId);
