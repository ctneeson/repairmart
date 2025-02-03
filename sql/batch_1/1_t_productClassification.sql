USE RepairMart
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'productClassification' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[productClassification];
GO

CREATE TABLE productClassification (
 productClassificationId bigint NOT NULL PRIMARY KEY IDENTITY(1,1),
 category nvarchar(150) NOT NULL,
 subcategory nvarchar(150) NOT NULL,
 subcategoryOrder INT NOT NULL,
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 ACTIVE BIT NOT NULL DEFAULT 1
);

INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Arts, Crafts & Sewing', 'Printing Presses & Accessories', 1);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Arts, Crafts & Sewing', 'Sewing Machines', 2);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Arts, Crafts & Sewing', 'Other-Misc.', 3);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Audio-Visual', 'Audio Headphones & Accessories', 1);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Audio-Visual', 'Blu-ray Players & Recorders', 2);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Audio-Visual', 'Cassette Players & Recorders', 3);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Audio-Visual', 'CB & Two-Way Radios', 4);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Audio-Visual', 'CD Players', 5);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Audio-Visual', 'Compact Radios & Stereos', 6);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Audio-Visual', 'Digital Voice Recorders', 7);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Audio-Visual', 'DVD Players & Recorders', 8);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Audio-Visual', 'Home Theater Systems', 9);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Audio-Visual', 'MP3 & MP4 Players', 10);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Audio-Visual', 'Radios', 11);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Audio-Visual', 'Satellite Television Products', 12);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Audio-Visual', 'Speakers & Audio Systems', 13);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Audio-Visual', 'Streaming Media Players', 14);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Audio-Visual', 'Televisions', 15);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Audio-Visual', 'Turntables & Accessories', 16);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Audio-Visual', 'TV-DVD Combinations', 17);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Audio-Visual', 'VCRs', 18);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Audio-Visual', 'Video Projectors', 19);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Audio-Visual', 'Other-Misc.', 20);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Beauty & Personal Care', 'Personal Care Products', 1);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Beauty & Personal Care', 'Other-Misc.', 2);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Camera & Photo', 'Camera & Photo Accessories', 1);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Camera & Photo', 'Digital Cameras', 2);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Camera & Photo', 'Film Cameras', 3);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Camera & Photo', 'Photo Printers & Scanners', 4);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Camera & Photo', 'Quadcopters & Accessories', 5);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Camera & Photo', 'Video Cameras', 6);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Camera & Photo', 'Video Surveillance Equipment', 7);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Camera & Photo', 'Other-Misc.', 8);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Cell Phones & Accessories', 'Cell Phone Accessories', 1);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Cell Phones & Accessories', 'Cell Phones', 2);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Cell Phones & Accessories', 'Other-Misc.', 3);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Computers & Accessories', 'Computer Audio Devices', 1);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Computers & Accessories', 'Computer Game Hardware', 2);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Computers & Accessories', 'Computer Keyboards, Mice & Accessories', 3);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Computers & Accessories', 'Computer Monitors', 4);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Computers & Accessories', 'Computer Servers', 5);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Computers & Accessories', 'Computer Tablets', 6);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Computers & Accessories', 'Data Storage', 7);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Computers & Accessories', 'Desktop Computers', 8);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Computers & Accessories', 'Laptop Computers', 9);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Computers & Accessories', 'USB Gadgets', 10);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Computers & Accessories', 'Webcams', 11);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Computers & Accessories', 'Other-Misc.', 12);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('eBook Readers & Accessories', 'eBook Readers', 1);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('eBook Readers & Accessories', 'Other-Misc.', 2);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Heating, Cooling & Air Quality', 'Dehumidifiers', 1);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Heating, Cooling & Air Quality', 'Home Air Purifiers', 2);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Heating, Cooling & Air Quality', 'Household Fans', 3);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Heating, Cooling & Air Quality', 'Humidifiers', 4);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Heating, Cooling & Air Quality', 'Indoor Space Heaters', 5);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Heating, Cooling & Air Quality', 'Room Air Conditioners', 6);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Heating, Cooling & Air Quality', 'Other-Misc.', 7);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Home Electronics', 'Dishwashers', 1);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Home Electronics', 'Doorbells', 2);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Home Electronics', 'Electric Cookers', 3);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Home Electronics', 'Home Automation Devices', 4);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Home Electronics', 'Ironing Products', 5);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Home Electronics', 'Laundry Appliances', 6);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Home Electronics', 'Refrigerators, Freezers & Ice Makers', 7);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Home Electronics', 'Room Air Conditioners & Accessories', 8);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Home Electronics', 'Safety & Security Devices', 9);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Home Electronics', 'Vacuum Cleaners & Steam Cleaners', 10);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Home Electronics', 'Other-Misc.', 11);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Industrial & Scientific', '3D Printers', 1);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Industrial & Scientific', '3D Scanners', 2);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Industrial & Scientific', 'Cutting Tools', 3);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Industrial & Scientific', 'Digital Signage Equipment', 4);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Industrial & Scientific', 'Electronic Components', 5);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Industrial & Scientific', 'Filtration', 6);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Industrial & Scientific', 'Food Service Equipment & Supplies', 7);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Industrial & Scientific', 'Hydraulics, Pneumatics & Plumbing', 8);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Industrial & Scientific', 'Industrial Power & Hand Tools', 9);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Industrial & Scientific', 'Lab Instruments & Equipment', 10);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Industrial & Scientific', 'Occupational Health & Safety Products', 11);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Industrial & Scientific', 'Security & Surveillance Equipment', 12);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Industrial & Scientific', 'Testing, Measurement & Inspection Devices', 13);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Industrial & Scientific', 'Other-Misc.', 14);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Kitchen Appliances', 'Coffee, Tea & Espresso', 1);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Kitchen Appliances', 'Electric Knives', 2);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Kitchen Appliances', 'Kitchen Small Appliances', 3);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Kitchen Appliances', 'Kitchen Utensils & Gadgets', 4);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Kitchen Appliances', 'Other-Misc.', 5);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Musical Instruments', 'Electronic Drums', 1);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Musical Instruments', 'Electronic Music, DJ & Karaoke', 2);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Musical Instruments', 'Music Recording Equipment', 3);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Musical Instruments', 'Musical Instrument Accessories', 4);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Musical Instruments', 'Musical Instrument Amplifiers & Effects', 5);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Musical Instruments', 'Musical Instrument Keyboards & MIDI', 6);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Musical Instruments', 'Recording Microphones & Accessories', 7);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Musical Instruments', 'Stage & Sound Equipment', 8);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Musical Instruments', 'Other-Misc.', 9);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Office Electronics', 'Fax Machines', 1);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Office Electronics', 'Point-of-Sale (POS) Equipment', 2);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Office Electronics', 'Printers, Scanners, Copiers', 3);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Office Electronics', 'Telephones', 4);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Office Electronics', 'Video Projectors & Accessories', 5);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Office Electronics', 'Other-Misc.', 6);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Patio, Lawn & Garden', 'Outdoor Kitchen Appliances', 1);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Patio, Lawn & Garden', 'Outdoor Power & Lawn Equipment', 2);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Patio, Lawn & Garden', 'Other-Misc.', 3);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Robotics', 'Unmanned Aerial Vehicles (UAVs)', 1);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Robotics', 'Other-Misc.', 2);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Sports & Outdoors', 'Camping & Hiking Equipment', 1);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Sports & Outdoors', 'Cycling Equipment', 2);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Sports & Outdoors', 'Exercise & Fitness Equipment', 3);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Sports & Outdoors', 'Golf Accessories', 4);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Sports & Outdoors', 'Hunting & Fishing', 5);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Sports & Outdoors', 'Leisure & Games Equipment', 6);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Sports & Outdoors', 'Other Sports Types', 7);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Sports & Outdoors', 'Outdoor Recreation Accessories', 8);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Sports & Outdoors', 'Sports Accessories', 9);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Sports & Outdoors', 'Team Sports Equipment', 10);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Sports & Outdoors', 'Water Sports', 11);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Sports & Outdoors', 'Winter Sports Equipment', 12);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Sports & Outdoors', 'Other-Misc.', 13);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Tools', 'Electrical Tools & Hardware', 1);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Tools', 'Power Tools', 2);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Tools', 'Other-Misc.', 3);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Toys & Games', 'Electronic Toys', 1);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Toys & Games', 'Remote & App Controlled Vehicles & Parts', 2);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Toys & Games', 'Video Game Consoles & Accessories', 3);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Toys & Games', 'Other-Misc.', 4);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Vehicle Electronics', 'Car Audio & Video Accessories', 1);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Vehicle Electronics', 'Car Electronics', 2);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Vehicle Electronics', 'Marine Electronics', 3);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Vehicle Electronics', 'Vehicle GPS Units & Equipment', 4);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Vehicle Electronics', 'Other-Misc.', 5);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Wearable Technology', 'Smart Glasses', 1);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Wearable Technology', 'Smartwatches & Smart Rings', 2);
INSERT INTO productClassification (category, subCategory, subcategoryOrder) VALUES ('Wearable Technology', 'Other-Misc.', 3);
