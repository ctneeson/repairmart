USE RepairMart
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'currency' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[currency];
GO

CREATE TABLE currency (
 currencyId bigint NOT NULL PRIMARY KEY IDENTITY(1,1),
 currencyISO nvarchar(3) NOT NULL UNIQUE,
 currencyName nvarchar(150) NOT NULL UNIQUE,
 created_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
 ACTIVE bit NOT NULL DEFAULT 1
);
INSERT INTO currency (currencyISO, currencyName) VALUES ('AED', 'UAE Dirham');
INSERT INTO currency (currencyISO, currencyName) VALUES ('AFN', 'Afghani');
INSERT INTO currency (currencyISO, currencyName) VALUES ('ALL', 'Lek');
INSERT INTO currency (currencyISO, currencyName) VALUES ('AMD', 'Armenian Dram');
INSERT INTO currency (currencyISO, currencyName) VALUES ('ANG', 'Netherlands Antillean Guilder');
INSERT INTO currency (currencyISO, currencyName) VALUES ('AOA', 'Kwanza');
INSERT INTO currency (currencyISO, currencyName) VALUES ('ARS', 'Argentine Peso');
INSERT INTO currency (currencyISO, currencyName) VALUES ('AUD', 'Australian Dollar');
INSERT INTO currency (currencyISO, currencyName) VALUES ('AWG', 'Aruban Florin');
INSERT INTO currency (currencyISO, currencyName) VALUES ('AZN', 'Azerbaijanian Manat');
INSERT INTO currency (currencyISO, currencyName) VALUES ('BAM', 'Convertible Mark');
INSERT INTO currency (currencyISO, currencyName) VALUES ('BBD', 'Barbados Dollar');
INSERT INTO currency (currencyISO, currencyName) VALUES ('BDT', 'Taka');
INSERT INTO currency (currencyISO, currencyName) VALUES ('BGN', 'Bulgarian Lev');
INSERT INTO currency (currencyISO, currencyName) VALUES ('BHD', 'Bahraini Dinar');
INSERT INTO currency (currencyISO, currencyName) VALUES ('BIF', 'Burundi Franc');
INSERT INTO currency (currencyISO, currencyName) VALUES ('BMD', 'Bermudian Dollar');
INSERT INTO currency (currencyISO, currencyName) VALUES ('BND', 'Brunei Dollar');
INSERT INTO currency (currencyISO, currencyName) VALUES ('BOB', 'Boliviano');
INSERT INTO currency (currencyISO, currencyName) VALUES ('BRL', 'Brazilian Real');
INSERT INTO currency (currencyISO, currencyName) VALUES ('BSD', 'Bahamian Dollar');
INSERT INTO currency (currencyISO, currencyName) VALUES ('BTN', 'Ngultrum');
INSERT INTO currency (currencyISO, currencyName) VALUES ('BWP', 'Pula');
INSERT INTO currency (currencyISO, currencyName) VALUES ('BYN', 'Belarussian Ruble');
INSERT INTO currency (currencyISO, currencyName) VALUES ('BZD', 'Belize Dollar');
INSERT INTO currency (currencyISO, currencyName) VALUES ('CAD', 'Canadian Dollar');
INSERT INTO currency (currencyISO, currencyName) VALUES ('CDF', 'Congolese Franc');
INSERT INTO currency (currencyISO, currencyName) VALUES ('CHF', 'Swiss Franc');
INSERT INTO currency (currencyISO, currencyName) VALUES ('CLP', 'Chilean Peso');
INSERT INTO currency (currencyISO, currencyName) VALUES ('CNY', 'Yuan Renminbi');
INSERT INTO currency (currencyISO, currencyName) VALUES ('COP', 'Colombian Peso');
INSERT INTO currency (currencyISO, currencyName) VALUES ('CRC', 'Costa Rican Colon');
INSERT INTO currency (currencyISO, currencyName) VALUES ('CUP', 'Cuban Peso');
INSERT INTO currency (currencyISO, currencyName) VALUES ('CVE', 'Cabo Verde Escudo');
INSERT INTO currency (currencyISO, currencyName) VALUES ('CZK', 'Czech Koruna');
INSERT INTO currency (currencyISO, currencyName) VALUES ('DJF', 'Djibouti Franc');
INSERT INTO currency (currencyISO, currencyName) VALUES ('DKK', 'Danish Krone');
INSERT INTO currency (currencyISO, currencyName) VALUES ('DOP', 'Dominican Peso');
INSERT INTO currency (currencyISO, currencyName) VALUES ('DZD', 'Algerian Dinar');
INSERT INTO currency (currencyISO, currencyName) VALUES ('EGP', 'Egyptian Pound');
INSERT INTO currency (currencyISO, currencyName) VALUES ('ERN', 'Nakfa');
INSERT INTO currency (currencyISO, currencyName) VALUES ('ETB', 'Ethiopian Birr');
INSERT INTO currency (currencyISO, currencyName) VALUES ('EUR', 'Euro');
INSERT INTO currency (currencyISO, currencyName) VALUES ('FJD', 'Fiji Dollar');
INSERT INTO currency (currencyISO, currencyName) VALUES ('GBP', 'Pound Sterling');
INSERT INTO currency (currencyISO, currencyName) VALUES ('GEL', 'Lari');
INSERT INTO currency (currencyISO, currencyName) VALUES ('GHS', 'Ghana Cedi');
INSERT INTO currency (currencyISO, currencyName) VALUES ('GIP', 'Gibraltar Pound');
INSERT INTO currency (currencyISO, currencyName) VALUES ('GMD', 'Dalasi');
INSERT INTO currency (currencyISO, currencyName) VALUES ('GNF', 'Guinea Franc');
INSERT INTO currency (currencyISO, currencyName) VALUES ('GTQ', 'Quetzal');
INSERT INTO currency (currencyISO, currencyName) VALUES ('GYD', 'Guyana Dollar');
INSERT INTO currency (currencyISO, currencyName) VALUES ('HKD', 'Hong Kong Dollar');
INSERT INTO currency (currencyISO, currencyName) VALUES ('HNL', 'Lempira');
INSERT INTO currency (currencyISO, currencyName) VALUES ('HRK', 'Kuna');
INSERT INTO currency (currencyISO, currencyName) VALUES ('HTG', 'Gourde');
INSERT INTO currency (currencyISO, currencyName) VALUES ('HUF', 'Forint');
INSERT INTO currency (currencyISO, currencyName) VALUES ('IDR', 'Rupiah');
INSERT INTO currency (currencyISO, currencyName) VALUES ('ILS', 'New Israeli Sheqel');
INSERT INTO currency (currencyISO, currencyName) VALUES ('INR', 'Indian Rupee');
INSERT INTO currency (currencyISO, currencyName) VALUES ('IQD', 'Iraqi Dinar');
INSERT INTO currency (currencyISO, currencyName) VALUES ('IRR', 'Iranian Rial');
INSERT INTO currency (currencyISO, currencyName) VALUES ('ISK', 'Iceland Krona');
INSERT INTO currency (currencyISO, currencyName) VALUES ('JMD', 'Jamaican Dollar');
INSERT INTO currency (currencyISO, currencyName) VALUES ('JOD', 'Jordanian Dinar');
INSERT INTO currency (currencyISO, currencyName) VALUES ('JPY', 'Yen');
INSERT INTO currency (currencyISO, currencyName) VALUES ('KES', 'Kenyan Shilling');
INSERT INTO currency (currencyISO, currencyName) VALUES ('KGS', 'Som');
INSERT INTO currency (currencyISO, currencyName) VALUES ('KHR', 'Riel');
INSERT INTO currency (currencyISO, currencyName) VALUES ('KMF', 'Comoro Franc');
INSERT INTO currency (currencyISO, currencyName) VALUES ('KPW', 'North Korean Won');
INSERT INTO currency (currencyISO, currencyName) VALUES ('KRW', 'Won');
INSERT INTO currency (currencyISO, currencyName) VALUES ('KWD', 'Kuwaiti Dinar');
INSERT INTO currency (currencyISO, currencyName) VALUES ('KYD', 'Cayman Islands Dollar');
INSERT INTO currency (currencyISO, currencyName) VALUES ('KZT', 'Tenge');
INSERT INTO currency (currencyISO, currencyName) VALUES ('LAK', 'Kip');
INSERT INTO currency (currencyISO, currencyName) VALUES ('LBP', 'Lebanese Pound');
INSERT INTO currency (currencyISO, currencyName) VALUES ('LKR', 'Sri Lanka Rupee');
INSERT INTO currency (currencyISO, currencyName) VALUES ('LRD', 'Liberian Dollar');
INSERT INTO currency (currencyISO, currencyName) VALUES ('LSL', 'Loti');
INSERT INTO currency (currencyISO, currencyName) VALUES ('LYD', 'Libyan Dinar');
INSERT INTO currency (currencyISO, currencyName) VALUES ('MAD', 'Moroccan Dirham');
INSERT INTO currency (currencyISO, currencyName) VALUES ('MDL', 'Moldovan Leu');
INSERT INTO currency (currencyISO, currencyName) VALUES ('MGA', 'Malagasy Ariary');
INSERT INTO currency (currencyISO, currencyName) VALUES ('MKD', 'Denar');
INSERT INTO currency (currencyISO, currencyName) VALUES ('MMK', 'Kyat');
INSERT INTO currency (currencyISO, currencyName) VALUES ('MNT', 'Tugrik');
INSERT INTO currency (currencyISO, currencyName) VALUES ('MOP', 'Pataca');
INSERT INTO currency (currencyISO, currencyName) VALUES ('MRU', 'Ouguiya');
INSERT INTO currency (currencyISO, currencyName) VALUES ('MUR', 'Mauritius Rupee');
INSERT INTO currency (currencyISO, currencyName) VALUES ('MVR', 'Rufiyaa');
INSERT INTO currency (currencyISO, currencyName) VALUES ('MWK', 'Kwacha');
INSERT INTO currency (currencyISO, currencyName) VALUES ('MXN', 'Mexican Peso');
INSERT INTO currency (currencyISO, currencyName) VALUES ('MYR', 'Malaysian Ringgit');
INSERT INTO currency (currencyISO, currencyName) VALUES ('MZN', 'Mozambique Metical');
INSERT INTO currency (currencyISO, currencyName) VALUES ('NAD', 'Namibia Dollar');
INSERT INTO currency (currencyISO, currencyName) VALUES ('NGN', 'Naira');
INSERT INTO currency (currencyISO, currencyName) VALUES ('NIO', 'Cordoba Oro');
INSERT INTO currency (currencyISO, currencyName) VALUES ('NOK', 'Norwegian Krone');
INSERT INTO currency (currencyISO, currencyName) VALUES ('NPR', 'Nepalese Rupee');
INSERT INTO currency (currencyISO, currencyName) VALUES ('NZD', 'New Zealand Dollar');
INSERT INTO currency (currencyISO, currencyName) VALUES ('OMR', 'Rial Omani');
INSERT INTO currency (currencyISO, currencyName) VALUES ('PAB', 'Balboa');
INSERT INTO currency (currencyISO, currencyName) VALUES ('PEN', 'Nuevo Sol');
INSERT INTO currency (currencyISO, currencyName) VALUES ('PGK', 'Kina');
INSERT INTO currency (currencyISO, currencyName) VALUES ('PHP', 'Philippine Peso');
INSERT INTO currency (currencyISO, currencyName) VALUES ('PKR', 'Pakistan Rupee');
INSERT INTO currency (currencyISO, currencyName) VALUES ('PLN', 'Zloty');
INSERT INTO currency (currencyISO, currencyName) VALUES ('PYG', 'Guarani');
INSERT INTO currency (currencyISO, currencyName) VALUES ('QAR', 'Qatari Rial');
INSERT INTO currency (currencyISO, currencyName) VALUES ('RON', 'Romanian Leu');
INSERT INTO currency (currencyISO, currencyName) VALUES ('RSD', 'Serbian Dinar');
INSERT INTO currency (currencyISO, currencyName) VALUES ('RUB', 'Russian Ruble');
INSERT INTO currency (currencyISO, currencyName) VALUES ('RWF', 'Rwanda Franc');
INSERT INTO currency (currencyISO, currencyName) VALUES ('SAR', 'Saudi Riyal');
INSERT INTO currency (currencyISO, currencyName) VALUES ('SBD', 'Solomon Islands Dollar');
INSERT INTO currency (currencyISO, currencyName) VALUES ('SCR', 'Seychelles Rupee');
INSERT INTO currency (currencyISO, currencyName) VALUES ('SDG', 'Sudanese Pound');
INSERT INTO currency (currencyISO, currencyName) VALUES ('SEK', 'Swedish Krona');
INSERT INTO currency (currencyISO, currencyName) VALUES ('SGD', 'Singapore Dollar');
INSERT INTO currency (currencyISO, currencyName) VALUES ('SLE', 'Leone');
INSERT INTO currency (currencyISO, currencyName) VALUES ('SOS', 'Somali Shilling');
INSERT INTO currency (currencyISO, currencyName) VALUES ('SRD', 'Surinam Dollar');
INSERT INTO currency (currencyISO, currencyName) VALUES ('SSP', 'South Sudanese Pound');
INSERT INTO currency (currencyISO, currencyName) VALUES ('STN', 'Dobra');
INSERT INTO currency (currencyISO, currencyName) VALUES ('SVC', 'El Salvador Colon');
INSERT INTO currency (currencyISO, currencyName) VALUES ('SYP', 'Syrian Pound');
INSERT INTO currency (currencyISO, currencyName) VALUES ('SZL', 'Lilangeni');
INSERT INTO currency (currencyISO, currencyName) VALUES ('THB', 'Baht');
INSERT INTO currency (currencyISO, currencyName) VALUES ('TJS', 'Somoni');
INSERT INTO currency (currencyISO, currencyName) VALUES ('TMT', 'Turkmenistan New Manat');
INSERT INTO currency (currencyISO, currencyName) VALUES ('TND', 'Tunisian Dinar');
INSERT INTO currency (currencyISO, currencyName) VALUES ('TOP', 'Pa’anga');
INSERT INTO currency (currencyISO, currencyName) VALUES ('TRY', 'Turkish Lira');
INSERT INTO currency (currencyISO, currencyName) VALUES ('TTD', 'Trinidad and Tobago Dollar');
INSERT INTO currency (currencyISO, currencyName) VALUES ('TWD', 'New Taiwan Dollar');
INSERT INTO currency (currencyISO, currencyName) VALUES ('TZS', 'Tanzanian Shilling');
INSERT INTO currency (currencyISO, currencyName) VALUES ('UAH', 'Hryvnia');
INSERT INTO currency (currencyISO, currencyName) VALUES ('UGX', 'Uganda Shilling');
INSERT INTO currency (currencyISO, currencyName) VALUES ('USD', 'US Dollar');
INSERT INTO currency (currencyISO, currencyName) VALUES ('UYU', 'Peso Uruguayo');
INSERT INTO currency (currencyISO, currencyName) VALUES ('UZS', 'Uzbekistan Sum');
INSERT INTO currency (currencyISO, currencyName) VALUES ('VEF', 'Bolivar');
INSERT INTO currency (currencyISO, currencyName) VALUES ('VND', 'Dong');
INSERT INTO currency (currencyISO, currencyName) VALUES ('VUV', 'Vatu');
INSERT INTO currency (currencyISO, currencyName) VALUES ('WST', 'Tala');
INSERT INTO currency (currencyISO, currencyName) VALUES ('XAF', 'CFA Franc BEAC');
INSERT INTO currency (currencyISO, currencyName) VALUES ('XCD', 'East Caribbean Dollar');
INSERT INTO currency (currencyISO, currencyName) VALUES ('XOF', 'CFA Franc BCEAO');
INSERT INTO currency (currencyISO, currencyName) VALUES ('XPF', 'CFP Franc');
INSERT INTO currency (currencyISO, currencyName) VALUES ('YER', 'Yemeni Rial');
INSERT INTO currency (currencyISO, currencyName) VALUES ('ZAR', 'Rand');
INSERT INTO currency (currencyISO, currencyName) VALUES ('ZMW', 'Zambian Kwacha');
INSERT INTO currency (currencyISO, currencyName) VALUES ('ZWL', 'Zimbabwe Dollar');
