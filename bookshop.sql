-- 创建数据库
CREATE DATABASE IF NOT EXISTS bookshop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE bookshop;

-- 删除已存在的表（按依赖关系逆序）
DROP TABLE IF EXISTS order_item;
DROP TABLE IF EXISTS shopping_cart;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS book;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS user_info;
DROP TABLE IF EXISTS admin;

-- 创建管理员表
CREATE TABLE admin (
    admin_name VARCHAR(50) NOT NULL PRIMARY KEY COMMENT '管理员账号',
    password VARCHAR(100) NOT NULL COMMENT '密码'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='管理员表';

-- 创建用户表
CREATE TABLE user_info (
    user_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '用户ID',
    user_name VARCHAR(50) NOT NULL COMMENT '用户名',
    password VARCHAR(100) NOT NULL COMMENT '密码',
    email VARCHAR(100) COMMENT '邮箱',
    avatar VARCHAR(255) COMMENT '头像',
    join_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
    UNIQUE KEY uk_user_name (user_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 创建分类表
CREATE TABLE category (
    category_code VARCHAR(50) NOT NULL PRIMARY KEY COMMENT '分类代码',
    category_name VARCHAR(50) NOT NULL COMMENT '分类名称'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='分类表';

-- 创建图书表
CREATE TABLE book (
    book_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '图书ID',
    category_code VARCHAR(50) NOT NULL COMMENT '分类代码',
    book_name VARCHAR(200) NOT NULL COMMENT '图书名称',
    isbn VARCHAR(50) NOT NULL COMMENT 'ISBN',
    author VARCHAR(100) NOT NULL COMMENT '作者',
    press VARCHAR(100) NOT NULL COMMENT '出版社',
    pub_date DATE COMMENT '出版日期',
    image VARCHAR(255) COMMENT '图片',
    description VARCHAR(1000) COMMENT '描述',
    price DECIMAL(10, 2) NOT NULL COMMENT '价格',
    stock INT NOT NULL COMMENT '库存',
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    FOREIGN KEY (category_code) REFERENCES category(category_code) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_category_code (category_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='图书表';

-- 创建订单表
CREATE TABLE orders (
    order_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '订单ID',
    user_id INT NOT NULL COMMENT '用户ID',
    consignee_name VARCHAR(50) NOT NULL COMMENT '收货人姓名',
    address VARCHAR(255) NOT NULL COMMENT '收货地址',
    zip VARCHAR(10) NOT NULL COMMENT '邮政编码',
    phone_number VARCHAR(20) NOT NULL COMMENT '联系方式',
    status BIT DEFAULT 0 COMMENT '状态（0未处理，1已处理）',
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    FOREIGN KEY (user_id) REFERENCES user_info(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单表';

-- 创建订单项表
CREATE TABLE order_item (
    order_item_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '订单项ID',
    order_id INT NOT NULL COMMENT '订单ID',
    book_id INT NOT NULL COMMENT '图书ID',
    price DECIMAL(10, 2) NOT NULL COMMENT '价格',
    quantity INT NOT NULL COMMENT '数量',
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (book_id) REFERENCES book(book_id) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_order_id (order_id),
    INDEX idx_book_id (book_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单项表';

-- 创建购物车表
CREATE TABLE shopping_cart (
    cart_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '购物车ID',
    user_id INT NOT NULL COMMENT '用户ID',
    book_id INT NOT NULL COMMENT '图书ID',
    price DECIMAL(10, 2) NOT NULL COMMENT '价格',
    quantity INT NOT NULL COMMENT '数量',
    FOREIGN KEY (user_id) REFERENCES user_info(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (book_id) REFERENCES book(book_id) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE KEY uk_user_book (user_id, book_id),
    INDEX idx_user_id (user_id),
    INDEX idx_book_id (book_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='购物车表';

-- 插入初始数据

-- 插入管理员数据
INSERT INTO admin (admin_name, password) VALUES 
('admin', 'admin123');

-- 插入分类数据
INSERT INTO category (category_code, category_name) VALUES 
('edu', '教育'),
('life', '生活'),
('manage', '经营'),
('novel', '小说'),
('sheke', '社科'),
('wenyi', '文艺');

-- 插入用户数据
INSERT INTO user_info (user_id, user_name, password, email, join_time) VALUES 
(1, 'testuser', '123456', 'test@example.com', '2020-01-06 20:12:00');

-- 插入图书数据
INSERT INTO book (book_id, category_code, book_name, isbn, author, press, pub_date, image, description, price, stock, create_time) VALUES 
(1, 'novel', '巴黎圣母院', '9787560575667', '[法]雨果 著 李玉民 译', '西安交通大学出版社', '2015-01-08', '24170734-1_l_4.jpg', '北大西语系翻译家李玉民全译本，"世界十大名著""世界十大爱情故事"之一，读过后，更懂爱', 37.80, 100, '2020-01-06 20:12:00'),
(2, 'novel', '失乐园', '9787555257035', '渡边淳一[著]  林少华[译]', '青岛出版社', '2017-01-11', '25182491-1_l_6.jpg', '渡边淳一代表作，长期雄踞日本畅销书排行榜榜首，由黑木瞳、役所广司主演的电影引发"失乐园"热。此次的全新林少华译本，将带你体味不一样的渡边淳一，不一样的失乐园。', 45.00, 100, '2020-01-06 20:12:00'),
(3, 'novel', '假面之夜+假面饭店+假面前夜', '25286485', '东野圭吾', '南海出版公司', '2018-01-06', '25286485-1_l_2.jpg', '新系列新CP。富丽堂皇的五星级大酒店，各怀心事的客人。平静的表面下暗流汹涌。杀人凶手即将在此现身。新田尚美联手揭开假面。', 115.90, 100, '2020-01-06 20:12:00'),
(4, 'novel', '布隆夫曼脱单历险记', '9787559431394', '[美]丹尼尔·华莱士 著 宁蒙 译 时代华语', '江苏凤凰文艺出版社', '2019-01-04', '26916949-1_l_6.jpg', '为什么不结婚？为什么想恋爱却不主动？单身人士，可能是对自我和世界有着独特认知，对他们来说，脱单之旅，不止是一次成长冒险，更是与原生家庭的和解，与人类社会的碰撞。单身族群，比起伴侣，更需要的是找到自己。', 35.80, 100, '2020-01-06 20:12:00'),
(5, 'novel', '光与影', '9787555269397', '渡边淳一', '青岛出版社', '2018-05-25', '25283531-1_l_3.jpg', '渡边淳一文学的原点之作 日本文学奖直木奖获奖作品 关于命运和与人性 关于死亡与热爱 关于病痛与尊严 关于爱情与复仇', 32.00, 100, '2020-01-06 20:12:00'),
(6, 'novel', '三体：全三册', '23579654', '刘慈欣', '重庆出版社', '2010-01-11', '23579654-1_l_3.jpg', '刘慈欣代表作，亚洲首部"雨果奖"获奖作品！', 55.80, 100, '2020-01-06 20:12:00'),
(7, 'novel', '鲛在水中央', '9787540490645', '孙频', '湖南文艺出版社', '2017-01-08', '27855831-1_l_4.jpg', '阎连科、韩少功、苏童鼎力推荐。这个人世间，有谁不是在努力地活着。这是一本让你流着泪读完的书！那些孤独的、无奈的却又不向命运低头的人，都是生活的勇者。', 42.70, 100, '2020-01-06 20:12:00'),
(8, 'manage', '彼得·林奇点评版股票作手回忆录', '9787515303628', '[美]杰西·利弗莫尔', '中国青年出版社', '2019-01-05', '27855149-1_l_3.jpg', ' 利弗莫尔，从5元本金到1亿资本额，这是每代股神都难以忽略的股市传奇。《彼得林奇点评版股票作手回忆录》是由彼得林奇点评，凯恩斯作序的经典之作', 32.20, 100, '2020-01-06 20:12:00'),
(9, 'manage', '财务自由之路（全三册）', '26511903', '[德]博多·舍费尔', '现代出版社', '2019-02-20', '26511903-1_l_2.jpg', '理念指导+操作技巧 助力投资新手、投资高手！', 121.10, 100, '2020-01-06 20:12:00'),
(10, 'manage', '稻盛和夫阿米巴经营经典套装（理论+实践）', '9787520202824', '[日]稻盛和夫', '中国大百科全书出版社', '2018-01-05', '25288392-1_l_1.jpg', '日本经营之圣稻盛和夫亲笔撰写，首次全公开曾秘不外传的阿米巴经营要领！学习阿米巴经营的经典教材，畅销70万册', 74.70, 100, '2020-01-06 20:12:00');

