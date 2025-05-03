CREATE TABLE IF NOT EXISTS ghst_vip_users (
    identifier VARCHAR(50) PRIMARY KEY,
    vip_package VARCHAR(20),
    expire_date BIGINT,
    ghstcoins INT DEFAULT 0
);
