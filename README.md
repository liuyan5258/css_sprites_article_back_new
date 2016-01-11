## compass images sprites adapt rem in article_back_new.html  

### 保留之前的布局适配方案  

    <script>
      (function(h,d){var b=h.documentElement,f=navigator.userAgent.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/),g=f?Math.min(d.devicePixelRatio,3):1,g=window.top===window.self?g:1,c=1/g,e="orientationchange" in window?"orientationchange":"resize";b.dataset.dpr=g;var i=h.createElement("meta");i.name="viewport";i.content="initial-scale="+c+",maximum-scale="+c+", minimum-scale="+c;b.firstElementChild.appendChild(i);var a=function(){var j=b.clientWidth;if(j/g>640){j=640*g}b.dataset.width=j;b.dataset.percent=100*(j/640);b.style.fontSize=100*(j/640)+"px"};a();if(!h.addEventListener){return}d.addEventListener(e,a,false)})(document,window);
    </script>  

### 在px2rem中把px转换为rem  

    // this is psd width
    $designWidth: 640;

    // 这里是雪碧图的实际大小，等雪碧图生成后需要手动补上
    $bigWidth: 66px;
    $bigHeight: 313px;

    @function px2rem ($px) {
      @if (type-of($px) == "number") {
        @return $px / 100px * 1rem;
      }
      
      @if (type-of($px) == "list") {
        @if (nth($px, 1) == 0 and nth($px, 2) != 0) {
          @return 0 ( nth($px, 2) / 100px - 0.01 ) * 1rem;
        } @else if (nth($px, 1) == 0 and nth($px, 2) == 0)  {
          @return 0 0;
        } @else if (nth($px, 1) != 0 and nth($px, 2) == 0) {
          @return ( nth($px, 1) / 100px - 0.01 ) * 1rem 0;
        } @else {
          @return ( nth($px, 1) / 100px - 0.01 ) * 1rem ( nth($px, 2) / 100px - 0.01 ) * 1rem;
        }
      }
    }

    @mixin sprite-info ($icons, $name) {
      width: px2rem(image-width(sprite-file($icons, $name)));
      height: px2rem(image-height(sprite-file($icons, $name)));
       @if (str-index($name, mask) == null) {
        background-image: sprite-url($icons);
        background-position: px2rem(sprite-position($icons, $name));
        background-size: px2rem(($bigWidth, $bigHeight));
        background-repeat: no-repeat;
      } @else {
        -webkit-mask-image: sprite-url($icons);
        -webkit-mask-position: px2rem(sprite-position($icons, $name));
        -webkit-mask-size: px2rem(($bigWidth, $bigHeight));
        -webkit-mask-repeat: no-repeat;
      }
    }  

### fix  

1. 因为之前文章页底部的那些图标都是用mask的，所以做了个判断
2. 在dist下过滤掉icons文件夹，只生成合成的那张雪碧图
