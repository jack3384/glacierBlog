<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>{{.siteInfo.title}}</title>
  <meta name="keywords" content="{{.siteInfo.keywords}}">
  <meta name="description" content="{{.siteInfo.description}}">

  <link rel="stylesheet" href="/static/theme/quest/assets/plugins/bootstrap/css/bootstrap.min.css?ver=2.2" type="text/css" media="all" />
  <link rel="stylesheet" href="/static/theme/quest/assets/plugins/font-awesome/css/font-awesome.min.css?ver=2.2" type="text/css" media="all" />
  <!--<link rel="stylesheet" href="http://fonts.useso.com/css?family=Open+Sans:300,400,600&subset=latin,latin-ext">-->
  <link rel="stylesheet" href="/static/theme/quest/css/style.css?ver=2.2" type="text/css" media="all" />
  <link rel="stylesheet" href="/static/theme/quest/css/customizer.css?ver=2.2" type="text/css" media="all" />
  <link rel="alternate" type="application/rss+xml" title="{{.siteInfo.title}}" href="//feed.xml" />

    {{if .siteInfo.baidutongji}}
  <script>
      var _hmt = _hmt || [];
      (function() {
          var hm = document.createElement("script");
          hm.src = "//hm.baidu.com/hm.js?{{.siteInfo.baidutongji}}}}";
          var s = document.getElementsByTagName("script")[0];
          s.parentNode.insertBefore(hm, s);
      })();
  </script>
    {{end}}
</head>

<body class="home blog wide">
<div id="page" class="hfeed site">
  <a class="skip-link screen-reader-text" href="#content">Skip to content</a>
  <header id="masthead" class="main-header" role="banner">
    <div class="container">
      <div class="row">
        <div class="site-branding col-md-4">
          <h1 class="site-title"><a href="/" rel="home">{{.siteInfo.title}}</a></h1>
          <span class="site-description">{{.siteInfo.description}}</span>
        </div>
        <!-- .site-branding -->
      </div>
    </div>
  </header>		    <div id="content">

  <div class="quest-row site-content">
    <div class="container">
      <div class="row">
        <div id="primary" class="content-area col-md-9">
          <div id="main" class="site-main" role="main">
            <!--article-begin-->
              {{range .mdFiles}}
            <article class="post hentry">
              <header class="entry-header">
                <h1 class="post-title"><a href="/blog/{{.fileName}}" rel="bookmark">{{.title}} </a></h1>
                <div class="entry-meta">
                  <time class="post-date"><i class="fa fa-clock-o"></i>{{.date}}</time>
                  <span class="seperator">/</span>
                  <span><i class="fa fa-user"></i> {{.author}}</span>
                </div>
              </header>	<div class="entry-content">
              <p>{{.summary}}</p>
            </div>	<footer class="entry-footer">
              <ul class="post-categories">

                <li><a href="/category/{{.category}}" rel="category">{{.category}}</a></li>
              </ul>

              <div class="read-more">
                <a href="/blog/{{.fileName}}">阅读全文<i class="fa fa-angle-double-right "></i></a>
              </div>
            </footer></article>
              {{end}}
            <!--article-end-->
            <div class="center">
            <ul class="pagination">
              <!--<li><span class="page-numbers current">.</span></li>-->
              {{range .pageInfo}}
              <li><a class="page-numbers{{if eq $.pageNow .}} current{{end}}" {{if ne $.pageNow .}} href="/page/{{.}}"{{end}}>{{.}}</a></li>
              {{end}}
              <!--<li><a class="next page-numbers" href="/page/2.html"><i class="fa fa-angle-double-right"></i></a></li>-->
            </ul>
          </div>
          </div>
          <!-- #main -->
        </div>
        <div id="secondary" class="widget-area main-sidebar col-md-3" role="complementary">
 <!--         <aside class="widget widget_search sidebar-widget clearfix">
            <h3 class="widget-title">搜索</h3>
            <form class="search" action="/search" method="get">
              <fieldset>
                <div class="text">
                  <input name="keyword" id="keyword" type="text" placeholder="Search ..."/>
                  <button class="fa fa-search">Search</button>
                </div>
              </fieldset>
            </form>
          </aside>-->
          <aside class="widget widget_categories sidebar-widget clearfix">
          <h3 class="widget-title">分类目录</h3>
          <ul>
            {{range $key,$v:=.category}}
            <li class="cat-item"><a href="/category/{{$key}}" >{{$key}}</a></li>
            {{end}}
          </ul>
        </aside>
