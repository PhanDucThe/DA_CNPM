-- Bảng users
CREATE TABLE users(
    id INT IDENTITY(1,1) PRIMARY KEY,
    full_name NVARCHAR(100) DEFAULT '',
    phone_number NVARCHAR(20) NOT NULL,
    email NVARCHAR(100) NOT NULL,
    password NVARCHAR(100) NOT NULL,
    avatar NVARCHAR(255) DEFAULT '',
    is_active BIT DEFAULT 1,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    created_by NVARCHAR(100) DEFAULT '',
    updated_by NVARCHAR(100) DEFAULT '' 
);
-- Bảng roles
CREATE TABLE roles(
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(50) NOT NULL,
    code NVARCHAR(50) NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    created_by NVARCHAR(100) DEFAULT '',
    updated_by NVARCHAR(100) DEFAULT ''
);


-- Bảng user_roles
CREATE TABLE user_roles(
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    role_id INT NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    created_by NVARCHAR(100) DEFAULT '',
    updated_by NVARCHAR(100) DEFAULT '',
    CONSTRAINT fk_userRole_users FOREIGN KEY(user_id) REFERENCES users(id),
    CONSTRAINT fk_userRole_roles FOREIGN KEY(role_id) REFERENCES roles(id)
);

-- Bảng provinces
CREATE TABLE provinces(
    code NVARCHAR(20) NOT NULL PRIMARY KEY(code), -- Mã định danh duy nhất, ví dụ: 'HN', 'SG'
    name NVARCHAR(255) NOT NULL, -- Tên ngắn gọn, ví dụ: 'Hà Nội'
    name_en NVARCHAR(255) NULL, -- Tên tiếng Anh
    full_name NVARCHAR(255) NOT NULL, -- Tên đầy đủ, ví dụ: 'Thành phố Hà Nội'
    full_name_en NVARCHAR(255) NULL, -- Tên đầy đủ tiếng Anh
    code_name NVARCHAR(255) NULL, -- Tên không dấu để dùng cho URL, ví dụ: 'ha_noi'
);

-- Bảng districts
CREATE TABLE districts(
    code NVARCHAR(20) NOT NULL PRIMARY KEY(code), -- Mã định danh duy nhất
    name NVARCHAR(255) NOT NULL, -- Tên ngắn gọn, ví dụ: 'Ba Đình'
    name_en NVARCHAR(255) NULL, -- Tên tiếng Anh
    full_name NVARCHAR(255) NOT NULL, -- Tên đầy đủ, ví dụ: 'Quận Ba Đình'
    full_name_en NVARCHAR(255) NULL, -- Tên đầy đủ tiếng Anh
    code_name NVARCHAR(255) NULL, -- Tên không dấu
    province_code NVARCHAR(20) NOT NULL, -- Khóa ngoại liên kết với bảng provinces
    CONSTRAINT fk_districts_provinces FOREIGN KEY(province_code) REFERENCES provinces(code)
);

-- Bảng wards
CREATE TABLE wards(
    code NVARCHAR(20) NOT NULL PRIMARY KEY(code), -- Mã định danh duy nhất
    name NVARCHAR(255) NOT NULL, -- Tên ngắn gọn, ví dụ: 'Phúc Xá'
    name_en NVARCHAR(255) NULL, -- Tên tiếng Anh
    full_name NVARCHAR(255) NOT NULL, -- Tên đầy đủ, ví dụ: 'Phường Phúc Xá'
    full_name_en NVARCHAR(255) NULL, -- Tên đầy đủ tiếng Anh
    code_name NVARCHAR(255) NULL, -- Tên không dấu
    district_code NVARCHAR(20) NOT NULL, -- Khóa ngoại liên kết với bảng districts
    CONSTRAINT fk_wards_districts FOREIGN KEY(district_code) REFERENCES districts(code)
);

