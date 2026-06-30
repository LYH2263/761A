# 线上书店系统

## 🛠 技术栈
- Frontend: HTML + CSS (Tailwind) + JavaScript + JSP
- Backend: Java Servlet (Java EE) + JDBC
- Database: MySQL 8.0
- Server: Apache Tomcat 9.0
- Build Tool: Maven 3.9
- Java Version: JDK 1.8

## 🚀 启动指南 (How to Run)

1. 确保 Docker Desktop 已启动。

2. 在根目录执行：
   ```bash
   docker compose up --build
   ```

3. 等待容器启动完成（首次启动可能需要几分钟，需要下载镜像和构建项目）。

4. 访问应用：
   - **前端应用（必须从这里进入）**: 在浏览器打开 **http://localhost:8747** ，然后点击「登录」或「注册」。
   - 数据库: localhost:3747 (user: root / pass: root123)

5. **重要**：请始终从 **http://localhost:8747** 进入首页，再点击「登录」或「注册」。不要直接在地址栏输入 `/login` 或单独打开登录页链接，否则可能出现 404。

## 🧪 测试账号

系统已预置以下测试账号：

- **管理员账号**: admin / 

- **测试账号1**: test / test123
- **测试账号2**: user1 / 123456

## 📋 功能列表

### 已实现功能

1. **用户注册**
   - 用户可以通过用户名、密码、邮箱、手机号注册账号
   - 用户名唯一性校验
   - 参数验证

2. **用户登录**
   - 用户名密码登录
   - Session管理
   - 登录状态保持

3. **图书浏览**
   - 图书列表展示
   - 图书详细信息（标题、作者、ISBN、价格、描述、库存）
   - 图书封面图片展示
   - 支持游客模式浏览

4. **购物车管理** 🎉 已优化
   - **购物车ID搜索**：在购物车页面右上角可根据购物车ID搜索定位商品
   - **购物车ID显示**：每个购物车项都显示唯一的购物车ID
   - **加入购物车**（AJAX实现，无需刷新页面）
   - **查询购物车**：查看当前用户购物车中的所有商品
   - **修改购物车数量**：通过 +/- 按钮实时调整商品数量，AJAX更新总价
   - **删除购物车项**：每行商品配有删除按钮，点击后弹出自定义确认弹窗
   - **清空购物车**：一键清空所有购物车商品，使用自定义确认弹窗
   - **自定义确认弹窗**：替换原生alert/confirm，提供更好的用户体验

5. **退出登录**
   - 清除Session，返回首页

## 🏗 项目结构

```
BookStore/
├── src/main
│   ├── java/com/bookstore/
│   │   ├── servlet/      # Servlet类
│   │   ├── model/        # 实体类
│   │   ├── dao/          # 数据访问层
│   │   └── util/         # 工具类
│   ├── resources/
│   │   ├── db.properties # 数据库配置
│   │   └── logback.xml   # 日志配置
│   └── webapp/
│       ├── css/          # 样式文件
│       ├── js/           # JavaScript文件
│       ├── images/       # 图片资源
│       ├── html/         # HTML文件
│       ├── jsp/          # JSP文件
│       └── WEB-INF/
│           └── web.xml
├── database/
│   ├── init.sql          # 数据库初始化脚本
│   └── seed.sql          # 数据填充脚本
├── Dockerfile
├── docker-compose.yml
├── pom.xml
└── README.md
```

## 🗄 数据库设计

### 用户表 (users)
- id: 主键
- username: 用户名（唯一）
- password: 密码
- email: 邮箱
- phone: 手机号
- created_at: 创建时间

### 图书表 (books)
- id: 主键
- title: 书名
- author: 作者
- isbn: ISBN号（唯一）
- price: 价格
- description: 描述
- image_url: 图片URL
- stock: 库存
- created_at: 创建时间

### 购物车表 (cart_items)
- id: 主键
- user_id: 用户ID（外键）
- book_id: 图书ID（外键）
- quantity: 数量
- created_at: 创建时间
- updated_at: 更新时间

## 🎨 UI/UX 特性

- **现代设计风格**：使用Tailwind CSS实现渐变背景、圆角、阴影等现代UI效果
- **响应式布局**：支持PC端和移动端自适应
- **交互反馈**：按钮hover效果、加载状态提示
- **AJAX交互**：添加购物车、更新购物车数量等操作无需刷新页面
- **Toast提示**：操作成功/失败的用户友好提示

## 🔧 技术亮点

1. **AJAX异步交互**
   - 添加购物车：`AddToCartServlet` 通过AJAX实现，不刷新页面显示结果
   - 更新购物车：`UpdateCartServlet` 通过AJAX更新数量，实时计算总价

2. **Session管理**
   - 用户登录状态通过Session维护
   - 购物车操作需要登录验证

3. **数据库连接池**
   - 使用JDBC连接MySQL数据库
   - 数据库配置外部化（db.properties）

4. **日志系统**
   - 使用SLF4J + Logback实现结构化日志
   - 日志输出到控制台，便于Docker容器查看

5. **错误处理**
   - 完善的参数校验
   - 友好的错误提示
   - 异常捕获和日志记录

## 🐳 Docker 配置说明

- **数据库服务**: MySQL 8.0，端口映射 3747:3306
- **后端服务**: Tomcat 9.0，端口映射 8747:8080
- **数据持久化**: 使用Docker Volume保存数据库数据
- **自动初始化**: 容器启动时自动执行数据库初始化脚本和数据填充脚本

## 📝 开发规范

- 遵循Java Web开发最佳实践
- 使用MVC架构模式（Servlet + JSP + JavaBean）
- 代码注释完整，便于维护
- 统一的错误处理和日志记录

## 🐛 常见问题

**Q: Docker容器启动失败？**  
A: 检查Docker Desktop是否正常运行，确保端口3747和8747未被占用。

**Q: 数据库连接失败？**  
A: 等待数据库容器完全启动（healthcheck通过），通常需要10-30秒。

**Q: 页面无法访问？**  
A: 确保后端容器已启动，访问 http://localhost:8747 查看应用。

**Q: 登录或注册时出现 404 / 访问不了？**  
A: 1) 登录接口已改为 **/auth/login**（因 Tomcat 对路径 `/login` 有保留/冲突会返回 404）。请从首页 **http://localhost:8747** 点击「登录」后提交。2) 若仍 404，请确认从首页进入、且用 Docker 启动且容器已就绪（`docker compose ps` 显示 backend 为 Up）。

**Q: 如何查看日志？**  
A: 使用 `docker compose logs -f backend` 查看后端日志，`docker compose logs -f db` 查看数据库日志。

---

**开发时间**: 2026年1月  
**课程**: Java Web开发技术
