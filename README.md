# Database-for-SmartStoreX
# 校园店铺管理系统数据库设计

本项目包含了一个面向「校园店铺管理系统」场景的 MySQL 数据库建模脚本，设计目标是支持以下功能模块：

- 校园信息管理
- 店铺信息与分类
- 店铺图片管理
- 店铺广告与活动
- 用户信息、登录日志
- 用户收藏与偏好
- 用户反馈管理
- 统一媒体文件存储

本仓库包含建表 SQL 以及若干初始化存储过程，用于批量生成测试数据。

---

## 📚 表结构概览

下表给出各主要表的简要说明：

| 表名                  | 说明                         |
| --------------------- | -------------------------- |
| `school`              | 学校信息表                     |
| `campusstore`         | 校园店铺信息表                   |
| `storecategory`       | 店铺分类表                     |
| `storecategoryrelation` | 店铺与分类关联表                 |
| `storeimages`         | 店铺图片表                     |
| `imagetype`           | 图片类型表                     |
| `store_ad_banner`     | 店铺广告轮播图表                 |
| `storeactivity`       | 店铺活动信息表                   |
| `user`                | 用户信息表（微信登录，角色管理）      |
| `userfavorites`       | 用户收藏信息表                   |
| `usermenu`            | 用户偏好（菜单/店铺）表            |
| `userloginlog`        | 用户登录日志表                   |
| `media_file`          | 统一媒体资源管理表（支持OSS存储等）   |
| `feedback`            | 用户反馈表                       |

---

## 🗂️ 详细表设计说明

### 1. `school`

- 学校ID、学校名称（唯一约束）
- 用于多校区或跨校管理场景

### 2. `campusstore`

- 店铺ID、名称、地址、具体地址
- 营业时间（JSON）、封面图、文字介绍
- 所属学校（外键）
- 支持「线上点单」标志位
- 自动记录创建时间和更新时间

### 3. `storecategory` 和 `storecategoryrelation`

- 独立的分类表，支持全局统一分类
- 关联表实现多对多：一个店铺可属于多个分类

### 4. `storeimages` 与 `imagetype`

- 独立的图片类型表支持类型可配置
- 店铺图片表记录店铺关联的多张图（按类型区分）

### 5. `store_ad_banner`

- 店铺广告轮播图
- 与学校、店铺绑定
- 支持启用状态、优先级排序

### 6. `storeactivity`

- 店铺活动信息
- 名称、时间范围、封面图
- 富文本描述
- 是否展示标志位

### 7. `user`

- 微信openid为唯一标识
- 角色区分（USER/ADMIN）
- 所属学校
- 头像、昵称

### 8. `userfavorites` / `usermenu`

- 用户收藏/偏好
- 均为用户与店铺的多对多关系表
- 支持自定义排序权重

### 9. `userloginlog`

- 用户登录日志
- 记录时间、IP

### 10. `feedback`

- 用户提交反馈
- 分类、内容、可选图片（JSON数组）
- 可选联系方式（QQ、微信、电话、邮箱）
- 自动记录提交时间

### 11. `media_file`

- 全局媒体管理表
- 存储OSS URL
- 记录绑定的业务模块与对象ID
- 临时/正式标志位支持未绑定文件清理
- 支持记录文件大小、类型、MIME

---

## ⚙️ 外键与约束设计

- 所有外键启用 **ON DELETE CASCADE** 或 **SET NULL**，保证数据一致性
- 多张表使用 UNIQUE 约束（如 openid、学校名称、分类名称）
- 部分表启用索引优化查询（如 `store_school_id`, `category_id` 等）

---

## 🛠️ 存储过程

本SQL文件还包含三个方便插入测试数据的存储过程：

### `InsertCampusStores()`
- 批量插入50个测试店铺
- 随机生成图片URL、营业时间、文本信息

### `InsertStoreImages()`
- 批量为前50个店铺插入图片

---

## 🧪 运行顺序建议

为了避免外键约束失败，建库或迁移时建议按以下顺序运行：

1️⃣ school  
2️⃣ campusstore  
3️⃣ storecategory  
4️⃣ storecategoryrelation  
5️⃣ imagetype  
6️⃣ storeimages  
7️⃣ store_ad_banner  
8️⃣ storeactivity  
9️⃣ user  
1️⃣0️⃣ userfavorites  
1️⃣1️⃣ usermenu  
1️⃣2️⃣ userloginlog  
1️⃣3️⃣ feedback  
1️⃣4️⃣ media_file  
1️⃣5️⃣ 存储过程定义

---

## 🗒️ 版本与兼容性

- 设计基于 **MySQL 5.7+ / 8.0** 语法
- 部分字段使用 JSON 类型，需要 MySQL 5.7+ 支持
- 建议启用严格模式

---

## 📌 维护建议

✅ 定期清理未绑定的 `media_file`  
✅ 结合业务后端自动管理图片类型、广告启用状态  
✅ 针对 `feedback` 图片使用统一存储表优化关联  
✅ 考虑分库分表、分校区隔离策略

---

## 📜 许可证

本仓库示例SQL脚本可自由用于学习、教学和商业项目参考。

---
