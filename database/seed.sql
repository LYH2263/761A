-- 数据填充脚本
USE bookstore;

-- 设置字符集为UTF-8，确保中文数据正确插入
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- 清空现有数据（如果存在）
DELETE FROM cart_items;
DELETE FROM books;
DELETE FROM users;

-- 重置自增ID
ALTER TABLE users AUTO_INCREMENT = 1;
ALTER TABLE books AUTO_INCREMENT = 1;
ALTER TABLE cart_items AUTO_INCREMENT = 1;

-- 插入测试用户
INSERT INTO users (username, password, email, phone) VALUES
('admin', 'admin123', 'admin@bookstore.com', '13800138000'),
('test', 'test123', 'test@bookstore.com', '13900139000'),
('user1', '123456', 'user1@example.com', '15000150000'),
('张三', 'zhangsan123', 'zhangsan@example.com', '13800138001'),
('李四', 'lisi123', 'lisi@example.com', '13800138002');

-- 插入图书数据（包含中文内容）
INSERT INTO books (title, author, isbn, price, description, image_url, stock) VALUES
('Java编程思想（第4版）', 'Bruce Eckel', '978-7-111-21382-6', 89.00, 'Java编程经典教材，深入浅出地介绍了Java语言的核心概念和编程思想。适合有一定编程基础的读者学习。', 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=300', 50),
('深入理解计算机系统（第3版）', 'Randal E. Bryant', '978-7-111-32133-0', 139.00, '计算机系统领域的经典教材，帮助读者深入理解计算机系统的工作原理。涵盖程序结构、系统级编程等内容。', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300', 30),
('设计模式：可复用面向对象软件的基础', 'Gang of Four', '978-7-111-07575-4', 45.00, '设计模式领域的经典之作，介绍了23种常用的设计模式。包括创建型、结构型和行为型模式。', 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=300', 40),
('算法导论（第3版）', 'Thomas H. Cormen', '978-7-111-40701-0', 128.00, '算法领域的权威教材，全面介绍了算法设计与分析的方法。适合计算机科学专业学生和算法工程师。', 'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=300', 35),
('Spring实战（第5版）', 'Craig Walls', '978-7-115-40878-1', 79.00, 'Spring框架的实战指南，帮助开发者快速掌握Spring开发技术。涵盖Spring Boot、Spring MVC等核心内容。', 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=300', 45),
('MySQL必知必会', 'Ben Forta', '978-7-115-23947-0', 49.00, 'MySQL数据库入门经典，适合初学者快速掌握MySQL的使用。内容简洁实用，易于理解。', 'https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?w=300', 60),
('JavaScript高级程序设计（第4版）', 'Nicholas C. Zakas', '978-7-115-32110-6', 99.00, 'JavaScript开发的权威指南，深入讲解JavaScript的核心概念和高级特性。适合前端开发人员深入学习。', 'https://images.unsplash.com/photo-1516321497487-e288fb19713f?w=300', 55),
('HTTP权威指南', 'David Gourley', '978-7-115-28139-0', 109.00, 'HTTP协议的权威参考书，详细介绍了HTTP协议的工作原理和应用。适合Web开发人员参考。', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300', 25),
('重构：改善既有代码的设计（第2版）', 'Martin Fowler', '978-7-115-48459-6', 69.00, '重构领域的经典之作，介绍了如何改善代码质量和可维护性。包含大量重构技巧和最佳实践。', 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=300', 38),
('代码整洁之道', 'Robert C. Martin', '978-7-115-20277-0', 59.00, '软件工程领域的经典书籍，讲述了如何编写整洁、可维护的代码。强调代码质量和编程规范。', 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=300', 42),
('Java并发编程实战', 'Brian Goetz', '978-7-111-34078-1', 69.00, 'Java并发编程的权威指南，深入讲解多线程编程、并发集合、线程安全等核心概念。', 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=300', 33),
('Effective Java（第3版）', 'Joshua Bloch', '978-7-115-48558-6', 89.00, 'Java编程最佳实践指南，包含90条实用的编程建议。帮助开发者编写更高效、更安全的Java代码。', 'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=300', 28);