<!--          <aside class="widget widget_archive sidebar-widget clearfix">
            <h3 class="widget-title">文章归档</h3>
            <ul>
              <li><a href="/archive/201604.html">2016-04</a></li>
              <li><a href="/archive/201611.html">2016-11</a></li>
              <li><a href="/archive/201507.html">2015-07</a></li>
              <li><a href="/archive/201701.html">2017-01</a></li>
              <li><a href="/archive/201702.html">2017-02</a></li>
              <li><a href="/archive/201612.html">2016-12</a></li>
            </ul>
          </aside>
          <aside class="widget widget_recent_entries sidebar-widget clearfix">
          <h3 class="widget-title">近期文章</h3>
          <ul>
            <li><a href="/blog/web-safe.html">Web安全与防御措施</a></li>
            <li><a href="/blog/dijkstra.html">PHP实现dijkstra算法，解决求最短路径问题。</a></li>
            <li><a href="/blog/mst.html">PHP实现无向带权图中生成最小生成树</a></li>
            <li><a href="/blog/no-direct-graph.html">PHP实现无向图的寻径查找</a></li>
            <li><a href="/blog/chatroom.html">通过Nodejs构建web聊天室</a></li>
          </ul>
        </aside>
          <aside class="widget widget_tag_cloud sidebar-widget clearfix">
            <h3 class="widget-title">标签</h3>
            <div class="tagcloud">
              <a href="/tags/1623323046.html"  title="设计模式" >设计模式</a>
              <a href="/tags/1884986029.html"  title="数据结构" >数据结构</a>
              <a href="/tags/3209314000.html"  title="laravel" >laravel</a>
              <a href="/tags/2324497415.html"  title="apache" >apache</a>
              <a href="/tags/2436893404.html"  title="安全" >安全</a>
              <a href="/tags/2232113024.html"  title="nodejs" >nodejs</a>
              <a href="/tags/706795710.html"  title="排序" >排序</a>
              <a href="/tags/4126637218.html"  title="算法" >算法</a>
            </div>
          </aside>-->
        </div>
        <!-- #secondary -->			</div>
      <!-- .row -->
    </div>
    <!-- .container -->
  </div>
  <!-- .quest-row -->
</div><!-- #content -->		    <footer id="colophon" class="copyright quest-row" role="contentinfo">
  <div class="container">
    <div class="row">
      <div class="col-md-6 copyright-text">
        <a href="https://github.com/jack3384">github传送门</a>
      </div>
      <div class="col-md-6 social-icon-container clearfix">
        <ul></ul>
      </div>
    </div>
    <!-- end row -->
  </div>
  <!-- end container -->
</footer>	</div><!-- #page -->
<a href="#0" class="cd-top"><i class="fa fa-angle-up"></i></a>


<script type="text/javascript" src="/static/theme/quest/assets/plugins/modernizr/modernizr.custom.js?ver=2.2"></script>
<script type="text/javascript" src="/static/theme/quest/js/jquery/jquery.js?ver=1.11.2"></script>
<script type="text/javascript" src="/static/theme/quest/js/jquery/jquery-migrate.min.js?ver=1.2.1"></script>
<script type="text/javascript" src="/static/theme/quest/assets/plugins/bootstrap/js/bootstrap.min.js?ver=2.2"></script>
<script type="text/javascript" src="/static/theme/quest/assets/plugins/wow/wow.js?ver=2.2"></script>
<script type="text/javascript" src="/static/theme/quest/assets/plugins/colorbox/jquery.colorbox-min.js?ver=2.2"></script>
<script type="text/javascript" src="/static/theme/quest/assets/js/quest.js?ver=2.2"></script>

<link rel="stylesheet" href="http://cdn.bootcss.com/highlight.js/8.6/styles/default.min.css">
<script src="http://cdn.bootcss.com/highlight.js/8.6/highlight.min.js"></script>
<script>hljs.initHighlightingOnLoad();</script>

<script type="text/x-mathjax-config">MathJax.Hub.Config({tex2jax: {inlineMath: [['$','$'], ['\\(','\\)']]}});</script>
<script type="text/javascript" src="http://cdn.bootcss.com/mathjax/2.5.3/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

</body>
</html>
