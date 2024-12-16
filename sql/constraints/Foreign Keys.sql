USE RepairMart
GO

-- emails
ALTER TABLE dbo.emails ADD CONSTRAINT FK_Emails_EmailFromID FOREIGN KEY (emailFromId) REFERENCES users(userId);
ALTER TABLE dbo.emails ADD CONSTRAINT FK_Emails_ListingID FOREIGN KEY (listingId) REFERENCES listings(listingId);
ALTER TABLE dbo.emails ADD CONSTRAINT FK_Emails_OrderID FOREIGN KEY (orderId) REFERENCES orders(orderId);
ALTER TABLE dbo.emails ADD CONSTRAINT FK_Emails_QuoteID FOREIGN KEY (quoteId) REFERENCES quotes(quoteId);

-- emailRecipients
ALTER TABLE dbo.emailRecipients ADD CONSTRAINT FK_EmailRecipients_EmailID FOREIGN KEY (emailId) REFERENCES emails(emailId);
ALTER TABLE dbo.emailRecipients ADD CONSTRAINT FK_EmailRecipients_RecipientUserID FOREIGN KEY (recipientUserId) REFERENCES users(userId);

-- emails_attachments
ALTER TABLE dbo.emails_attachments ADD CONSTRAINT FK_EmailsAttachments_EmailID FOREIGN KEY (emailId) REFERENCES emails(emailId);
ALTER TABLE dbo.emails_attachments ADD CONSTRAINT FK_EmailsAttachments_AttachmentID FOREIGN KEY (attachmentId) REFERENCES attachments(attachmentId);

-- listings
ALTER TABLE dbo.listings ADD CONSTRAINT FK_Listings_UserID FOREIGN KEY (userId) REFERENCES users(userId);
ALTER TABLE dbo.listings ADD CONSTRAINT FK_Listings_ListingStatusID FOREIGN KEY (listingStatusId) REFERENCES listingStatus(listingStatusId);
ALTER TABLE dbo.listings ADD CONSTRAINT FK_Listings_OverrideCountryID FOREIGN KEY (overrideCountryId) REFERENCES country(countryId);

-- listings_attachments
ALTER TABLE dbo.listings_attachments ADD CONSTRAINT FK_ListingsAttachments_ListingID FOREIGN KEY (listingId) REFERENCES listings(listingId);
ALTER TABLE dbo.listings_attachments ADD CONSTRAINT FK_ListingsAttachments_AttachmentID FOREIGN KEY (attachmentId) REFERENCES attachments(attachmentId);

-- orders
ALTER TABLE dbo.orders ADD CONSTRAINT FK_Orders_ListingID FOREIGN KEY (listingId) REFERENCES listings(listingId);
ALTER TABLE dbo.orders ADD CONSTRAINT FK_Orders_QuoteDeliveryMethodID FOREIGN KEY (quote_deliveryMethodId) REFERENCES quote_deliveryMethod(quote_deliveryMethodId);
ALTER TABLE dbo.orders ADD CONSTRAINT FK_Orders_OrderStatusID FOREIGN KEY (quote_deliveryMethodId) REFERENCES quote_deliveryMethod(quote_deliveryMethodId);

-- ordersFeedback
ALTER TABLE dbo.ordersFeedback ADD CONSTRAINT FK_OrdersFeedback_OrderID FOREIGN KEY (orderId) REFERENCES orders(orderId);
ALTER TABLE dbo.ordersFeedback ADD CONSTRAINT FK_OrdersFeedback_UserID FOREIGN KEY (userId) REFERENCES users(userId);
ALTER TABLE dbo.ordersFeedback ADD CONSTRAINT FK_OrdersFeedback_FeedbackTypeID FOREIGN KEY (feedbackTypeId) REFERENCES feedbackType(feedbackTypeId);

-- quote_deliveryMethod
ALTER TABLE dbo.quote_deliveryMethod ADD CONSTRAINT FK_QuoteDeliveryMethod_QuoteID FOREIGN KEY (quoteId) REFERENCES quotes(quoteId);
ALTER TABLE dbo.quote_deliveryMethod ADD CONSTRAINT FK_QuoteDeliveryMethod_DeliveryMethodID FOREIGN KEY (deliveryMethodId) REFERENCES deliveryMethod(deliveryMethodId);

-- quotes
ALTER TABLE dbo.quotes ADD CONSTRAINT FK_Quotes_UserID FOREIGN KEY (userId) REFERENCES users(userId);
ALTER TABLE dbo.quotes ADD CONSTRAINT FK_Quotes_ListingID FOREIGN KEY (listingId) REFERENCES listings(listingId);
ALTER TABLE dbo.quotes ADD CONSTRAINT FK_Quotes_QuoteStatusID FOREIGN KEY (quoteStatusId) REFERENCES quoteStatus(quoteStatusId);
ALTER TABLE dbo.quotes ADD CONSTRAINT FK_Quotes_QuoteCurrencyID FOREIGN KEY (quoteCurrencyId) REFERENCES currency(currencyId);
ALTER TABLE dbo.quotes ADD CONSTRAINT FK_Quotes_OverrideCountryID FOREIGN KEY (overrideCountryId) REFERENCES country(countryId);

-- users
ALTER TABLE dbo.users ADD CONSTRAINT FK_Users_CountryID FOREIGN KEY (countryId) REFERENCES country(countryId);
ALTER TABLE dbo.users ADD CONSTRAINT FK_Users_AccountTypeID FOREIGN KEY (accountTypeId) REFERENCES accountType(accountTypeId);

-- userAuth
ALTER TABLE dbo.userAuth ADD CONSTRAINT FK_UserAuth_UserID FOREIGN KEY (userId) REFERENCES users(userId);
