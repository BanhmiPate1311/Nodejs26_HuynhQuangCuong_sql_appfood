CREATE TABLE users(
	user_id INT PRIMARY KEY AUTO_INCREMENT,
	full_name VARCHAR(255),	
	email VARCHAR(255),
	password VARCHAR(255)
);

-- thêm data vào table users
INSERT INTO users(full_name, email, password)
VALUES 
		("Roronoa Zoro","zoro@gmail.com","123456"),
		("Sanji","sanji@gmail.com","123456"),
		("Tony Chopper","chopper@gmail.com","123456"),
		("Nami","nami@gmail.com","123456"),
		("Nico Robin","robin@gmail.com","123456"),
		("Usopp","usopp@gmail.com","123456"),
		("Luffi","luffi@gmail.com","123456");

CREATE TABLE restaurants(
	res_id INT PRIMARY KEY AUTO_INCREMENT,
	res_name VARCHAR(255),	
	image VARCHAR(255),
	`desc` VARCHAR(255)
);

-- thêm data vào table restaurants
INSERT INTO restaurants(res_name, image, `desc`)
VALUES 
		("KoCoChi","https://sp-ao.shortpixel.ai/client/to_webp,q_glossy,ret_img,w_1080,h_1349/https://gauoi.vn/wp-content/uploads/2021/kichi-kichi/gauoi-kichi-kichi-1.jpg","được"),
		("Haidilao","https://zentahotel.com.vn/wp-content/uploads/lau-haidilao-960x570.jpeg","mắc"),
		("Hotpot Story","https://statics.vincom.com.vn/xu-huong/chi_tiet_xu_huong/quan-lau/hotpot-story-buffet-lau-han-nhat-thai.jpg","cũng được"),
		("Manwah Taiwanese Hotpot","https://statics.vincom.com.vn/xu-huong/chi_tiet_xu_huong/quan-lau/manwah-mon-lau-truyen-thong-dai-loan.jpg","mắc lắm"),
		("Lẩu Mắm Bà Dú","https://statics.vincom.com.vn/xu-huong/chi_tiet_xu_huong/quan-lau/lau-mam-ba-du-lau-mam-chuan-vi-mien-tay.jpg","chưa ăn"),
		("Lẩu gà úp","https://statics.vincom.com.vn/xu-huong/chi_tiet_xu_huong/quan-lau/quan-lau-ga-up.jpg","chưa ăn");

CREATE TABLE rate_res(
	user_id INT,
	res_id INT,
	FOREIGN KEY (user_id) REFERENCES users(user_id),
	FOREIGN KEY (res_id) REFERENCES restaurant(res_id),	
	amount INT,
	date_rate DATETIME
);

-- thêm data vào table rate_res
INSERT INTO rate_res(user_id, res_id, amount, date_rate)
VALUES 
		(1,1,5,"2022-04-01"),
		(1,2,5,"2022-04-02"),
		(2,1,5,"2022-04-03");

CREATE TABLE like_res(
	user_id INT,
	res_id INT,
	FOREIGN KEY (user_id) REFERENCES users(user_id),
	FOREIGN KEY (res_id) REFERENCES restaurants(res_id),	
	date_like DATETIME
);

-- thêm data vào table like_res
INSERT INTO like_res(user_id, res_id, date_like)
VALUES 
		(1,1,"2022-04-01"),
		(1,2,"2022-04-02"),
		(2,1,"2022-04-03"),
		(3,2,"2022-04-01"),
		(5,3,"2022-04-03"),
		(6,3,"2022-04-06"),
		(7,2,"2022-04-03");

CREATE TABLE food_types(
	type_id INT PRIMARY KEY AUTO_INCREMENT,
	type_name VARCHAR(255)
);

-- thêm data vào table food_types
INSERT INTO food_types(type_name) 
VALUES
	("thịt gà"),
	("thịt bò"),
	("thịt heo");
	
CREATE TABLE foods(
	food_id INT PRIMARY KEY AUTO_INCREMENT,
	food_name VARCHAR(255),
	image VARCHAR(255),
	price FLOAT,
	`desc` VARCHAR(255),
	type_id INT,
	FOREIGN KEY (type_id) REFERENCES food_types(type_id)
);

