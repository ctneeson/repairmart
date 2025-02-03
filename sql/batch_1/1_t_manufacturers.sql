USE RepairMart
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'manufacturers' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[manufacturers];
GO

CREATE TABLE manufacturers (
 manufacturerId bigint NOT NULL PRIMARY KEY IDENTITY(1,1),
 manufacturerName nvarchar(150) NOT NULL UNIQUE,
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 ACTIVE BIT NOT NULL DEFAULT 1
);

INSERT INTO manufacturers (manufacturerName) VALUES ('3M');
INSERT INTO manufacturers (manufacturerName) VALUES ('Acer');
INSERT INTO manufacturers (manufacturerName) VALUES ('Aiwa');
INSERT INTO manufacturers (manufacturerName) VALUES ('Akai');
INSERT INTO manufacturers (manufacturerName) VALUES ('Alba');
INSERT INTO manufacturers (manufacturerName) VALUES ('Alcatel');
INSERT INTO manufacturers (manufacturerName) VALUES ('Amazon');
INSERT INTO manufacturers (manufacturerName) VALUES ('AMD');
INSERT INTO manufacturers (manufacturerName) VALUES ('Amstrad');
INSERT INTO manufacturers (manufacturerName) VALUES ('AOC');
INSERT INTO manufacturers (manufacturerName) VALUES ('Apple');
INSERT INTO manufacturers (manufacturerName) VALUES ('Asus');
INSERT INTO manufacturers (manufacturerName) VALUES ('Atari');
INSERT INTO manufacturers (manufacturerName) VALUES ('Avaya');
INSERT INTO manufacturers (manufacturerName) VALUES ('Beko');
INSERT INTO manufacturers (manufacturerName) VALUES ('BenQ');
INSERT INTO manufacturers (manufacturerName) VALUES ('Binatone');
INSERT INTO manufacturers (manufacturerName) VALUES ('Blaupunkt');
INSERT INTO manufacturers (manufacturerName) VALUES ('Bosch');
INSERT INTO manufacturers (manufacturerName) VALUES ('Bose');
INSERT INTO manufacturers (manufacturerName) VALUES ('Braun');
INSERT INTO manufacturers (manufacturerName) VALUES ('BT');
INSERT INTO manufacturers (manufacturerName) VALUES ('Bush');
INSERT INTO manufacturers (manufacturerName) VALUES ('BYD Electronic');
INSERT INTO manufacturers (manufacturerName) VALUES ('Canon');
INSERT INTO manufacturers (manufacturerName) VALUES ('Casio');
INSERT INTO manufacturers (manufacturerName) VALUES ('Cisco');
INSERT INTO manufacturers (manufacturerName) VALUES ('Clarion');
INSERT INTO manufacturers (manufacturerName) VALUES ('Daewoo');
INSERT INTO manufacturers (manufacturerName) VALUES ('Dell');
INSERT INTO manufacturers (manufacturerName) VALUES ('D-Link');
INSERT INTO manufacturers (manufacturerName) VALUES ('Dynalite');
INSERT INTO manufacturers (manufacturerName) VALUES ('Dyson');
INSERT INTO manufacturers (manufacturerName) VALUES ('Electrolux');
INSERT INTO manufacturers (manufacturerName) VALUES ('Epson');
INSERT INTO manufacturers (manufacturerName) VALUES ('Ericcson');
INSERT INTO manufacturers (manufacturerName) VALUES ('Fitbit');
INSERT INTO manufacturers (manufacturerName) VALUES ('Fujifilm');
INSERT INTO manufacturers (manufacturerName) VALUES ('Fujitsu');
INSERT INTO manufacturers (manufacturerName) VALUES ('Gateway');
INSERT INTO manufacturers (manufacturerName) VALUES ('Gionee');
INSERT INTO manufacturers (manufacturerName) VALUES ('Google');
INSERT INTO manufacturers (manufacturerName) VALUES ('Grundig');
INSERT INTO manufacturers (manufacturerName) VALUES ('Hewlett-Packard');
INSERT INTO manufacturers (manufacturerName) VALUES ('Hisense');
INSERT INTO manufacturers (manufacturerName) VALUES ('Hitachi');
INSERT INTO manufacturers (manufacturerName) VALUES ('HP');
INSERT INTO manufacturers (manufacturerName) VALUES ('HTC');
INSERT INTO manufacturers (manufacturerName) VALUES ('Huawei');
INSERT INTO manufacturers (manufacturerName) VALUES ('Husqvarna');
INSERT INTO manufacturers (manufacturerName) VALUES ('Hyundai');
INSERT INTO manufacturers (manufacturerName) VALUES ('IBM');
INSERT INTO manufacturers (manufacturerName) VALUES ('Intel');
INSERT INTO manufacturers (manufacturerName) VALUES ('JBL');
INSERT INTO manufacturers (manufacturerName) VALUES ('JVC');
INSERT INTO manufacturers (manufacturerName) VALUES ('Kenwood');
INSERT INTO manufacturers (manufacturerName) VALUES ('Kingston');
INSERT INTO manufacturers (manufacturerName) VALUES ('Konica Minolta');
INSERT INTO manufacturers (manufacturerName) VALUES ('Kyocera');
INSERT INTO manufacturers (manufacturerName) VALUES ('Lenovo');
INSERT INTO manufacturers (manufacturerName) VALUES ('LG');
INSERT INTO manufacturers (manufacturerName) VALUES ('Marconi');
INSERT INTO manufacturers (manufacturerName) VALUES ('Marshall');
INSERT INTO manufacturers (manufacturerName) VALUES ('MediaTek');
INSERT INTO manufacturers (manufacturerName) VALUES ('Micron');
INSERT INTO manufacturers (manufacturerName) VALUES ('Microsoft');
INSERT INTO manufacturers (manufacturerName) VALUES ('Miele');
INSERT INTO manufacturers (manufacturerName) VALUES ('Mitsubishi');
INSERT INTO manufacturers (manufacturerName) VALUES ('Morphy Richards');
INSERT INTO manufacturers (manufacturerName) VALUES ('Motorola');
INSERT INTO manufacturers (manufacturerName) VALUES ('NEC');
INSERT INTO manufacturers (manufacturerName) VALUES ('Nikon');
INSERT INTO manufacturers (manufacturerName) VALUES ('Nintendo');
INSERT INTO manufacturers (manufacturerName) VALUES ('Nokia');
INSERT INTO manufacturers (manufacturerName) VALUES ('Nvidia');
INSERT INTO manufacturers (manufacturerName) VALUES ('Olivetti');
INSERT INTO manufacturers (manufacturerName) VALUES ('Olympus');
INSERT INTO manufacturers (manufacturerName) VALUES ('OnePlus');
INSERT INTO manufacturers (manufacturerName) VALUES ('Oppo');
INSERT INTO manufacturers (manufacturerName) VALUES ('Packard Bell');
INSERT INTO manufacturers (manufacturerName) VALUES ('Panasonic');
INSERT INTO manufacturers (manufacturerName) VALUES ('Pentax');
INSERT INTO manufacturers (manufacturerName) VALUES ('Philips');
INSERT INTO manufacturers (manufacturerName) VALUES ('Pioneer');
INSERT INTO manufacturers (manufacturerName) VALUES ('Plantronics');
INSERT INTO manufacturers (manufacturerName) VALUES ('Polycom');
INSERT INTO manufacturers (manufacturerName) VALUES ('Pye');
INSERT INTO manufacturers (manufacturerName) VALUES ('Qualcomm');
INSERT INTO manufacturers (manufacturerName) VALUES ('RCA');
INSERT INTO manufacturers (manufacturerName) VALUES ('Realtek');
INSERT INTO manufacturers (manufacturerName) VALUES ('Ricoh');
INSERT INTO manufacturers (manufacturerName) VALUES ('Russell Hobbs');
INSERT INTO manufacturers (manufacturerName) VALUES ('Samsung');
INSERT INTO manufacturers (manufacturerName) VALUES ('Sandisk');
INSERT INTO manufacturers (manufacturerName) VALUES ('Sanyo');
INSERT INTO manufacturers (manufacturerName) VALUES ('Seagate');
INSERT INTO manufacturers (manufacturerName) VALUES ('Sega');
INSERT INTO manufacturers (manufacturerName) VALUES ('Sennheiser');
INSERT INTO manufacturers (manufacturerName) VALUES ('Severin');
INSERT INTO manufacturers (manufacturerName) VALUES ('Sharp');
INSERT INTO manufacturers (manufacturerName) VALUES ('Siemens');
INSERT INTO manufacturers (manufacturerName) VALUES ('Sonos');
INSERT INTO manufacturers (manufacturerName) VALUES ('Sony');
INSERT INTO manufacturers (manufacturerName) VALUES ('TDK');
INSERT INTO manufacturers (manufacturerName) VALUES ('Telefunken');
INSERT INTO manufacturers (manufacturerName) VALUES ('Texas Instruments');
INSERT INTO manufacturers (manufacturerName) VALUES ('Thomson');
INSERT INTO manufacturers (manufacturerName) VALUES ('Thorn');
INSERT INTO manufacturers (manufacturerName) VALUES ('Toshiba');
INSERT INTO manufacturers (manufacturerName) VALUES ('TP-Link/intex');
INSERT INTO manufacturers (manufacturerName) VALUES ('Unisys');
INSERT INTO manufacturers (manufacturerName) VALUES ('Viewsonic');
INSERT INTO manufacturers (manufacturerName) VALUES ('Western Digital');
INSERT INTO manufacturers (manufacturerName) VALUES ('Wipro');
INSERT INTO manufacturers (manufacturerName) VALUES ('Wortmann');
INSERT INTO manufacturers (manufacturerName) VALUES ('Xerox');
INSERT INTO manufacturers (manufacturerName) VALUES ('Xiaomi');
INSERT INTO manufacturers (manufacturerName) VALUES ('ZTE');
