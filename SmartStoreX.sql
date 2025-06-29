create table if not exists feedback
(
    id          int auto_increment comment '主键ID，唯一标识每条反馈记录'
        constraint `PRIMARY`
        primary key,
    category    varchar(50)                        not null comment '建议分类（如功能建议、界面优化等）',
    content     text                               not null comment '用户填写的建议内容',
    image_urls  json                               null comment '图片URL列表（JSON数组）',
    qq          varchar(20)                        null comment '用户提供的QQ号（可选）',
    wechat      varchar(50)                        null comment '用户提供的微信号（可选）',
    phone       varchar(20)                        null comment '用户提供的手机号（可选）',
    email       varchar(50)                        null comment '用户提供的电子邮箱（可选）',
    create_time datetime default CURRENT_TIMESTAMP null comment '反馈提交时间'
)
    comment '用户反馈信息表';

create table if not exists imagetype
(
    image_type_id   int auto_increment comment '图片类型ID，主键，自增'
        constraint `PRIMARY`
        primary key,
    image_type_name varchar(255) not null comment '图片类型名称（如店铺封面、菜单等）',
    constraint image_type_name
        unique (image_type_name)
)
    comment '图片类型表';

create table if not exists media_file
(
    id                bigint auto_increment comment '主键ID，自增'
        constraint `PRIMARY`
        primary key,
    user_id           bigint                               not null comment '上传用户ID（管理员/商家/普通用户）',
    file_url          varchar(500)                         not null comment 'OSS访问URL地址',
    file_type         varchar(50)                          null comment '文件用途类型（如：coverImage, productImage, feedbackImage）',
    bound_object_type varchar(50)                          null comment '绑定的业务模块类型（如 store、ad、feedback）',
    bound_object_id   bigint                               null comment '绑定的业务对象主键ID（如 store.id / ad.id / feedback.id）',
    is_temp           tinyint(1) default 1                 not null comment '是否为临时文件（未绑定为 true，绑定后为 false）',
    created_time      datetime   default CURRENT_TIMESTAMP not null comment '文件上传时间',
    file_name         varchar(255)                         null comment '原始上传文件名（用于展示或下载）',
    file_size         bigint                               null comment '文件大小（单位 Byte，支持上传大小限制、统计）',
    mime_type         varchar(100)                         null comment '文件 MIME 类型（如 image/jpeg、image/png）'
)
    comment '媒体资源文件表：统一管理上传文件及其与业务对象的绑定关系';

create table if not exists school
(
    school_id   int auto_increment comment '学校ID，主键，自增'
        constraint `PRIMARY`
        primary key,
    school_name varchar(255) not null comment '学校名称，唯一约束',
    constraint school_name
        unique (school_name)
)
    comment '学校信息表';

create table if not exists campusstore
(
    store_id         int auto_increment comment '店铺ID，主键，自增'
        constraint `PRIMARY`
        primary key,
    store_name       varchar(255)                         not null comment '店铺名称',
    store_address    varchar(255)                         null comment '店铺大致地址（如校内区域：东区食堂3楼）',
    specific_address varchar(255)                         null comment '店铺具体地址（如详细位置：东区食堂3楼A区302室）',
    store_hours      json                                 null comment '店铺营业时间（JSON格式）',
    store_image      varchar(1024)                        null comment '店铺封面图片URL',
    store_text_info  text                                 null comment '店铺文字信息',
    store_school_id  int                                  null comment '所属学校ID，关联School表',
    create_time      timestamp  default CURRENT_TIMESTAMP not null comment '创建时间',
    update_time      timestamp  default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '最近更新时间',
    store_sort       varchar(255)                         null,
    online_order     tinyint(1) default 0                 null comment '0 代表不支持线上点单，1 代表支持线上点单',
    constraint campusstore_ibfk_2
        foreign key (store_school_id) references school (school_id)
            on delete cascade
)
    comment '校内店铺信息表';

create index idx_store_school_id
    on campusstore (store_school_id);

create table if not exists store_ad_banner
(
    id          int auto_increment comment '主键ID'
        constraint `PRIMARY`
        primary key,
    image_url   varchar(1024)                        not null comment '广告图片URL地址',
    store_id    int                                  not null comment '对应店铺ID',
    school_id   int                                  not null comment '所属学校ID',
    is_active   tinyint(1) default 1                 null comment '是否启用（1=启用，0=禁用）',
    create_time timestamp  default CURRENT_TIMESTAMP null comment '创建时间',
    update_time timestamp  default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP comment '更新时间',
    priority    int        default 0                 null comment '广告优先级（数值越大越优先）',
    constraint fk_school
        foreign key (school_id) references school (school_id)
            on delete cascade,
    constraint fk_store
        foreign key (store_id) references campusstore (store_id)
            on delete cascade
)
    comment '店铺广告图表（首页轮播或推荐广告）';

create table if not exists storeactivity
(
    activity_id          int auto_increment comment '活动ID，主键，自增'
        constraint `PRIMARY`
        primary key,
    store_id             int                                  null comment '所属店铺ID，关联CampusStore表',
    activity_name        varchar(255)                         not null comment '活动名称',
    activity_banner      varchar(1024)                        null comment '活动宣传图片URL',
    activity_start_time  datetime                             null comment '活动开始时间',
    activity_end_time    datetime                             null comment '活动结束时间',
    activity_description text                                 null comment '活动具体内容（文字描述）',
    create_time          timestamp  default CURRENT_TIMESTAMP null,
    update_time          timestamp  default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    is_active            tinyint(1) default 1                 null comment '是否展示活动：0-不展示，1-展示',
    constraint storeactivity_ibfk_1
        foreign key (store_id) references campusstore (store_id)
            on delete cascade
)
    comment '店铺活动信息表';

