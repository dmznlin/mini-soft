drop table if exists erp_event;
CREATE TABLE `erp_event`
(
    `r_id`       BIGINT(20) NOT NULL AUTO_INCREMENT,
    `e_table`    VARCHAR(32)   NOT NULL DEFAULT '0' COMMENT '表名称',
    `e_record`   BIGINT(20) NOT NULL DEFAULT '0' COMMENT '记录号',
    `e_wxid`     VARCHAR(50)   NOT NULL DEFAULT '0' COMMENT '接收人(或群号)微信ID',
    `e_at`       VARCHAR(50) NULL DEFAULT NULL COMMENT '需@ID列表,字段 或 $wxid,逗号分割',
    `e_template` VARCHAR(255)  NOT NULL DEFAULT '0' COMMENT '消息模板文件，可选 $path 变量',
    `e_fields`   VARCHAR(2000) NOT NULL DEFAULT '0' COMMENT '字段列表,逗号分割',
    `e_valid`    TINYINT(1) NOT NULL DEFAULT '1' COMMENT '1,未处理;其它,已处理',
    PRIMARY KEY (`r_id`),
    INDEX        `e_valid` (`e_valid`)
) COMMENT='erp数据变更'
COLLATE='utf8_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=4
;


drop trigger if exists table_d6_after_insert;
CREATE TRIGGER `table_d6_after_insert`
    AFTER INSERT
    ON `table_d6`
    FOR EACH ROW
begin
    Insert INTO erp_event(e_table, e_record, e_wxid, e_at, e_template, e_fields)
    VALUES ("table_d6", new.record_id, "Younger", "接待人,$Younger", "$path/temp/gate.txt", "日期,来访人");
END

