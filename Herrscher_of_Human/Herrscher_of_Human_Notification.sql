INSERT INTO Types 
(Type,										Kind) VALUES
('NOTIFICATION_HOH',				'KIND_NOTIFICATION');


INSERT INTO Notifications
(NotificationType,							SeverityType,	ExpiresEndOfTurn,	AutoNotify,	AutoActivate,	ShowIconSinglePlayer,	GroupType) VALUES
('NOTIFICATION_HOH',				'VERY_HIGH',	0,					0,			1,				1,						'USER');