create index store_id
    on storeactivity (store_id);

create table if not exists storecategory
(
    category_id   int auto_increment comment '分类ID，主键，自增'
        constraint `PRIMARY`
        primary key,
    category_name varchar(255) not null comment '分类名称，唯一约束',
    constraint category_name
        unique (category_name)
)
    comment '店铺分类表';

create table if not exists storecategoryrelation
(
    id          int auto_increment comment '关联表ID，主键，自增'
        constraint `PRIMARY`
        primary key,
    store_id    int null comment '店铺ID，关联CampusStore表',
    category_id int null comment '店铺分类ID，关联StoreCategory表',
    constraint storecategoryrelation_ibfk_1
        foreign key (store_id) references campusstore (store_id)
            on delete cascade,
    constraint storecategoryrelation_ibfk_2
        foreign key (category_id) references storecategory (category_id)
            on delete cascade
)
    comment '店铺与店铺分类关联表';

create index category_id
    on storecategoryrelation (category_id);

create index idx_store_category
    on storecategoryrelation (store_id, category_id);

create table if not exists storeimages
(
    image_id      int auto_increment comment '图片ID，主键，自增'
        constraint `PRIMARY`
        primary key,
    store_id      int           null comment '店铺ID，关联CampusStore表',
    image_url     varchar(1024) not null comment '图片URL',
    image_type_id int           null comment '图片类型ID，关联ImageType表',
    constraint storeimages_ibfk_1
        foreign key (store_id) references campusstore (store_id)
            on delete cascade,
    constraint storeimages_ibfk_2
        foreign key (image_type_id) references imagetype (image_type_id)
            on delete set null
)
    comment '店铺图片信息表';

create index idx_store_image_type
    on storeimages (store_id, image_type_id);

create index image_type_id
    on storeimages (image_type_id);

create table if not exists user
(
    user_id        int auto_increment comment '用户ID，主键，自增'
        constraint `PRIMARY`
        primary key,
    create_time    datetime               default CURRENT_TIMESTAMP null comment '注册时间',
    user_school_id int                                              null comment '用户所属学校ID，关联School表',
    role           enum ('USER', 'ADMIN') default 'USER'            null comment '用户角色：USER 普通用户，ADMIN 管理员',
    openid         varchar(64)                                      not null comment '微信 openid，唯一标识',
    nick_name      varchar(64)                                      null comment '用户微信昵称',
    avatar_url     text                                             null comment '用户微信头像链接',
    constraint openid
        unique (openid),
    constraint user_ibfk_1
        foreign key (user_school_id) references school (school_id)
            on delete cascade
)
    comment '用户信息表（支持微信登录 + 角色 + 学校绑定）';

create index user_school_id
    on user (user_school_id);

create table if not exists userfavorites
(
    user_id     int                                 not null comment '用户ID',
    store_id    int                                 not null comment '店铺ID',
    sort        int       default 0                 null comment '排序权重，越大越靠前',
    create_time timestamp default CURRENT_TIMESTAMP null comment '收藏时间',
    constraint `PRIMARY`
        primary key (user_id, store_id),
    constraint userfavorites_ibfk_1
        foreign key (user_id) references user (user_id)
            on delete cascade,
    constraint userfavorites_ibfk_2
        foreign key (store_id) references campusstore (store_id)
            on delete cascade
)
    comment '用户收藏信息表';

create index store_id
    on userfavorites (store_id);

create table if not exists userloginlog
(
    log_id     int auto_increment comment '日志ID，主键，自增'
        constraint `PRIMARY`
        primary key,
    user_id    int                                 not null comment '用户ID，关联User表',
    login_time timestamp default CURRENT_TIMESTAMP null comment '登录时间，精确到秒',
    login_ip   varbinary(16)                       null comment '登录的 IP 地址',
    constraint userloginlog_ibfk_1
        foreign key (user_id) references user (user_id)
            on delete cascade
)
    comment '用户登录日志表';

create index user_id
    on userloginlog (user_id);

create table if not exists usermenu
(
    user_id     int                                 not null comment '用户ID',
    store_id    int                                 not null comment '店铺ID',
    sort        int       default 0                 null comment '排序权重，越大越靠前',
    create_time timestamp default CURRENT_TIMESTAMP null comment '收藏时间',
    constraint `PRIMARY`
        primary key (user_id, store_id),
    constraint usermenu_ibfk_1
        foreign key (user_id) references user (user_id)
            on delete cascade,
    constraint usermenu_ibfk_2
        foreign key (store_id) references campusstore (store_id)
            on delete cascade
)
    comment '用户偏好信息表';

create index store_id
    on usermenu (store_id);

create procedure InsertCampusStores()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 50 DO
        INSERT INTO CampusStore (store_name, store_address, specific_address, store_hours, store_image, store_text_info, store_school_id)
        VALUES (
            CONCAT('测试店铺', i),
            '测试地址',
            '详细地址',
            '{"Mon-Sun": "08:00-22:00"}',
            CONCAT('https://picsum.photos/500/300?random=', i),
            '测试店铺介绍',
            1
        );
        SET i = i + 1;
    END WHILE;
END;

create procedure InsertStoreImages()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 50 DO
        IF EXISTS (SELECT 1 FROM CampusStore WHERE store_id = i) THEN
            INSERT INTO StoreImages (store_id, image_url, image_type_id)
            VALUES (i, CONCAT('https://picsum.photos/500/300?random=', i + 50), 1);
        END IF;
        SET i = i + 1;
    END WHILE;
END;

create procedure InsertUsers()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 50 DO
        INSERT INTO User (user_name, user_school_id)
        VALUES (CONCAT('user', i), 1);
        SET i = i + 1;
    END WHILE;
END;


