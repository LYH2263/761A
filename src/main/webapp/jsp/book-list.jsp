<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="com.bookstore.model.Book" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>图书列表 - 线上书店</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }
    </style>
</head>
<body>
    <nav class="bg-white shadow-lg mb-8">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-center h-16">
                <div class="flex items-center">
                    <a href="${pageContext.request.contextPath}/index.html" class="text-2xl font-bold bg-gradient-to-r from-purple-600 to-blue-600 bg-clip-text text-transparent">
                        线上书店
                    </a>
                </div>
                <div class="flex items-center space-x-4">
                    <%
                        String username = (String) session.getAttribute("username");
                        if (username != null) {
                    %>
                        <span class="text-gray-700">欢迎，<%= username %></span>
                        <a href="${pageContext.request.contextPath}/cart" class="bg-purple-600 text-white px-4 py-2 rounded-lg hover:bg-purple-700 transition-all">
                            购物车
                        </a>
                        <a href="${pageContext.request.contextPath}/logout" class="bg-gray-200 text-gray-700 px-4 py-2 rounded-lg hover:bg-gray-300 transition-all">
                            退出
                        </a>
                    <%
                        } else {
                    %>
                        <a href="${pageContext.request.contextPath}/html/login.html" class="bg-purple-600 text-white px-4 py-2 rounded-lg hover:bg-purple-700 transition-all">
                            登录
                        </a>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>
    </nav>

    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pb-8">
        <h1 class="text-3xl font-bold text-gray-800 mb-8 text-center">图书列表</h1>
        
        <%
            List<Book> books = (List<Book>) request.getAttribute("books");
            if (books == null || books.isEmpty()) {
        %>
            <div class="text-center py-12">
                <p class="text-gray-500 text-lg">暂无图书</p>
            </div>
        <%
            } else {
        %>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
                <%
                    for (Book book : books) {
                %>
                    <div class="bg-white rounded-xl shadow-lg overflow-hidden hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-2 flex flex-col h-full">
                        <div class="h-64 bg-gray-200 flex items-center justify-center overflow-hidden">
                            <%
                                if (book.getImageUrl() != null && !book.getImageUrl().isEmpty()) {
                            %>
                                <img src="<%= book.getImageUrl() %>" alt="<%= book.getTitle() %>" 
                                     class="w-full h-full object-cover">
                            <%
                                } else {
                            %>
                                <div class="text-gray-400 text-4xl">📚</div>
                            <%
                                }
                            %>
                        </div>
                        <div class="p-6 flex flex-col flex-1 min-h-0">
                            <h3 class="text-xl font-bold text-gray-800 mb-2 line-clamp-2"><%= book.getTitle() %></h3>
                            <p class="text-gray-600 mb-2">作者：<%= book.getAuthor() %></p>
                            <p class="text-gray-600 mb-2 text-sm">ISBN：<%= book.getIsbn() %></p>
                            <p class="text-2xl font-bold text-purple-600 mb-4">¥<%= book.getPrice() %></p>
                            <p class="text-gray-500 text-sm mb-4 line-clamp-2"><%= book.getDescription() != null ? book.getDescription() : "" %></p>
                            <p class="text-gray-500 text-sm mb-4">库存：<%= book.getStock() %> 本</p>
                            <%
                                if (username != null) {
                                    Integer bookId = book.getId();
                                    if (bookId != null) {
                            %>
                                <button onclick="addToCart(<%= bookId %>)" 
                                        data-book-id="<%= bookId %>"
                                        class="mt-auto w-full bg-gradient-to-r from-purple-600 to-blue-600 text-white py-2 px-4 rounded-lg hover:from-purple-700 hover:to-blue-700 transition-all duration-200 font-semibold">
                                    加入购物车
                                </button>
                            <%
                                    } else {
                            %>
                                <button disabled 
                                        class="mt-auto w-full bg-gray-300 text-gray-500 py-2 px-4 rounded-lg cursor-not-allowed font-semibold">
                                    图书信息异常
                                </button>
                            <%
                                    }
                                } else {
                            %>
                                <a href="${pageContext.request.contextPath}/html/login.html" 
                                   class="mt-auto block w-full bg-gray-200 text-gray-700 py-2 px-4 rounded-lg hover:bg-gray-300 transition-all duration-200 font-semibold text-center">
                                    登录后购买
                                </a>
                            <%
                                }
                            %>
                        </div>
                    </div>
                <%
                    }
                %>
            </div>
        <%
            }
        %>
    </div>

    <!-- 现代未来感 Toast 提示 -->
    <div id="toast" class="fixed top-6 right-6 hidden z-50 transform transition-all duration-500 ease-out translate-x-full opacity-0">
        <div class="relative backdrop-blur-lg bg-gradient-to-r from-white/20 to-white/10 border border-white/30 rounded-2xl shadow-2xl overflow-hidden min-w-[320px]">
            <!-- 渐变边框效果 -->
            <div class="absolute inset-0 rounded-2xl opacity-50 blur-sm"></div>
            
            <!-- 内容区域 -->
            <div class="relative p-4 flex items-center space-x-4">
                <!-- 图标 -->
                <div id="toastIcon" class="flex-shrink-0 w-10 h-10 rounded-full flex items-center justify-center text-2xl shadow-lg">
                </div>
                
                <!-- 文字内容 -->
                <div class="flex-1">
                    <p id="toastMessage" class="text-white font-medium text-sm leading-relaxed"></p>
                </div>
                
                <!-- 关闭按钮 -->
                <button onclick="hideToast()" class="flex-shrink-0 w-6 h-6 rounded-full bg-white/20 hover:bg-white/30 flex items-center justify-center transition-all text-white text-xs">
                    ✕
                </button>
            </div>
            
            <!-- 进度条 -->
            <div class="absolute bottom-0 left-0 h-1 bg-gradient-to-r from-blue-400 via-purple-400 to-pink-400 transition-all duration-3000 ease-linear" id="toastProgress"></div>
        </div>
    </div>

    <style>
        @keyframes slideIn {
            from {
                transform: translateX(100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }
        
        @keyframes slideOut {
            from {
                transform: translateX(0);
                opacity: 1;
            }
            to {
                transform: translateX(100%);
                opacity: 0;
            }
        }
        
        .toast-show {
            animation: slideIn 0.5s ease-out forwards;
        }
        
        .toast-hide {
            animation: slideOut 0.5s ease-in forwards;
        }
        
        #toast .absolute.inset-0 {
            background: linear-gradient(135deg, rgba(59, 130, 246, 0.3) 0%, rgba(147, 51, 234, 0.3) 50%, rgba(236, 72, 153, 0.3) 100%);
        }
        
        .duration-3000 {
            transition-duration: 3000ms;
        }
    </style>

    <script>
        let toastTimeout;
        
        function showToast(message, isError = false) {
            const toast = document.getElementById('toast');
            const toastMessage = document.getElementById('toastMessage');
            const toastIcon = document.getElementById('toastIcon');
            const toastProgress = document.getElementById('toastProgress');
            
            // 清除之前的定时器
            if (toastTimeout) {
                clearTimeout(toastTimeout);
            }
            
            // 设置内容
            toastMessage.textContent = message;
            
            // 设置图标和背景
            if (isError) {
                toastIcon.innerHTML = '⚠️';
                toastIcon.className = 'flex-shrink-0 w-10 h-10 rounded-full flex items-center justify-center text-2xl bg-gradient-to-br from-red-500 to-pink-500 shadow-lg shadow-red-500/50';
            } else {
                toastIcon.innerHTML = '✓';
                toastIcon.className = 'flex-shrink-0 w-10 h-10 rounded-full flex items-center justify-center text-2xl bg-gradient-to-br from-green-400 to-emerald-500 shadow-lg shadow-green-500/50';
            }
            
            // 重置进度条
            toastProgress.style.width = '100%';
            
            // 显示Toast
            toast.classList.remove('hidden', 'toast-hide');
            toast.classList.add('toast-show');
            
            // 启动进度条动画
            setTimeout(() => {
                toastProgress.style.width = '0%';
            }, 50);
            
            // 3秒后自动隐藏
            toastTimeout = setTimeout(() => {
                hideToast();
            }, 3000);
        }
        
        function hideToast() {
            const toast = document.getElementById('toast');
            const toastProgress = document.getElementById('toastProgress');
            
            toast.classList.remove('toast-show');
            toast.classList.add('toast-hide');
            
            // 动画结束后隐藏
            setTimeout(() => {
                toast.classList.add('hidden');
                toastProgress.style.width = '100%';
            }, 500);
        }

        async function addToCart(bookId) {
            // 参数验证：确保 bookId 是有效的数字
            if (bookId === null || bookId === undefined || bookId === '' || isNaN(bookId) || Number(bookId) <= 0) {
                console.error('无效的图书ID:', bookId);
                showToast('图书ID无效，请刷新页面重试', true);
                return;
            }
            
            // 确保 bookId 是数字类型
            const bookIdNum = Number(bookId);
            
            try {
                // 使用 URLSearchParams 确保参数正确编码
                const params = new URLSearchParams();
                params.append('bookId', bookIdNum.toString());
                params.append('quantity', '1');
                
                const response = await fetch('${pageContext.request.contextPath}/cart/add', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: params.toString()
                });
                
                const result = await response.json();
                if (result.success) {
                    showToast(result.message, false);
                } else {
                    showToast(result.message, true);
                }
            } catch (error) {
                console.error('加入购物车错误:', error);
                showToast('网络错误，请稍后重试', true);
            }
        }
    </script>
</body>
</html>
