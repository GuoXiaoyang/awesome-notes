## 性能的重要性

关于用户体验（包括用户使用成本）、业务转化率、用户去留以及  SEO 等。

## 性能评估

RAIL 模型：

- 立即响应用户 Response：在 100 毫秒以内确认用户输入。
- 设置动画或滚动时 Animation：在 10 毫秒以内生成帧。
- Idle： 最大程度增加主线程的空闲时间。
- 持续吸引用户 Load：在 1000 毫秒以内呈现交互内容。

## 性能测试工具

无论是单一的维度、单一的环境还是开发者的单一测试流程，实际上都是类似于实验室数据，不能全方位代表网站的实际性能。网站性能首先不能脱离用户环境来衡量，其次是由多项数据来决定的，我们平时谈的性能问题必须要具化后才能够针对性的解决。

模拟测试数据与真实数据存在以下区别：

- 模拟测试(代表工具有 [Lighthouse](https://developers.google.com/web/tools/lighthouse/)、[WebPageTest](https://www.webpagetest.org/)、Chrome  DevTools)
  - 能够实现对 UI 端到端的深度测试
  - 方便调试和复现性能问题
  - 较难触到真实环境的瓶颈
  - 不能与真实页面的一些 KPI 指标进行关联
- 真实环境测试(代表工具有 [PageSpeed Insights](https://developers.google.com/speed/pagespeed/insights/)、[Test My Site](https://testmysite.thinkwithgoogle.com/))
  - 能够体现真实用户体验
  - 与业务指标关联
  - 测试指标有限
  - 调试难度会增加

## 性能分析指标

### 传统指标

- **DOMContentLoaded(DCL) Event** 
  当初始的 HTML 文档被完全加载和解析完成之后，DOMContentLoaded 事件被触发，而无需等待样式表、图像和子框架的完成加载。值得注意的是，DOMContentLoaded 事件必须等待其所属 script 之前的样式表加载解析完成才会触发。
- **Onload(L) Event** 
  事件在页面完全加载后触发，此时用户已经可以使用页面或应用。

### 渐进式网页指标（Progressive Web Metrics）

![](http://cdn.guoxiaoyang.xyz/6d5155ba662cf77dc76d5dcdff05b077.jpg)

- **[首次绘制（First Paint，FP）](https://github.com/w3c/paint-timing)** 
  标记浏览器渲染任何在视觉上不同于导航前屏幕内容之内容(可以理解为白屏)的时间点。

- **[首次内容绘制（First Contentful Paint，FCP）](https://github.com/w3c/paint-timing)** 
  标记的是浏览器渲染来自 DOM 第一位内容的时间点，该内容可能是文本、图像、SVG 甚至`<canvas>`元素。

- **首次有效绘制（First Meaningful Paint，FMP）** 
  指页面主要内容出现在屏幕上的时间点，比如博客的标题和文本、电子商务产品中重要的图片等；**FMP = 最大布局变化时的绘制**。

- **[最大内容绘制（Largest Contentful Paint， LCP）](https://web.dev/largest-contentful-paint)** 
  Chrome 77 引入该指标，指明页面变化最大(布局或者文本、图像插入等)时的时间节点。

- **预计输入延迟（Estimated Input Latency）** 
  浏览器主线程在处理每个**长任务（长于 50ms 的任务）**时，用户输入会被阻塞，单个任务中阻塞的最长时间就是预计输入延迟。

- **最大预计输入延迟（Estimated Input Latency）** 
  也就是最长的长任务时间。

- **[首次输入延迟（First Input Delay，FID）](https://developers.google.com/web/updates/2018/05/first-input-delay?utm_source=lighthouse&utm_medium=devtools)** 
  第一次长任务时间。

- **首次可交互时间（Time to First Interactive，TTFI） **
  **FMP** 发生后如果存在仅有**独立任务**的**安静时间窗口**，该时间窗口足够用户交互，则该时间窗口的起始时间节点就是 **TTFI**。

  > 独立任务：将 250ms 中执行的多个任务视为一个任务，当一个任务距离 FMP 很远才执行，且在这个任务前后均有一个 1 秒的安静期，则其为一个“独立任务”。举例来说，这个任务可能是第三方广告或者分析脚本。

  ![](http://cdn.guoxiaoyang.xyz/a5fcacdc27daebbfbe9e5db1bd006c7d.jpg)

- **持续可交互时间（Time To Consistently Interactive，TTCI）** 目前也称为**可交互时间（Time To Interactive，TTI）**

  用于标记应用已进行视觉渲染并能可靠响应用户输入的时间点。 应用可能会因为多种原因而无法响应用户输入：

  - 页面组件运行所需的 JavaScript 尚未加载。
  - 耗时较长的任务阻塞主线程（如上一节所述）。

  TTI 指标可识别页面初始 JavaScript 已加载且主线程处于空闲状态（没有耗时较长的任务， 5s 见下图）的时间点。该指标与 **FID** 存在一定的相关性。

  ![](http://cdn.guoxiaoyang.xyz/1cb8ba6b658d2b4c2231db3eede4dacc.jpg)

  使用逆序分析，从追踪线的尾端开始看，发现页面加载活动保持了 5 秒的安静并且再无更多的长任务执行，得到了一段叫做安静窗口的时期。安静窗口之后的第一个长任务（从结束时间向前开始算）之前的时间点就是 TTCI（这里是将整个时间线反转过来看的，实际表示的是安静窗口前，最接近安静窗口的长任务的结束时间）。

- [**速度指数（Speed Index）**](https://sites.google.com/a/webpagetest.org/docs/using-webpagetest/metrics/speed-index) 
  展示填充页面内容的速度，即视觉上完成渲染结果速度的中值。速度指数的值越小，性能就越好。

- **[CPU最快空闲时间（First CPU Idle）](https://developers.google.com/web/tools/lighthouse/audits/first-cpu-idle)** 
  表征页面最能够进行最小交互的时间节点

## 性能提升方法

### 请求资源

资源更多涉及到页面的首屏性能，可以优化的方向有：

- 资源请求数量

  - 关键脚本或者样式考虑内联
  - 懒加载（如 Intersection Observer）非首屏图片等资源来减少网络请求
  - JS脚本异步加载：defer、async、动态创建script标签、使用XHR异步请求JS代码并注入到页面

- 资源请求方式

  - http → http2，HTTP/2 可解决 HTTP/1.1 的许多固有性能问题，例如并发请求限制和缺乏标头压缩。

  - [资源提示（Resource Hints）](https://w3c.github.io/resource-hints/)
    虽然使用服务工作线程预先缓存脚本是提高应用程序加载性能的一种方法，但应将其视为一种渐进增强(属于PWA)的方式。如果没办法使用它，您可能需要考虑预提取或预加载代码块。

    1. **`rel=dns-prefetch`** 可以指定一个用于获取资源所需的源（origin），并提示浏览器应该尽可能早的解析。

    2. **`rel=preconnect`** 告知浏览器您的页面打算与另一个起点建立连接，以及您希望尽快启动该过程，也就是启动预链接，其中包含DNS查找，TCP握手，以及可选的TLS协议，允许浏览器减少潜在的建立连接的开销。 在速度较慢的网络中建立连接通常非常耗时，尤其是要建立安全连接时，因为这一过程可能涉及 DNS 查询、重定向以及指向处理用户请求的最终服务器的若干往返。 提前处理好上述事宜将使您的应用提供更加流畅的用户体验，且不会为带宽的使用带来负面影响。 建立连接所消耗的时间大部分用于等待而不是交换数据。

    3. **`rel=prefetch`** 是对以后要使用的非关键资源的低优先级提取。当浏览器空闲时，会发起请求。
       这一过程的实现方式是通过告知浏览器未来导航或用户互动将需要的资源，例如，如果用户做出我们期望的行为，则表示其可能稍后才需要某资源。 当前页面完成加载后，且带宽可用的情况下，这些资源将在 Chrome 中以 **Lowest** 优先级被提取。
       这意味着，**`prefetch`** 最适合抢占用户下一步可能进行的操作并为其做好准备。

    4. **`rel=prerender`** 用于标识下一个导航可能需要的资源。浏览器会获取并执行，一旦将来请求该资源，浏览器可以提供更快的响应。

    5. **`rel=preload`** 告知浏览器当前导航需要某个资源，应尽快开始提取，优先级一般较高。

       - 将加载和执行分离开，可不阻塞渲染和 document 的 onload 事件
       - 提前加载指定资源，不再出现依赖的font字体隔了一段时间才刷出

       **`rel=prefetch`** 和 **`rel=preload`** 都是在浏览器之前获取指定资源的资源提示，可以通过屏蔽延迟来提高加载性能。尽管乍一看它们非常相似，但它们的表现却截然不同：

       - preload 是告诉浏览器页面**必定**需要的资源，浏览器**一定会**加载这些资源；
       - prefetch 是告诉浏览器页面**可能**需要的资源，浏览器**不一定会**加载这些资源。

    [Webpack 中的资源预加载](https://medium.com/webpack/link-rel-prefetch-preload-in-webpack-51a52358f84c)

  - [Client hints](http://httpwg.org/http-extensions/client-hints.html) 可以根据当前网络条件和设备特性定制资源交付。 **`DPR`**、**`Width`** 和  **`Viewport-Width`** 标头可以帮助您[使用服务器端代码提供适合设备的最佳图像*并*提供更少标记](https://developers.google.com/web/updates/2015/09/automating-resource-selection-with-client-hints)。 **`Save-Data`** 标头可以帮助您[为有特定需求的用户提供负荷更轻的应用体验](https://developers.google.com/web/updates/2016/02/save-data)。

- 资源体积或速度优化

  - 移除不必要的资源开销 非关键 css 指定 media meta等
  - code splitting、tree shaking
  - minify js代码和 svg 文件
  - 服务端压缩
  - 优化图像、提供响应式图像
  - 使用视频替代 GIF
  - **`[NetworkInformation`**API](https://developer.mozilla.org/en-US/docs/Web/API/NetworkInformation) 可显示有关用户网络连接的信息。 此类信息可用于调整网速较慢用户的应用体验。
  - 服务端渲染
  - 缓存资源
  - CDN 内容分发

## 优化策略

**待补充**

## 参考

1. [Lighthouse 评分文档](https://github.com/GoogleChrome/lighthouse/blob/master/docs/scoring.md)
2. [Chrome官方文档](https://developers.google.com/web/fundamentals/performance/get-started)
3. [web.dev](https://web.dev/learn)
4. [性能分析指标都是什么鬼](https://github.com/xitu/gold-miner/blob/master/TODO/performance-metrics-whats-this-all-about.md)
5. [用 preload 预加载页面资源](https://juejin.im/post/5a7fb09bf265da4e8e785c38)