-- thêm data vào table foods
INSERT INTO foods(food_name, image, price, `desc`, type_id)
VALUES 
		("lẩu bò","https://cdn.beptruong.edu.vn/wp-content/uploads/2021/03/lau-bo.jpg",10.000,"nhúng bò dô lẩu",2),
		("gà chiên","chicken.rpg",20.500,"đem gà đi chiên",1),
		("lẩu heo","heo.rpg",10.200,"heo nhúng lẩu",3),
		("lẩu xí quách","xiquach.rpg",18.300,"hết xí quách",3),
		("gà nhúng dấm","gaqua.rpg",12.100,"hết dấm",1);
		

CREATE TABLE orders(
	user_id INT,
	food_id INT,
	FOREIGN KEY (user_id) REFERENCES users(user_id),
	FOREIGN KEY (food_id) REFERENCES foods(food_id),	
	amount INT,
	code VARCHAR(255),
	arr_sub_id VARCHAR(255)
);

-- thêm data vào table orders
INSERT INTO orders(user_id, food_id, amount, code, arr_sub_id) 
VALUES
	(1,1,2,"c","c1"),
	(1,3,1,"p","p3"),
	(2,1,2,"c","c1"),
	(2,4,1,"b","b4"),
	(2,3,2,"p","p3")
	,(3,1,1,"c","c1");

CREATE TABLE sub_foods(
	sub_id INT PRIMARY KEY AUTO_INCREMENT,
	sub_name VARCHAR(255),
	sub_price VARCHAR(255),
	food_id INT,	
	FOREIGN KEY (food_id) REFERENCES foods(food_id)
);

-- thêm data vào table sub_foods
INSERT INTO sub_foods(sub_name, sub_price, food_id) 
VALUES
	("bánh mì",2.500,1),
	("bánh mì ngọt",2.200,3),
	("nước chấm",2.500,4);

-- YC: Tìm 5 người like nhà hàng nhiều nhất
SELECT users.user_id, users.full_name, COUNT(like_res.user_id) as total_like
FROM users
INNER JOIN like_res
ON users.user_id = like_res.user_id
INNER JOIN restaurants
ON restaurants.res_id = like_res.res_id
GROUP BY users.user_id, users.full_name
ORDER BY total_like DESC
LIMIT 5;

-- YC: Tìm 2 nhà hàng có lượt like nhiều nhất
SELECT restaurants.res_id, restaurants.res_name, COUNT(like_res.res_id) as total_like
FROM restaurants
INNER JOIN like_res
ON restaurants.res_id = like_res.res_id
INNER JOIN users
ON users.user_id = like_res.user_id
GROUP BY restaurants.res_id, restaurants.res_name
ORDER BY total_like DESC
LIMIT 2;

-- YC: Tìm người đặt hàng nhiều nhất
SELECT users.user_id, users.full_name, COUNT(orders.user_id) AS total_order
FROM users
INNER JOIN orders
ON users.user_id = orders.user_id
INNER JOIN foods
ON foods.food_id = orders.food_id
GROUP BY users.user_id, users.full_name
ORDER BY total_order DESC
LIMIT 1;

-- YC: Tìm người dùng không hoạt động trong hệ thống (ko order, ko like, ko rate)
SELECT * FROM users WHERE user_id 
NOT IN(
SELECT users.user_id 
FROM like_res 
INNER JOIN users 
ON users.user_id = like_res.user_id 
LEFT JOIN rate_res
ON users.user_id = rate_res.user_id);

-- YC: Tính trung bình sub_food của một food
SELECT 1/COUNT(sub_foods.sub_id) AS trung_binh 
FROM foods 
INNER JOIN sub_foods 
ON foods.food_id = sub_foods.food_id;

SELECT *
FROM restaurants
INNER JOIN like_res
ON restaurants.res_id = like_res.res_id;

SET FOREIGN_KEY_CHECKS=0; DROP TABLE like_res; SET FOREIGN_KEY_CHECKS=1;
ALTER TABLE users AUTO_INCREMENT = 1;
SELECT * FROM restaurants;