-- Bảng coupons
CREATE TABLE coupons(
    id INT IDENTITY(1,1) PRIMARY KEY,
    code NVARCHAR(255) NOT NULL,
    is_active BIT DEFAULT 1,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    created_by NVARCHAR(100) DEFAULT NULL,
    updated_by NVARCHAR(100) DEFAULT NULL,
    CONSTRAINT uk_coupons_code UNIQUE (code)
);


-- Bảng coupon_conditions
CREATE TABLE coupon_conditions(
    id INT IDENTITY(1,1) PRIMARY KEY,
    coupon_id INT NOT NULL,
    attribute NVARCHAR(255) NOT NULL,
    operator NVARCHAR(50) NOT NULL,
    value NVARCHAR(255) NOT NULL,
    discount_amount DECIMAL(15, 2) NOT NULL,
    discount_type NVARCHAR(20) NOT NULL DEFAULT 'FIXED_AMOUNT' CHECK (discount_type IN ('PERCENTAGE', 'FIXED_AMOUNT')),
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    created_by NVARCHAR(100) DEFAULT NULL,
    updated_by NVARCHAR(100) DEFAULT NULL,
    CONSTRAINT fk_coupon_conditions_coupons FOREIGN KEY(coupon_id) REFERENCES coupons(id)
);

CREATE TABLE categories(
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    parent_id INT DEFAULT NULL, -- Để làm danh mục đa cấp (VD: Dược phẩm -> Thuốc kháng sinh)
    slug NVARCHAR(120) NOT NULL,
    is_active BIT DEFAULT 1,
    
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    created_by NVARCHAR(100) DEFAULT '',
    updated_by NVARCHAR(100) DEFAULT '',

    CONSTRAINT uk_categories_slug UNIQUE (slug),
    CONSTRAINT fk_categories_parent FOREIGN KEY(parent_id) REFERENCES categories(id)
);

CREATE TABLE brands(
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    slug NVARCHAR(120) NOT NULL,
    is_active BIT DEFAULT 1,

    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    created_by NVARCHAR(100) DEFAULT '',
    updated_by NVARCHAR(100) DEFAULT '',

    CONSTRAINT uk_brands_slug UNIQUE (slug)
);

-- Bảng products
CREATE TABLE products(
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(350) NOT NULL, -- Tên sản phẩm
    sku NVARCHAR(50) NOT NULL, -- Stock Keeping Unit, mã định danh duy nhất cho sản phẩm
    slug NVARCHAR(400) NOT NULL, -- Dùng cho URL thân thiện, ví dụ: "thuoc-ho-prospan"
    thumbnail_url NVARCHAR(MAX) DEFAULT '', -- URL ảnh đại diện của sản phẩm
    description NTEXT DEFAULT '', -- Mô tả ngắn gọn
    content NTEXT DEFAULT '', -- Nội dung chi tiết, hướng dẫn sử dụng
    
    -- Yêu cầu đặc biệt: Lưu thông tin thành phần dưới dạng JSON
    -- Ví dụ: '[{"name": "Paracetamol", "amount": "500", "unit": "mg"}, {"name": "Caffeine", "amount": "65", "unit": "mg"}]'
    ingredients NVARCHAR(MAX) DEFAULT '[]',
    
    -- Các thông tin đặc thù của ngành dược
    dosage NVARCHAR(500) DEFAULT '', -- Liều dùng
    contraindications NTEXT DEFAULT '', -- Chống chỉ định
    packaging_details NVARCHAR(255) DEFAULT '', -- Quy cách đóng gói, ví dụ: "Hộp 3 vỉ x 10 viên"
    prescription_required BIT DEFAULT 0, -- Có phải thuốc kê đơn không (0: không, 1: có)

    -- Thông tin kinh doanh
    original_price DECIMAL(15, 2) NOT NULL DEFAULT 0, -- Giá gốc
	sale_price DECIMAL(15, 2) NOT NULL DEFAULT 0, -- Giá gốc
    stock_quantity INT NOT NULL DEFAULT 0, -- Số lượng tồn kho
	stock INT DEFAULT 0, -- Số lượng bán được
    is_active BIT DEFAULT 1, -- Trạng thái kinh doanh (1: đang bán, 0: ngừng bán)
    
    -- Khóa ngoại tới các bảng khác
    category_id INT,
    brand_id INT,

    -- Dữ liệu theo dõi
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    created_by NVARCHAR(100) DEFAULT '',
    updated_by NVARCHAR(100) DEFAULT '',

    -- Ràng buộc
    CONSTRAINT uk_products_sku UNIQUE (sku),
    CONSTRAINT uk_products_slug UNIQUE (slug),
    CONSTRAINT fk_products_category FOREIGN KEY(category_id) REFERENCES categories(id),
	CONSTRAINT fk_products_barand FOREIGN KEY(brand_id) REFERENCES brands(id)
);

