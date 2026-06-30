<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="com.bookstore.model.CartItem" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>购物车 - 线上书店</title>
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
                    <div class="relative">
                        <input type="text" id="searchCartId" placeholder="搜索ID/书名/作者" 
                               class="border border-gray-300 rounded-lg px-4 py-2 pr-10 focus:outline-none focus:ring-2 focus:ring-purple-600"
                               onkeypress="if(event.key === 'Enter') searchCartItem()">
                        <button onclick="searchCartItem()" class="absolute right-2 top-1/2 transform -translate-y-1/2 text-purple-600 hover:text-purple-700">
                            🔍
                        </button>
                    </div>
                    <span class="text-gray-700">欢迎，<%= session.getAttribute("username") %></span>
                    <a href="${pageContext.request.contextPath}/books" class="bg-purple-600 text-white px-4 py-2 rounded-lg hover:bg-purple-700 transition-all">
                        继续购物
                    </a>
                    <a href="${pageContext.request.contextPath}/logout" class="bg-gray-200 text-gray-700 px-4 py-2 rounded-lg hover:bg-gray-300 transition-all">
                        退出
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pb-8">
        <h1 class="text-3xl font-bold text-gray-800 mb-8 text-center">我的购物车</h1>
        
        <%
            List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
            if (cartItems == null || cartItems.isEmpty()) {
        %>
            <div class="bg-white rounded-xl shadow-lg p-12 text-center">
                <div class="text-6xl mb-4">🛒</div>
                <p class="text-gray-500 text-lg mb-6">购物车是空的</p>
                <a href="${pageContext.request.contextPath}/books" 
                   class="inline-block bg-gradient-to-r from-purple-600 to-blue-600 text-white px-6 py-3 rounded-lg hover:from-purple-700 hover:to-blue-700 transition-all font-semibold">
                    去购物
                </a>
            </div>
        <%
            } else {
                BigDecimal total = BigDecimal.ZERO;
                for (CartItem item : cartItems) {
                    total = total.add(item.getSubtotal());
                }
        %>
            <div class="bg-white rounded-xl shadow-lg overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full">
                        <thead class="bg-gray-50">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">购物车ID</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">图书信息</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">单价</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">数量</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">小计</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">操作</th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                            <%
                                for (CartItem item : cartItems) {
                                    Integer itemId = item.getId();
                                    // 如果 itemId 为 null 或无效，跳过该项（这种情况不应该发生，但为了安全起见）
                                    if (itemId == null || itemId <= 0) {
                                        continue; // 跳过无效项
                                    }
                            %>
                                <tr class="cart-item-row" data-cart-item-id="<%= itemId %>">
                                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-purple-600">
                                        #<%= itemId %>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <div class="flex items-center">
                                            <div class="h-16 w-16 bg-gray-200 rounded-lg mr-4 flex items-center justify-center overflow-hidden">
                                                <%
                                                    if (item.getBook() != null && item.getBook().getImageUrl() != null && !item.getBook().getImageUrl().isEmpty()) {
                                                %>
                                                    <img src="<%= item.getBook().getImageUrl() %>" alt="<%= item.getBook().getTitle() %>" 
                                                         class="h-full w-full object-cover">
                                                <%
                                                    } else {
                                                %>
                                                    <div class="text-gray-400 text-2xl">📚</div>
                                                <%
                                                    }
                                                %>
                                            </div>
                                            <div>
                                                <div class="text-sm font-medium text-gray-900">
                                                    <%= item.getBook() != null ? item.getBook().getTitle() : "" %>
                                                </div>
                                                <div class="text-sm text-gray-500">
                                                    作者：<%= item.getBook() != null ? item.getBook().getAuthor() : "" %>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                        ¥<%= item.getBook() != null ? item.getBook().getPrice() : "0.00" %>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <div class="flex items-center space-x-2">
                                            <button onclick="decreaseQuantity(this)" data-cart-item-id="<%= itemId %>"
                                                    class="w-8 h-8 bg-gray-200 hover:bg-gray-300 rounded-lg text-gray-700 font-bold transition-all">
                                                -
                                            </button>
                                            <span class="text-sm font-medium text-gray-900 w-12 text-center" id="quantity-display-<%= itemId %>">
                                                <%= item.getQuantity() %>
                                            </span>
                                            <button onclick="increaseQuantity(this)" data-cart-item-id="<%= itemId %>"
                                                    class="w-8 h-8 bg-gray-200 hover:bg-gray-300 rounded-lg text-gray-700 font-bold transition-all">
                                                +
                                            </button>
                                        </div>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900 subtotal" 
                                        data-subtotal="<%= item.getSubtotal() %>">
                                        ¥<%= item.getSubtotal() %>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <button onclick="deleteItem(this)" data-cart-item-id="<%= itemId %>"
                                                class="bg-red-500 hover:bg-red-600 text-white px-4 py-2 rounded-lg transition-all">
                                            删除
                                        </button>
                                    </td>
                                </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
                <div class="bg-gray-50 px-6 py-4 flex justify-between items-center">
                    <div>
                        <button type="button" onclick="clearCart()" 
                                class="bg-red-500 text-white px-6 py-2 rounded-lg hover:bg-red-600 transition-all font-semibold">
                            清空购物车
                        </button>
                    </div>
                    <div class="text-right">
                        <div class="text-sm text-gray-500 mb-1">总计</div>
                        <div class="text-3xl font-bold text-purple-600" id="totalPrice">¥<%= total %></div>
                    </div>
                </div>
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

    <!-- 自定义确认弹窗 -->
    <div id="confirmModal" class="hidden fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center">
        <div class="bg-white rounded-xl shadow-2xl p-6 max-w-md w-full mx-4 transform transition-all">
            <h3 class="text-xl font-bold text-gray-800 mb-4">确认操作</h3>
            <p id="confirmMessage" class="text-gray-600 mb-6"></p>
            <div class="flex justify-end space-x-3">
                <button onclick="closeConfirmModal(false)" 
                        class="px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition-all">
                    取消
                </button>
                <button onclick="closeConfirmModal(true)" 
                        class="px-4 py-2 bg-red-500 text-white rounded-lg hover:bg-red-600 transition-all">
                    确认
                </button>
            </div>
        </div>
    </div>

    <script>
        // 获取应用上下文路径
        const contextPath = '${pageContext.request.contextPath}';
        let confirmCallback = null;
        
        // 自定义确认弹窗
        function showConfirmModal(message) {
            return new Promise((resolve) => {
                const modal = document.getElementById('confirmModal');
                const messageElement = document.getElementById('confirmMessage');
                messageElement.textContent = message;
                modal.classList.remove('hidden');
                confirmCallback = resolve;
            });
        }
        
        function closeConfirmModal(confirmed) {
            const modal = document.getElementById('confirmModal');
            modal.classList.add('hidden');
            if (confirmCallback) {
                confirmCallback(confirmed);
                confirmCallback = null;
            }
        }
        
        // 搜索购物车项（支持ID和商品名字）
        function searchCartItem() {
            const searchText = document.getElementById('searchCartId').value.trim().toLowerCase();
            if (!searchText) {
                showToast('请输入搜索内容', true);
                return;
            }
            
            const rows = document.querySelectorAll('tr.cart-item-row');
            let found = false;
            let foundItems = [];
            
            rows.forEach(row => {
                // 获取购物车ID
                const itemId = row.getAttribute('data-cart-item-id');
                
                // 获取商品名称（从第二列的图书信息中提取）
                const bookTitleElement = row.querySelector('td:nth-child(2) .text-sm.font-medium');
                const bookTitle = bookTitleElement ? bookTitleElement.textContent.trim().toLowerCase() : '';
                
                // 获取作者信息
                const authorElement = row.querySelector('td:nth-child(2) .text-sm.text-gray-500');
                const author = authorElement ? authorElement.textContent.trim().toLowerCase() : '';
                
                // 检查是否匹配：ID、书名或作者
                if (itemId === searchText || 
                    bookTitle.includes(searchText) || 
                    author.includes(searchText)) {
                    
                    // 滚动到该项并高亮
                    row.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    row.style.backgroundColor = '#fef3c7';
                    row.style.transition = 'background-color 0.3s';
                    
                    setTimeout(() => {
                        row.style.backgroundColor = '';
                    }, 2000);
                    
                    foundItems.push({
                        id: itemId,
                        title: bookTitleElement ? bookTitleElement.textContent.trim() : '未知'
                    });
                    found = true;
                }
            });
            
            if (!found) {
                showToast('未找到匹配的商品', true);
            } else {
                if (foundItems.length === 1) {
                    showToast('已定位到: ' + foundItems[0].title, false);
                } else {
                    showToast('找到 ' + foundItems.length + ' 个匹配项', false);
                }
            }
        }
        
        // 增加数量
        function increaseQuantity(button) {
            console.log('increaseQuantity 被调用', button);
            
            // 首先尝试从按钮本身获取 ID
            let itemId = button.getAttribute('data-cart-item-id');
            console.log('从按钮获取到的 itemId =', itemId);
            
            // 如果按钮上没有，尝试从父行元素获取（备用方案）
            if (!itemId || itemId === 'null' || itemId === 'undefined' || itemId === '') {
                console.log('按钮上没有找到有效的 itemId，尝试从父行元素获取');
                const row = button.closest('tr.cart-item-row');
                if (row) {
                    itemId = row.getAttribute('data-cart-item-id');
                    console.log('从父行元素获取到的 itemId =', itemId);
                }
            }
            
            if (!itemId || itemId === 'null' || itemId === 'undefined' || itemId === '') {
                console.error('无法获取购物车项ID，按钮:', button);
                showToast('无法获取购物车项ID', true);
                return;
            }
            
            const quantityDisplay = document.getElementById('quantity-display-' + itemId);
            console.log('quantityDisplay 元素 =', quantityDisplay);
            
            if (!quantityDisplay) {
                console.error('找不到数量显示元素: quantity-display-' + itemId);
                showToast('找不到数量显示元素', true);
                return;
            }
            
            const currentQty = parseInt(quantityDisplay.textContent);
            console.log('当前数量 =', currentQty);
            
            if (isNaN(currentQty)) {
                console.error('无法解析当前数量');
                showToast('数量格式错误', true);
                return;
            }
            
            updateQuantity(itemId, currentQty + 1);
        }
        
        // 减少数量
        function decreaseQuantity(button) {
            console.log('decreaseQuantity 被调用', button);
            
            // 首先尝试从按钮本身获取 ID
            let itemId = button.getAttribute('data-cart-item-id');
            console.log('从按钮获取到的 itemId =', itemId);
            
            // 如果按钮上没有，尝试从父行元素获取（备用方案）
            if (!itemId || itemId === 'null' || itemId === 'undefined' || itemId === '') {
                console.log('按钮上没有找到有效的 itemId，尝试从父行元素获取');
                const row = button.closest('tr.cart-item-row');
                if (row) {
                    itemId = row.getAttribute('data-cart-item-id');
                    console.log('从父行元素获取到的 itemId =', itemId);
                }
            }
            
            if (!itemId || itemId === 'null' || itemId === 'undefined' || itemId === '') {
                console.error('无法获取购物车项ID，按钮:', button);
                showToast('无法获取购物车项ID', true);
                return;
            }
            
            const quantityDisplay = document.getElementById('quantity-display-' + itemId);
            console.log('quantityDisplay 元素 =', quantityDisplay);
            
            if (!quantityDisplay) {
                console.error('找不到数量显示元素: quantity-display-' + itemId);
                showToast('找不到数量显示元素', true);
                return;
            }
            
            const currentQty = parseInt(quantityDisplay.textContent);
            console.log('当前数量 =', currentQty);
            
            if (isNaN(currentQty)) {
                console.error('无法解析当前数量');
                showToast('数量格式错误', true);
                return;
            }
            
            if (currentQty > 1) {
                updateQuantity(itemId, currentQty - 1);
            } else {
                showToast('数量不能少于1，如需删除请点击删除按钮', true);
            }
        }
        
        // 重新计算总价
        function updateTotalPrice() {
            const rows = document.querySelectorAll('tr.cart-item-row');
            let total = 0;
            rows.forEach(row => {
                // 小计在索引4的位置（ID0，图书信息1，单价2，数量3，小计4，操作5）
                const subtotalCell = row.querySelectorAll('td')[4];
                if (subtotalCell) {
                    const subtotalText = subtotalCell.textContent.trim().replace('¥', '');
                    const subtotal = parseFloat(subtotalText);
                    if (!isNaN(subtotal)) {
                        total += subtotal;
                    }
                }
            });
            const totalPriceElement = document.getElementById('totalPrice');
            if (totalPriceElement) {
                totalPriceElement.textContent = '¥' + total.toFixed(2);
            }
        }
        
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

        async function updateQuantity(cartItemId, quantity) {
            console.log('=== updateQuantity 开始 ===');
            console.log('参数 cartItemId =', cartItemId, '类型:', typeof cartItemId);
            console.log('参数 quantity =', quantity, '类型:', typeof quantity);
            
            // 确保 cartItemId 是有效的数字
            if (cartItemId == null || cartItemId === undefined || cartItemId === 'null' || cartItemId === 'undefined' || cartItemId === '') {
                console.error('❌ 购物车项ID不能为空！cartItemId =', cartItemId);
                showToast('购物车项ID不能为空', true);
                return;
            }
            
            const itemId = parseInt(cartItemId);
            console.log('解析后的 itemId =', itemId, '类型:', typeof itemId);
            
            if (isNaN(itemId) || itemId <= 0) {
                console.error('❌ 无效的购物车项ID！原始值:', cartItemId, '解析后:', itemId);
                showToast('无效的购物车项ID', true);
                return;
            }
            
            const qty = parseInt(quantity);
            console.log('解析后的 qty =', qty, '类型:', typeof qty);
            
            if (isNaN(qty) || qty < 0) {
                console.error('❌ 无效的数量！原始值:', quantity, '解析后:', qty);
                showToast('无效的数量', true);
                return;
            }

            // 获取当前UI状态，用于失败时回滚
            // 使用字符串拼接（避免JSP解析EL表达式）
            const row = document.querySelector('tr.cart-item-row[data-cart-item-id="' + itemId + '"]');
            console.log('找到的行元素:', row);
            console.log('itemId值:', itemId);
            console.log('选择器字符串:', 'tr.cart-item-row[data-cart-item-id="' + itemId + '"]');
            
            let oldSubtotal = null;
            let oldTotal = null;
            
            // 获取当前数量显示（数量列是第4列，索引为3：ID0，图书信息1，单价2，数量3，小计4，操作5）
            let oldQty = null;
            const quantityDisplay = document.getElementById('quantity-display-' + itemId);
            if (quantityDisplay) {
                oldQty = parseInt(quantityDisplay.textContent.trim()) || 1;
            }
            if (row) {
                const subtotalCell = row.querySelectorAll('td')[4];
                if (subtotalCell) {
                    oldSubtotal = subtotalCell.textContent;
                }
            }
            const totalPriceElement = document.getElementById('totalPrice');
            if (totalPriceElement) {
                oldTotal = totalPriceElement.textContent;
            }

            // 乐观更新：立即更新UI
            if (qty === 0) {
                // 删除该项
                if (row) {
                    row.style.opacity = '0.5';
                    row.style.pointerEvents = 'none';
                }
            } else {
                // 更新数量显示
                if (quantityDisplay) {
                    quantityDisplay.textContent = qty;
                }
                
                // 更新小计：从同一行的单价计算
                if (row) {
                    // 获取单价（从第三个td，索引为2：ID0，图书信息1，单价2，数量3，小计4，操作5）
                    const priceCell = row.querySelectorAll('td')[2];
                    if (priceCell) {
                        const priceText = priceCell.textContent.trim().replace('¥', '');
                        const price = parseFloat(priceText);
                        if (!isNaN(price)) {
                            const subtotal = (price * qty).toFixed(2);
                            
                            // 更新小计显示（第五个td，索引为4）
                            const subtotalCell = row.querySelectorAll('td')[4];
                            if (subtotalCell) {
                                subtotalCell.textContent = '¥' + subtotal;
                                subtotalCell.setAttribute('data-subtotal', subtotal);
                            }
                            
                            // 立即更新总价
                            updateTotalPrice();
                        }
                    }
                }
            }

            try {
                // 再次确认 itemId 和 qty 是有效的数字
                if (!Number.isInteger(itemId) || itemId <= 0) {
                    console.error('❌ 发送请求前检查失败：itemId 无效！', itemId);
                    showToast('系统错误：购物车项ID无效', true);
                    return;
                }
                if (!Number.isInteger(qty) || qty < 0) {
                    console.error('❌ 发送请求前检查失败：qty 无效！', qty);
                    showToast('系统错误：数量无效', true);
                    return;
                }
                
                // 使用 URLSearchParams 来正确构造请求体
                const formData = new URLSearchParams();
                formData.append('cartItemId', itemId.toString());
                formData.append('quantity', qty.toString());
                
                const requestBody = formData.toString();
                console.log('✅ 准备发送请求');
                console.log('   URL:', contextPath + '/cart/update');
                console.log('   Body:', requestBody);
                console.log('   cartItemId 值:', itemId);
                console.log('   quantity 值:', qty);
                
                const response = await fetch(contextPath + '/cart/update', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
                    },
                    body: requestBody
                });
                
                if (!response.ok) {
                    throw new Error('HTTP error! status: ' + response.status);
                }
                
                const result = await response.json();
                if (result.success) {
                    if (qty === 0) {
                        // 删除该项
                        if (row) {
                            row.remove();
                        }
                        showToast('已删除', false);
                        
                        // 检查购物车是否为空
                        const remainingRows = document.querySelectorAll('tr.cart-item-row');
                        if (remainingRows.length === 0) {
                            // 购物车为空，刷新页面显示空购物车提示
                            setTimeout(() => {
                                location.reload();
                            }, 1000);
                            return;
                        }
                    } else {
                        // 确保数量显示正确（可能后端返回的数量不同）
                        if (result.quantity !== undefined) {
                            const qtyDisplay = document.getElementById('quantity-display-' + itemId);
                            if (qtyDisplay) {
                                qtyDisplay.textContent = result.quantity;
                            }
                        }
                    }
                    
                    // 更新总价
                    if (result.total) {
                        const totalPriceElement = document.getElementById('totalPrice');
                        if (totalPriceElement) {
                            totalPriceElement.textContent = '¥' + result.total;
                        }
                    }
                    
                    showToast(result.message || '更新成功', false);
                } else {
                    // 回滚UI更改
                    const qtyDisplay = document.getElementById('quantity-display-' + itemId);
                    if (qtyDisplay && oldQty !== null) {
                        qtyDisplay.textContent = oldQty;
                    }
                    if (row && oldSubtotal !== null) {
                        const subtotalCell = row.querySelectorAll('td')[4];
                        if (subtotalCell) {
                            subtotalCell.textContent = oldSubtotal;
                        }
                        row.style.opacity = '';
                        row.style.pointerEvents = '';
                    }
                    if (totalPriceElement && oldTotal !== null) {
                        totalPriceElement.textContent = oldTotal;
                    }
                    showToast(result.message || '更新失败', true);
                }
            } catch (error) {
                console.error('更新购物车失败:', error);
                // 回滚UI更改
                const qtyDisplay = document.getElementById('quantity-display-' + itemId);
                if (qtyDisplay && oldQty !== null) {
                    qtyDisplay.textContent = oldQty;
                }
                if (row && oldSubtotal !== null) {
                    const subtotalCell = row.querySelectorAll('td')[4];
                    if (subtotalCell) {
                        subtotalCell.textContent = oldSubtotal;
                    }
                    row.style.opacity = '';
                    row.style.pointerEvents = '';
                }
                if (totalPriceElement && oldTotal !== null) {
                    totalPriceElement.textContent = oldTotal;
                }
                showToast('网络错误，请稍后重试', true);
            }
        }

        async function deleteItem(buttonElement) {
            console.log('deleteItem 被调用', buttonElement);
            if (!buttonElement) {
                console.error('按钮元素不能为空');
                showToast('操作失败', true);
                return;
            }
            
            const confirmed = await showConfirmModal('确定要删除这项吗？');
            if (!confirmed) {
                return;
            }
            
            const itemIdStr = buttonElement.getAttribute('data-cart-item-id');
            console.log('deleteItem: itemIdStr =', itemIdStr);
            if (!itemIdStr) {
                console.error('找不到购物车项ID', buttonElement);
                showToast('找不到购物车项ID', true);
                return;
            }
            
            const itemId = parseInt(itemIdStr);
            if (isNaN(itemId) || itemId <= 0) {
                console.error('无效的购物车项ID', itemIdStr);
                showToast('无效的购物车项ID', true);
                return;
            }
            
            await updateQuantity(itemId, 0);
        }

        async function clearCart() {
            const confirmed = await showConfirmModal('确定要清空购物车吗？');
            if (!confirmed) {
                return;
            }

            try {
                const response = await fetch(contextPath + '/cart/clear', {
                    method: 'POST'
                });
                
                const result = await response.json();
                if (result.success) {
                    showToast(result.message, false);
                    setTimeout(() => {
                        location.reload();
                    }, 1000);
                } else {
                    showToast(result.message, true);
                }
            } catch (error) {
                showToast('网络错误，请稍后重试', true);
            }
        }
    </script>
</body>
</html>
