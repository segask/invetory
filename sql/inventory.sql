-- Таблица для инвентаря пользователей
CREATE TABLE IF NOT EXISTS `user_inventory` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `identifier` varchar(50) NOT NULL,
    `item` varchar(50) NOT NULL,
    `count` int(11) NOT NULL DEFAULT 1,
    `slot` int(11) NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `unique_inventory` (`identifier`, `item`, `slot`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;