CREATE TABLE product_images(
    id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT NOT NULL,
    image_url NVARCHAR(255) NOT NULL,
    display_order INT DEFAULT 0, -- Sắp xếp thứ tự hiển thị ảnh

    -- Dữ liệu theo dõi
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    created_by NVARCHAR(100) DEFAULT '',
    updated_by NVARCHAR(100) DEFAULT '',

    CONSTRAINT fk_product_images_products FOREIGN KEY(product_id) REFERENCES products(id)
);


-- Bảng orders
CREATE TABLE orders(
    -- 🔹 Thông tin chính
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    
    -- 🔹 Thông tin khách hàng tại thời điểm đặt hàng (dữ liệu snapshot)
    full_name NVARCHAR(100) NOT NULL,
    phone_number NVARCHAR(20) NOT NULL,
    shipping_address NVARCHAR(255) NOT NULL,
    note NVARCHAR(255) DEFAULT NULL,
    
    -- 🔹 Thông tin tài chính (rõ ràng và chi tiết)
    subtotal_money DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    shipping_fee DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    discount_amount DECIMAL(15,2) DEFAULT 0.00 ,
    total_money AS (subtotal_money + shipping_fee - discount_amount) PERSISTED,
    
    -- 🔹 Thông tin thanh toán
    payment_method NVARCHAR(20) NOT NULL CHECK (payment_method IN ('COD', 'VNPAY', 'BANK_TRANSFER', 'OTHER')),
    payment_status NVARCHAR(30) NOT NULL DEFAULT 'UNPAID' CHECK (payment_status IN (
        'UNPAID', 'PENDING', 'PAID', 'FAILED', 'REFUNDED', 'PARTIALLY_REFUNDED'
    )),
    
    -- 🔹 Thông tin vận chuyển
    shipping_method NVARCHAR(100) DEFAULT '',
    tracking_number NVARCHAR(100) NOT NULL DEFAULT '',
    
    -- 🔹 Trạng thái XỬ LÝ đơn hàng
    status NVARCHAR(30) NOT NULL DEFAULT 'PENDING_CONFIRMATION' CHECK (status IN (
        'PENDING_CONFIRMATION', 'PROCESSING', 'SHIPPED', 'DELIVERED', 'CANCELLED', 'RETURNED'
    )),
    
    -- 🔹 Thời gian (chi tiết hơn)
    order_date DATETIME2 DEFAULT GETDATE(),
    estimated_delivery_start_date DATE DEFAULT NULL,
    estimated_delivery_end_date DATE DEFAULT NULL,
    
    -- Timestamps
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    created_by NVARCHAR(100) DEFAULT NULL,
    updated_by NVARCHAR(100) DEFAULT NULL,
    
    CONSTRAINT fk_order_user FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Bảng order_items
CREATE TABLE order_items(
    id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1 CHECK (quantity > 0),
    price DECIMAL(15,2) NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    created_by NVARCHAR(100) DEFAULT NULL,
    updated_by NVARCHAR(100) DEFAULT NULL,
    CONSTRAINT fk_orderItem_order FOREIGN KEY(order_id) REFERENCES orders(id),
    CONSTRAINT fk_orderItem_product FOREIGN KEY(product_id) REFERENCES products(id)
);

-- Bảng carts 
CREATE TABLE carts (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    total_items INT DEFAULT 0,
    total_price DECIMAL(15,2) DEFAULT 0.00,
    status NVARCHAR(20) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'ABANDONED', 'CONVERTED')),
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    created_by NVARCHAR(100) DEFAULT NULL,
    updated_by NVARCHAR(100) DEFAULT NULL,
    CONSTRAINT FK_carts_users FOREIGN KEY (user_id) REFERENCES users(id)
);


