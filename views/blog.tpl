<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{{.fileInfo.title}}</title>
    <meta name="keywords" content="todo">
    <meta name="description" content="{{.fileInfo.summary}}">

    <link rel="stylesheet" href="../static/theme/quest/assets/plugins/bootstrap/css/bootstrap.min.css?ver=2.2" type="text/css" media="all" />
    <link rel="stylesheet" href="../static/theme/quest/assets/plugins/font-awesome/css/font-awesome.min.css?ver=2.2" type="text/css" media="all" />
    <!--<link rel="stylesheet" href="http://fonts.useso.com/css?family=Open+Sans:300,400,600&subset=latin,latin-ext">-->
    <link rel="stylesheet" href="../static/theme/quest/css/style.css?ver=2.2" type="text/css" media="all" />
    <link rel="stylesheet" href="../static/theme/quest/css/customizer.css?ver=2.2" type="text/css" media="all" />
    <link rel="alternate" type="application/rss+xml" title="{{.fileInfo.title}}" href="//feed.xml" />

    {{if .siteInfo.baidutongji}}
    <script>
        var _hmt = _hmt || [];
        (function() {
            var hm = document.createElement("script");
            hm.src = "//hm.baidu.com/hm.js?{{.siteInfo.baidutongji}}";
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
                <div id="primary" class="content-area single col-md-9">
                    <div id="main" class="site-main" role="main">
                        <article class="post hentry">
                            <header class="entry-header">
                                <h1 class="post-title"><a href="/blog/web-safe.html" rel="bookmark">{{.fileInfo.title}} </a></h1>
                                <div class="entry-meta">
                                    <time class="post-date"><i class="fa fa-clock-o"></i>{{.fileInfo.date}}</time>
                                    <span class="seperator">/</span>
                                    <span><i class="fa fa-user"></i> {{.fileInfo.author}}</span>
                                </div><!-- .entry-meta -->
                            </header><!-- .entry-header -->	<div class="entry-content">
                            {{.output}}
                        </div><!-- .entry-content -->	<footer class="entry-footer">
                            <ul class="post-categories">

                                <li><a href="/category/{{.fileInfo.category}}" rel="category">{{.fileInfo.category}}</a></li>
                            </ul>

                        </footer><!-- .entry-footer --></article><!-- #post-## -->
                        <div id="comments" class="clearfix">
                        <div id="respond" class="comment-respond">
                            {{if .siteInfo.duoshuo}}
                            <!-- 多说评论框 start -->
                            <div class="ds-thread" data-thread-key="{{.fileInfo.fileName}}" data-title="{{.fileInfo.title}}" data-url="//blog/{{.fileInfo.fileName}}"></div>
                            <!-- 多说评论框 end -->
                            <!-- 多说公共JS代码 start (一个网页只需插入一次) -->
                            <script type="text/javascript">
                                var duoshuoQuery = {short_name:"{{.siteInfo.duoshuo}}"};
                                (function() {
                                    var ds = document.createElement('script');
                                    ds.type = 'text/javascript';ds.async = true;
                                    ds.src = (document.location.protocol == 'https:' ? 'https:' : 'http:') + '//static.duoshuo.com/embed.js';
                                    ds.charset = 'UTF-8';
                                    (document.getElementsByTagName('head')[0]
                                    || document.getElementsByTagName('body')[0]).appendChild(ds);
                                })();
                            </script>
                            <!-- 多说公共JS代码 end -->
                            {{end}}
                        </div><!-- #respond -->
                    </div>
                    </div>
                    <!-- #main -->
                </div>
                <!-- #primary -->
                <div id="secondary" class="widget-area main-sidebar col-md-3" role="complementary">
                    <aside class="widget widget_categories sidebar-widget clearfix">
                </aside>
                </div><!-- #secondary -->			</div>
            <!-- .row -->
        </div>
        <!-- .container -->
    </div>
    <!-- .quest-row -->
</div>		    <footer id="colophon" class="copyright quest-row" role="contentinfo">
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


<script type="text/javascript" src="../static/theme/quest/assets/plugins/modernizr/modernizr.custom.js?ver=2.2"></script>
<script type="text/javascript" src="../static/theme/quest/js/jquery/jquery.js?ver=1.11.2"></script>
<script type="text/javascript" src="../static/theme/quest/js/jquery/jquery-migrate.min.js?ver=1.2.1"></script>
<script type="text/javascript" src="../static/theme/quest/assets/plugins/bootstrap/js/bootstrap.min.js?ver=2.2"></script>
<script type="text/javascript" src="../static/theme/quest/assets/plugins/wow/wow.js?ver=2.2"></script>
<script type="text/javascript" src="../static/theme/quest/assets/plugins/colorbox/jquery.colorbox-min.js?ver=2.2"></script>
<script type="text/javascript" src="../static/theme/quest/assets/js/quest.js?ver=2.2"></script>

<link rel="stylesheet" href="http://cdn.bootcss.com/highlight.js/8.6/styles/default.min.css">
<script src="http://cdn.bootcss.com/highlight.js/8.6/highlight.min.js"></script>
<script>hljs.initHighlightingOnLoad();</script>

<script type="text/x-mathjax-config">MathJax.Hub.Config({tex2jax: {inlineMath: [['$','$'], ['\\(','\\)']]}});</script>
<script type="text/javascript" src="http://cdn.bootcss.com/mathjax/2.5.3/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

</body>
</html>
