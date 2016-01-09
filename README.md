## compass images sprites adapt rem in article_back_new.html  

### 保留之前的布局适配方案  

    <script>
      (function (doc, win) {
        var docEl = doc.documentElement,
          isIOS = navigator.userAgent.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/),
          dpr = isIOS? Math.min(win.devicePixelRatio, 3) : 1,
          dpr = window.top === window.self? dpr : 1, //被iframe引用时，禁止缩放
          scale = 1 / dpr,
          resizeEvt = 'orientationchange' in window ? 'orientationchange' : 'resize';
        docEl.dataset.dpr = dpr;
        var metaEl = doc.createElement('meta');
        metaEl.name = 'viewport';
        metaEl.content = 'initial-scale=' + scale + ',maximum-scale=' + scale + ', minimum-scale=' + scale;
        docEl.firstElementChild.appendChild(metaEl);
        var recalc = function () {
            var width = docEl.clientWidth;
            if (width / dpr > 640) {
                width = 640 * dpr;
            }
            docEl.dataset.width = width
            docEl.dataset.percent = 100 * (width / 640);
            docEl.style.fontSize = 100 * (width / 640) + 'px';
          };
        recalc()
        if (!doc.addEventListener) return;
        win.addEventListener(resizeEvt, recalc, false);
      })(document, window);
    </script>  

### 在px2rem中把px转换为rem  

    // this is psd width
    $designWidth: 640;

    // 这里是雪碧图的实际大小，等雪碧图生成后需要手动补上
    $bigWidth: 40px;
    $bigHeight: 164px;

    @function px2rem ($px) {
      @if (type-of($px) == "number") {
        @return $px / 100px * 1rem;
      }
      
      @if (type-of($px) == "list") {
          @if (nth($px, 1) == 0 and nth($px, 2) != 0) {
            @return 0 nth($px, 2) / 100px * 1rem;
          } @else if (nth($px, 1) == 0 and nth($px, 2) == 0)  {
            @return 0 0;
          } @else if (nth($px, 1) != 0 and nth($px, 2) == 0) {
            @return nth($px, 1) / 100px * 1rem 0;
          } @else {
            @return nth($px, 1) / 100px * 1rem nth($px, 2) / 100px * 1rem;
          }
      }
    }

    @mixin sprite-info ($icons, $name) {
      width: px2rem(image-width(sprite-file($icons, $name)));
      height: px2rem(image-height(sprite-file($icons, $name)));
      -webkit-mask-image: sprite-url($icons);
      -webkit-mask-position: px2rem(sprite-position($icons, $name));
      -webkit-mask-size: px2rem(($bigWidth, $bigHeight));
      -webkit-mask-repeat: no-repeat;
    }  
