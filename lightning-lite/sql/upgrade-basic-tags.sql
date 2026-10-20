-- 标签基础能力升级（MySQL 8，可重复执行）。先备份，再在应用升级前执行。
-- 不合并或删除已有标签；发现空名称、重名时中止，请先人工整理数据。
DELIMITER $$
DROP PROCEDURE IF EXISTS upgrade_basic_tags$$
CREATE PROCEDURE upgrade_basic_tags()
BEGIN
    IF EXISTS (SELECT 1 FROM tag_detail WHERE tag_name IS NULL OR CHAR_LENGTH(TRIM(tag_name)) = 0) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Empty tag names exist; correct them before upgrading';
    END IF;
    IF EXISTS (SELECT TRIM(tag_name) FROM tag_detail GROUP BY TRIM(tag_name) HAVING COUNT(*) > 1) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Duplicate tag names exist; correct them before upgrading';
    END IF;
    UPDATE tag_detail SET tag_name = TRIM(tag_name);
    ALTER TABLE tag_detail MODIFY tag_name varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '标签名称';
    IF NOT EXISTS (SELECT 1 FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'tag_detail' AND index_name = 'uk_tag_detail_name') THEN
        ALTER TABLE tag_detail ADD UNIQUE KEY uk_tag_detail_name (tag_name);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'product_tag' AND index_name = 'idx_product_tag_tag_id') THEN
        ALTER TABLE product_tag ADD KEY idx_product_tag_tag_id (tag_id, product_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'device_tag' AND index_name = 'idx_device_tag_tag_id') THEN
        ALTER TABLE device_tag ADD KEY idx_device_tag_tag_id (tag_id, device_id);
    END IF;
END$$
CALL upgrade_basic_tags()$$
DROP PROCEDURE upgrade_basic_tags$$
DELIMITER ;