-- Bảng cart_items
CREATE TABLE cart_items (
    id INT IDENTITY(1,1) PRIMARY KEY,
    cart_id INT NOT NULL,
    product_id INT NOT NULL,
    product_name NVARCHAR(255) NOT NULL,
    image NVARCHAR(255) NOT NULL,
    quantity INT NOT NULL DEFAULT 1 CHECK (quantity > 0),
    original_price DECIMAL(15,2) NOT NULL,
    sale_price DECIMAL(15,2) NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    created_by NVARCHAR(100) DEFAULT NULL,
    updated_by NVARCHAR(100) DEFAULT NULL,
    
    -- UNIQUE KEY tương đương
    CONSTRAINT ux_cart_variant UNIQUE (cart_id, product_id),
    
    -- Nếu xóa giỏ hàng, các item con cũng bị xóa theo
    CONSTRAINT FK_cart_items_carts FOREIGN KEY (cart_id) REFERENCES carts(id),
    CONSTRAINT FK_cart_items_variants FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Bảng này dùng để phân loại các bài viết theo chủ đề lớn, ví dụ: "Sống khỏe", "Bệnh thường gặp", "Mẹ và bé".
CREATE TABLE post_categories(
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    slug NVARCHAR(120) NOT NULL,
    parent_id INT DEFAULT NULL, -- Dùng cho chuyên mục đa cấp
    description NVARCHAR(500) DEFAULT '',
    
    -- Dữ liệu theo dõi
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    created_by NVARCHAR(100) DEFAULT '',
    updated_by NVARCHAR(100) DEFAULT '',

    CONSTRAINT uk_post_categories_slug UNIQUE (slug),
    CONSTRAINT fk_post_categories_parent FOREIGN KEY(parent_id) REFERENCES post_categories(id)
);


-- Tags giúp phân loại bài viết một cách linh hoạt hơn. Một bài viết có thể có nhiều tags, ví dụ: "tiểu đường", "dinh dưỡng", "vitamin C".
CREATE TABLE tags(
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    slug NVARCHAR(120) NOT NULL,

    -- Dữ liệu theo dõi
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    created_by NVARCHAR(100) DEFAULT '',
    updated_by NVARCHAR(100) DEFAULT '',

    CONSTRAINT uk_tags_slug UNIQUE (slug)
);

-- Đây là bảng trung tâm chứa nội dung của các bài viết.
CREATE TABLE posts(
    id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(255) NOT NULL, -- Tiêu đề bài viết
    slug NVARCHAR(300) NOT NULL, -- URL thân thiện
    excerpt NVARCHAR(500) DEFAULT '', -- Đoạn tóm tắt ngắn
    content NTEXT DEFAULT '', -- Nội dung chi tiết của bài viết
    thumbnail_url NVARCHAR(255) DEFAULT '', -- Ảnh đại diện
    
    author_id INT NOT NULL, -- Người viết bài, liên kết với bảng users
    category_id INT, -- Chuyên mục chính của bài viết
    
    -- Quản lý trạng thái và hiển thị
    status NVARCHAR(30) NOT NULL DEFAULT 'DRAFT' CHECK (status IN ('DRAFT', 'PUBLISHED', 'ARCHIVED')),
    published_at DATETIME2, -- Thời gian xuất bản, dùng để hẹn giờ đăng bài
    view_count INT DEFAULT 0, -- Lượt xem
    
    -- Dữ liệu theo dõi
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    created_by NVARCHAR(100) DEFAULT '',
    updated_by NVARCHAR(100) DEFAULT '',

    CONSTRAINT uk_posts_slug UNIQUE (slug),
    CONSTRAINT fk_posts_users FOREIGN KEY(author_id) REFERENCES users(id),
    CONSTRAINT fk_posts_post_categories FOREIGN KEY(category_id) REFERENCES post_categories(id)
);

-- Vì một bài viết có thể có nhiều thẻ và một thẻ có thể được dùng cho nhiều bài viết (quan hệ nhiều-nhiều), chúng ta cần một bảng trung gian để kết nối chúng.
CREATE TABLE post_tags(
    id INT IDENTITY(1,1) PRIMARY KEY,
    post_id INT NOT NULL,
    tag_id INT NOT NULL,
	-- Dữ liệu theo dõi
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    created_by NVARCHAR(100) DEFAULT '',
    updated_by NVARCHAR(100) DEFAULT '',
    CONSTRAINT fk_post_tags_posts FOREIGN KEY(post_id) REFERENCES posts(id),
    CONSTRAINT fk_post_tags_tags FOREIGN KEY(tag_id) REFERENCES tags(id)
);


-- DỮ LIỆU MẶC ĐỊNH
-- INSERT 3 vai trò mặc định
INSERT INTO roles (name, code, created_by, updated_by) VALUES
    (N'Quản trị viên', N'ADMIN', N'system', N'system'),
    (N'Khách hàng', N'CUSTOMER', N'system', N'system'),
    (N'Khách hàng VIP', N'VIP_CUSTOMER', N'system', N'system');

-- Chèn dữ liệu cho bảng categories
-- Danh mục cha
INSERT INTO categories (name, parent_id, slug) VALUES
(N'Dược phẩm', NULL, 'duoc-pham'),
(N'Thực phẩm chức năng', NULL, 'thuc-pham-chuc-nang'),
(N'Chăm sóc cá nhân', NULL, 'cham-soc-ca-nhan'),
(N'Mẹ và Bé', NULL, 'me-va-be'),
(N'Thiết bị y tế', NULL, 'thiet-bi-y-te');

-- Danh mục con thuộc "Dược phẩm" (parent_id = 1)
INSERT INTO categories (name, parent_id, slug) VALUES
(N'Thuốc giảm đau - Hạ sốt', 1, 'thuoc-giam-dau-ha-sot'),
(N'Thuốc kháng sinh', 1, 'thuoc-khang-sinh'),
(N'Thuốc ho - Cảm cúm', 1, 'thuoc-ho-cam-cum'),
(N'Thuốc tiêu hóa', 1, 'thuoc-tieu-hoa');

-- Danh mục con thuộc "Thực phẩm chức năng" (parent_id = 2)
INSERT INTO categories (name, parent_id, slug) VALUES
(N'Vitamin và Khoáng chất', 2, 'vitamin-va-khoang-chat'),
(N'Hỗ trợ xương khớp', 2, 'ho-tro-xuong-khop'),
(N'Hỗ trợ tuần hoàn não', 2, 'ho-tro-tuan-hoan-nao');

-- Danh mục con thuộc "Chăm sóc cá nhân" (parent_id = 3)
INSERT INTO categories (name, parent_id, slug) VALUES
(N'Chăm sóc da mặt', 3, 'cham-soc-da-mat');

-- Chèn dữ liệu cho bảng brands
INSERT INTO brands (name, slug) VALUES
(N'DHG Pharma', 'dhg-pharma'),
(N'Traphaco', 'traphaco'),
(N'Sanofi', 'sanofi'),
(N'Bayer', 'bayer'),
(N'OPC', 'opc'),
(N'Blackmores', 'blackmores'),
(N'La Roche-Posay', 'la-roche-posay'),
(N'Rohto-Mentholatum', 'rohto-mentholatum'),
(N'Hasan', 'hasan'),
(N'Pymepharco', 'pymepharco'),
(N'Abbott', 'abbott'),
(N'GSK (GlaxoSmithKline)', 'gsk');





select*from categories




select*from products
insert into products (name, sku, slug, original_price, sale_price) values (N'Sua tam babi', N'ST', N'Sua_tam_babi', 200000, 149000);
insert into products (name, sku, slug, original_price, sale_price) values (N'Thuoc tieu hoa ', N'TH', N'thuoc-tieu-hoa', 200000, 149000);

INSERT INTO products 
(name, sku, slug, thumbnail_url, description, content, ingredients, dosage, contraindications, packaging_details, 
prescription_required, original_price, sale_price, stock_quantity, stock, is_active, category_id, brand_id) VALUES
(N'Sữa tắm Babi Mild', N'SP001', N'sua-tam-babi-mild', N'/images/products/babi1-thumb.jpg', 
 N'Sữa tắm dịu nhẹ cho bé', N'Sản phẩm giúp làm sạch và dưỡng ẩm cho da bé.', 
 N'[{"name": "Tinh chất sữa", "amount": "10", "unit": "%"}]', 
 N'Dùng hằng ngày khi tắm', N'Không dùng cho người dị ứng với sữa', N'Chai 400ml', 
 0, 65000, 55000, 100, 20, 1, NULL, NULL),

(N'Kem chống hăm Bepanthen', N'SP002', N'kem-chong-ham-bepanthen', N'/images/products/bepanthen-thumb.jpg',
 N'Kem trị hăm cho trẻ sơ sinh', N'Giúp ngăn ngừa và điều trị hăm tã hiệu quả.',
 N'[{"name": "Dexpanthenol", "amount": "5", "unit": "%"}]',
 N'Thoa lên vùng da bị hăm 2-3 lần/ngày', N'Không dùng trên vết thương hở', N'Tuýp 30g',
 0, 85000, 79000, 200, 50, 1, NULL, NULL),

(N'Siro ho Prospan', N'SP003', N'siro-ho-prospan', N'/images/products/prospan-thumb.jpg',
 N'Siro ho thảo dược cho trẻ em', N'Hỗ trợ giảm ho, giảm đờm, dễ thở hơn.',
 N'[{"name": "Lá thường xuân", "amount": "35", "unit": "mg"}]',
 N'Uống 2 lần/ngày sau ăn', N'Không dùng cho trẻ dưới 1 tuổi', N'Chai 100ml',
 1, 125000, 115000, 150, 40, 1, NULL, NULL);

select*from product_images
--Ảnh cho sản phẩm 1: Sữa tắm Babi
INSERT INTO product_images (product_id, image_url, display_order)
VALUES 
(1, '/images/products/babi1-1.jpg', 1),
(1, '/images/products/babi1-2.jpg', 2),
(1, '/images/products/babi1-3.jpg', 3);

--Ảnh cho sản phẩm 2: Kem chống hăm Bepanthen
INSERT INTO product_images (product_id, image_url, display_order)
VALUES 
(2, '/images/products/bepanthen-1.jpg', 1),
(2, '/images/products/bepanthen-2.jpg', 2);

--Ảnh cho sản phẩm 3: Siro ho Prospan
INSERT INTO product_images (product_id, image_url, display_order)
VALUES 
(3, '/images/products/prospan-1.jpg', 1),
(3, '/images/products/prospan-2.jpg', 2),
(3, '/images/products/prospan-3.jpg', 3);

SELECT id, name, category_id FROM products

INSERT INTO products
(name, sku, slug, thumbnail_url, description, content, ingredients, dosage, contraindications, packaging_details, prescription_required, original_price, sale_price, stock_quantity, stock, is_active, category_id, brand_id, created_by)
VALUES
-- 1. Dược phẩm
(N'Thuốc ho Prospan', 'SP001', 'thuoc-ho-prospan', 'https://example.com/images/prospan.jpg',
 N'Thuốc ho chiết xuất từ lá thường xuân giúp giảm ho, long đờm.', 
 N'Dùng điều trị ho do cảm lạnh, viêm phế quản. Thích hợp cho trẻ em.', 
 N'[{"name": "Lá thường xuân", "amount": "35", "unit": "mg"}]', 
 N'Uống 5ml/lần, ngày 2–3 lần sau bữa ăn', 
 N'Không dùng cho người mẫn cảm với thành phần thuốc.', 
 N'Hộp 1 chai 100ml', 
 0, 95000, 89000, 120, 30, 1, 1, 2, N'Admin'),

-- 2. Thực phẩm chức năng
(N'Viên uống Vitamin C 1000mg', 'SP002', 'vitamin-c-1000mg', 'https://example.com/images/vitamin-c.jpg',
 N'Tăng sức đề kháng, giúp da khỏe mạnh và hỗ trợ miễn dịch.', 
 N'Cung cấp Vitamin C liều cao, phù hợp người cần bổ sung vitamin.', 
 N'[{"name": "Vitamin C", "amount": "1000", "unit": "mg"}]', 
 N'Uống 1 viên/ngày sau bữa ăn', 
 N'Không dùng cho người bị sỏi thận hoặc mẫn cảm với Vitamin C.', 
 N'Hộp 3 vỉ x 10 viên', 
 0, 120000, 99000, 200, 45, 1, 2, 1, N'Admin'),

-- 3. Thuốc kháng sinh
(N'Amoxicillin 500mg', 'SP003', 'amoxicillin-500mg', 'https://example.com/images/amoxicillin.jpg',
 N'Thuốc kháng sinh nhóm penicillin, điều trị nhiễm khuẩn.', 
 N'Tác dụng với viêm họng, viêm tai giữa, nhiễm khuẩn hô hấp.', 
 N'[{"name": "Amoxicillin trihydrate", "amount": "500", "unit": "mg"}]', 
 N'Uống 1 viên/lần, ngày 2–3 lần theo chỉ định bác sĩ.', 
 N'Không dùng cho người dị ứng với penicillin.', 
 N'Hộp 2 vỉ x 10 viên', 
 1, 65000, 60000, 80, 25, 1, 3, 3, N'Admin'),

-- 4. Thuốc tiêu hóa
(N'Enterogermina 5ml', 'SP004', 'enterogermina-5ml', 'https://example.com/images/enterogermina.jpg',
 N'Dung dịch chứa lợi khuẩn giúp cân bằng hệ vi sinh đường ruột.', 
 N'Dùng trong trường hợp rối loạn tiêu hóa, tiêu chảy do loạn khuẩn.', 
 N'[{"name": "Bacillus clausii", "amount": "2", "unit": "tỷ bào tử"}]', 
 N'Uống 1 ống/lần, ngày 2 lần', 
 N'Không dùng cho người có tiền sử dị ứng với Bacillus clausii.', 
 N'Hộp 10 ống x 5ml', 
 0, 130000, 115000, 60, 10, 1, 4, 4, N'Admin'),

-- 5. Thiết bị y tế
(N'Máy đo huyết áp Omron HEM-7120', 'SP005', 'may-do-huyet-ap-omron-hem-7120', 'https://example.com/images/omron-hem-7120.jpg',
 N'Máy đo huyết áp tự động bắp tay, hiển thị kết quả nhanh và chính xác.', 
 N'Thiết bị đo huyết áp dùng cho gia đình, dễ sử dụng, độ chính xác cao.', 
 N'[]', 
 N'N/A', 
 N'Không dùng trong môi trường có điện từ trường mạnh.', 
 N'Hộp 1 máy + 1 vòng bít + 4 pin AA', 
 0, 950000, 890000, 40, 12, 1, 5, 5, N'Admin');