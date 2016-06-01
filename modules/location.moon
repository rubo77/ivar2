{:simplehttp, :json, :urlEncode} = require'util'
on_finished = (req, res) ->
  send = (body, code, content_type) ->
    if not code then code = "200"
    if not content_type then content_type = 'text/html'
    res\append ':status', code
    res\append 'Content-Type', content_type
    res\append 'Content-Length', tostring(#body)
    req\write_headers(res, false, 30)
    req\write_body_from_string(body, 30)

  channel = req.url\match('channel=(.+)')
  unless channel
    html = 'Invalid channel'
    send html, '404'
    return
  else
    channel = '#'..channel

  html = [[
  <!DOCTYPE html>
  <html>
  <head>

  <!-- adapted from dbot's map by xt -->
  <!-- set location with !location set yourlocation -->

  <meta charset="utf-8">
  <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
  <title>IRC member map</title>

  <style type="text/css">
  html { height: 100% }
  body { height: 100%; margin: 0; padding: 0 }
  </style>

  <script type="text/javascript" src="//maps.googleapis.com/maps/api/js?key=]]..ivar2.config.youtubeAPIKey..[[&amp;sensor=false"></script>

<!--this was removed so use it inline for now  <script src="//google-maps-utility-library-v3.googlecode.com/svn/trunk/markerclustererplus/src/markerclusterer_packed.js"></script>-->
  <script>
eval(function(p,a,c,k,e,r){e=function(c){return(c<a?'':e(parseInt(c/a)))+((c=c%a)>35?String.fromCharCode(c+29):c.toString(36))};if(!''.replace(/^/,String)){while(c--)r[e(c)]=k[c]||e(c);k=[function(e){return r[e]}];e=function(){return'\\w+'};c=1};while(c--)if(k[c])p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c]);return p}('4 E(b,a){b.18().12(E,o.n.2W);3.G=b;3.Q=a;3.w=q;3.p=q;3.1H=q;3.1m=u;3.K(b.A())}E.5.2H=4(){6 c=3;3.p=46.3W("1N");8(3.1m){3.1M()}3.3p().3i.54(3.p);o.n.z.23(3.p,"31",4(e){6 a;6 b=c.G.18();o.n.z.14(b,"31",c.G);o.n.z.14(b,"4q",c.G);8(b.2P()){a=b.1B();b.A().2L(c.G.1x());8(a!==q&&(b.A().1U()>a)){b.A().4f(a+1)}}e.4e=I;8(e.2B){e.2B()}});o.n.z.23(3.p,"2z",4(){6 a=c.G.18();o.n.z.14(a,"2z",c.G)});o.n.z.23(3.p,"2w",4(){6 a=c.G.18();o.n.z.14(a,"2w",c.G)})};E.5.2s=4(){8(3.p&&3.p.2q){3.1p();o.n.z.3O(3.p);3.p.2q.3G(3.p);3.p=q}};E.5.2f=4(){8(3.1m){6 a=3.1L(3.w);3.p.U.1s=a.y+"v";3.p.U.1o=a.x+"v"}};E.5.1p=4(){8(3.p){3.p.U.3a="38"}3.1m=u};E.5.1M=4(){8(3.p){6 a=3.1L(3.w);3.p.U.4T=3.36(a);8(3.G.W){3.p.2Q="<4H 4E=\'"+3.21+"\'><1N U=\'22: 2U; 1s: 33; 1o: 33; 1a: "+3.X+"v;\'>"+3.1H.16+"</1N>"}F{3.p.2Q=3.1H.16}3.p.2O=3.G.18().2M();3.p.U.3a=""}3.1m=I};E.5.2K=4(a){3.1H=a;6 b=s.4g(0,a.2I-1);b=s.1T(3.Q.k-1,b);6 c=3.Q[b];3.21=c.1Z;3.P=c.Y;3.X=c.1a;3.D=c.4d;3.1S=c.49||[1Q(3.P/2,10),1Q(3.X/2,10)];3.2x=c.45||"44";3.2a=c.3Z||11;3.2o=c.3S||"38";3.2l=c.3L||"3I";3.2i=c.3D||"3B";3.2d=c.3z||"3x,3w-3t";3.2k=c.3q||"0 0"};E.5.2b=4(a){3.w=a};E.5.36=4(b){6 a=[];8(!3.G.W){a.H(\'2n-3j:1Z(\'+3.21+\');\');a.H(\'2n-22:\'+3.2k+\';\')}8(1t 3.D===\'3f\'){8(1t 3.D[0]===\'2C\'&&3.D[0]>0&&3.D[0]<3.P){a.H(\'Y:\'+(3.P-3.D[0])+\'v; 2t-1s:\'+3.D[0]+\'v;\')}F{a.H(\'Y:\'+3.P+\'v; 3b-Y:\'+3.P+\'v;\')}8(1t 3.D[1]===\'2C\'&&3.D[1]>0&&3.D[1]<3.X){a.H(\'1a:\'+(3.X-3.D[1])+\'v; 2t-1o:\'+3.D[1]+\'v;\')}F{a.H(\'1a:\'+3.X+\'v; 16-39:1b;\')}}F{a.H(\'Y:\'+3.P+\'v; 3b-Y:\'+3.P+\'v; 1a:\'+3.X+\'v; 16-39:1b;\')}a.H(\'4X:4S; 1s:\'+b.y+\'v; 1o:\'+b.x+\'v; 4O:\'+3.2x+\'; 22:2U; 1E-1i:\'+3.2a+\'v; 1E-4M:\'+3.2d+\'; 1E-4L:\'+3.2l+\'; 1E-U:\'+3.2i+\'; 16-4K:\'+3.2o+\';\');9 a.4G("")};E.5.1L=4(b){6 a=3.2T().20(b);a.x-=3.1S[1];a.y-=3.1S[0];9 a};4 B(a){3.T=a;3.M=a.A();3.O=a.2Y();3.Z=a.2Z();3.15=a.32();3.W=a.2R();3.j=[];3.w=q;3.26=q;3.13=L E(3,a.27())}B.5.4h=4(){9 3.j.k};B.5.1C=4(){9 3.j};B.5.2N=4(){9 3.w};B.5.A=4(){9 3.M};B.5.18=4(){9 3.T};B.5.1x=4(){6 i;6 b=L o.n.1A(3.w,3.w);6 a=3.1C();t(i=0;i<a.k;i++){b.12(a[i].S())}9 b};B.5.1z=4(){3.13.K(q);3.j=[];1W 3.j};B.5.1y=4(e){6 i;6 c;6 b;8(3.2J(e)){9 u}8(!3.w){3.w=e.S();3.1V()}F{8(3.15){6 l=3.j.k+1;6 a=(3.w.N()*(l-1)+e.S().N())/l;6 d=(3.w.17()*(l-1)+e.S().17())/l;3.w=L o.n.29(a,d);3.1V()}}e.1k=I;3.j.H(e);c=3.j.k;b=3.T.1B();8(b!==q&&3.M.1U()>b){8(e.A()!==3.M){e.K(3.M)}}F 8(c<3.Z){8(e.A()!==3.M){e.K(3.M)}}F 8(c===3.Z){t(i=0;i<c;i++){3.j[i].K(q)}}F{e.K(q)}3.2G();9 I};B.5.2F=4(a){9 3.26.2E(a.S())};B.5.1V=4(){6 a=L o.n.1A(3.w,3.w);3.26=3.T.1Y(a)};B.5.2G=4(){6 c=3.j.k;6 a=3.T.1B();8(a!==q&&3.M.1U()>a){3.13.1p();9}8(c<3.Z){3.13.1p();9}6 b=3.T.27().k;6 d=3.T.2D()(3.j,b);3.13.2b(3.w);3.13.2K(d);3.13.1M()};B.5.2J=4(a){6 i;8(3.j.1h){9 3.j.1h(a)!==-1}F{t(i=0;i<3.j.k;i++){8(a===3.j[i]){9 I}}}9 u};4 7(a,c,b){3.12(7,o.n.2W);c=c||[];b=b||{};3.j=[];3.C=[];3.1g=[];3.1w=q;3.1f=u;3.O=b.4c||4b;3.Z=b.4a||2;3.1R=b.48||q;3.Q=b.47||[];3.1P=b.2O||"";3.1v=I;8(b.2A!==1j){3.1v=b.2A}3.15=u;8(b.2y!==1j){3.15=b.2y}3.19=u;8(b.2g!==1j){3.19=b.2g}3.W=u;8(b.2v!==1j){3.W=b.2v}3.1u=b.43||7.2u;3.1n=b.40||7.2r;3.1c=b.3U||7.2p;3.1J=b.3T||7.2m;3.1K=b.3P||7.2c;3.1q=b.3K||7.2j;8(3H.3F.3E().1h("3C")!==-1){3.1K=3.1q}3.2h();3.2e(c,I);3.K(a)}7.5.2H=4(){6 a=3;3.1w=3.A();3.1f=I;3.1d();3.1g=[o.n.z.1O(3.A(),"3A",4(){a.1r(u)}),o.n.z.1O(3.A(),"3y",4(){a.1e()})]};7.5.2s=4(){6 i;t(i=0;i<3.j.k;i++){3.j[i].K(3.1w)}t(i=0;i<3.C.k;i++){3.C[i].1z()}3.C=[];t(i=0;i<3.1g.k;i++){o.n.z.3J(3.1g[i])}3.1g=[];3.1w=q;3.1f=u};7.5.2f=4(){};7.5.2h=4(){6 i,1i;8(3.Q.k>0){9}t(i=0;i<3.1c.k;i++){1i=3.1c[i];3.Q.H({1Z:3.1u+(i+1)+"."+3.1n,Y:1i,1a:1i})}};7.5.3v=4(){6 i;6 a=3.1C();6 b=L o.n.1A();t(i=0;i<a.k;i++){b.12(a[i].S())}3.A().2L(b)};7.5.2Y=4(){9 3.O};7.5.3u=4(a){3.O=a};7.5.2Z=4(){9 3.Z};7.5.3M=4(a){3.Z=a};7.5.1B=4(){9 3.1R};7.5.3N=4(a){3.1R=a};7.5.27=4(){9 3.Q};7.5.3s=4(a){3.Q=a};7.5.2M=4(){9 3.1P};7.5.3r=4(a){3.1P=a};7.5.2P=4(){9 3.1v};7.5.3Q=4(a){3.1v=a};7.5.32=4(){9 3.15};7.5.3R=4(a){3.15=a};7.5.3o=4(){9 3.19};7.5.3n=4(a){3.19=a};7.5.3m=4(){9 3.1n};7.5.3V=4(a){3.1n=a};7.5.3l=4(){9 3.1u};7.5.3k=4(a){3.1u=a};7.5.3X=4(){9 3.1c};7.5.3Y=4(a){3.1c=a};7.5.2D=4(){9 3.1J};7.5.3h=4(a){3.1J=a};7.5.2R=4(){9 3.W};7.5.3g=4(a){3.W=a};7.5.41=4(){9 3.1q};7.5.42=4(a){3.1q=a};7.5.1C=4(){9 3.j};7.5.3e=4(){9 3.j.k};7.5.3d=4(){9 3.C};7.5.3c=4(){9 3.C.k};7.5.1y=4(b,a){3.1I(b);8(!a){3.1e()}};7.5.2e=4(b,a){6 i;t(i=0;i<b.k;i++){3.1I(b[i])}8(!a){3.1e()}};7.5.1I=4(b){8(b.51()){6 a=3;o.n.z.1O(b,"50",4(){8(a.1f){3.1k=u;a.1d()}})}b.1k=u;3.j.H(b)};7.5.4Z=4(c,a){6 b=3.28(c);8(!a&&b){3.1d()}9 b};7.5.4Y=4(a,c){6 i,r;6 b=u;t(i=0;i<a.k;i++){r=3.28(a[i]);b=b||r}8(!c&&b){3.1d()}9 b};7.5.28=4(b){6 i;6 a=-1;8(3.j.1h){a=3.j.1h(b)}F{t(i=0;i<3.j.k;i++){8(b===3.j[i]){a=i;4W}}}8(a===-1){9 u}b.K(q);3.j.4U(a,1);9 I};7.5.4Q=4(){3.1r(I);3.j=[]};7.5.1d=4(){6 a=3.C.4P();3.C=[];3.1r(u);3.1e();37(4(){6 i;t(i=0;i<a.k;i++){a[i].1z()}},0)};7.5.1Y=4(d){6 f=3.2T();6 c=L o.n.29(d.25().N(),d.25().17());6 a=L o.n.29(d.1X().N(),d.1X().17());6 e=f.20(c);e.x+=3.O;e.y-=3.O;6 g=f.20(a);g.x-=3.O;g.y+=3.O;6 b=f.35(e);6 h=f.35(g);d.12(b);d.12(h);9 d};7.5.1e=4(){3.24(0)};7.5.1r=4(a){6 i,J;t(i=0;i<3.C.k;i++){3.C[i].1z()}3.C=[];t(i=0;i<3.j.k;i++){J=3.j[i];J.1k=u;8(a){J.K(q)}}};7.5.34=4(b,e){6 R=4I;6 g=(e.N()-b.N())*s.1G/1D;6 f=(e.17()-b.17())*s.1G/1D;6 a=s.1F(g/2)*s.1F(g/2)+s.30(b.N()*s.1G/1D)*s.30(e.N()*s.1G/1D)*s.1F(f/2)*s.1F(f/2);6 c=2*s.4F(s.2S(a),s.2S(1-a));6 d=R*c;9 d};7.5.2X=4(b,a){9 a.2E(b.S())};7.5.2V=4(c){6 i,d,V,1b;6 a=4D;6 b=q;t(i=0;i<3.C.k;i++){V=3.C[i];1b=V.2N();8(1b){d=3.34(1b,c.S());8(d<a){a=d;b=V}}}8(b&&b.2F(c)){b.1y(c)}F{V=L B(3);V.1y(c);3.C.H(V)}};7.5.24=4(e){6 i,J;6 c=3;8(!3.1f){9}8(e===0){o.n.z.14(3,"4C",3);8(1t 3.1l!=="1j"){4B(3.1l);1W 3.1l}}6 d=L o.n.1A(3.A().1x().1X(),3.A().1x().25());6 a=3.1Y(d);6 b=s.1T(e+3.1K,3.j.k);t(i=e;i<b;i++){J=3.j[i];8(!J.1k&&3.2X(J,a)){8(!3.19||(3.19&&J.4A())){3.2V(J)}}}8(b<3.j.k){3.1l=37(4(){c.24(b)},0)}F{1W 3.1l;o.n.z.14(3,"4z",3)}};7.5.12=4(d,c){9(4(b){6 a;t(a 4y b.5){3.5[a]=b.5[a]}9 3}).4x(d,[c])};7.2m=4(a,b){6 e=0;6 c=a.k.4J();6 d=c;4w(d!==0){d=1Q(d/10,10);e++}e=s.1T(e,b);9{16:c,2I:e}};7.2c=4v;7.2j=4u;7.2u="4N://o-n-4t-4s-4r.4R.4p/4o/4n/4V/4m/m";7.2r="4l";7.2p=[53,4k,4j,4i,52];',62,315,'|||this|function|prototype|var|MarkerClusterer|if|return||||||||||markers_|length|||maps|google|div_|null||Math|for|false|px|center_|||event|getMap|Cluster|clusters_|anchor_|ClusterIcon|else|cluster_|push|true|marker|setMap|new|map_|lat|gridSize_|height_|styles_||getPosition|markerClusterer_|style|cluster|printable_|width_|height|minClusterSize_|||extend|clusterIcon_|trigger|averageCenter_|text|lng|getMarkerClusterer|ignoreHidden_|width|center|imageSizes_|repaint|redraw_|ready_|listeners_|indexOf|size|undefined|isAdded|timerRefStatic|visible_|imageExtension_|left|hide|batchSizeIE_|resetViewport_|top|typeof|imagePath_|zoomOnClick_|activeMap_|getBounds|addMarker|remove|LatLngBounds|getMaxZoom|getMarkers|180|font|sin|PI|sums_|pushMarkerTo_|calculator_|batchSize_|getPosFromLatLng_|show|div|addListener|title_|parseInt|maxZoom_|anchorIcon_|min|getZoom|calculateBounds_|delete|getSouthWest|getExtendedBounds|url|fromLatLngToDivPixel|url_|position|addDomListener|createClusters_|getNorthEast|bounds_|getStyles|removeMarker_|LatLng|textSize_|setCenter|BATCH_SIZE|fontFamily_|addMarkers|draw|ignoreHidden|setupStyles_|fontStyle_|BATCH_SIZE_IE|backgroundPosition_|fontWeight_|CALCULATOR|background|textDecoration_|IMAGE_SIZES|parentNode|IMAGE_EXTENSION|onRemove|padding|IMAGE_PATH|printable|mouseout|textColor_|averageCenter|mouseover|zoomOnClick|stopPropagation|number|getCalculator|contains|isMarkerInClusterBounds|updateIcon_|onAdd|index|isMarkerAlreadyAdded_|useStyle|fitBounds|getTitle|getCenter|title|getZoomOnClick|innerHTML|getPrintable|sqrt|getProjection|absolute|addToClosestCluster_|OverlayView|isMarkerInBounds_|getGridSize|getMinimumClusterSize|cos|click|getAverageCenter|0px|distanceBetweenPoints_|fromDivPixelToLatLng|createCss|setTimeout|none|align|display|line|getTotalClusters|getClusters|getTotalMarkers|object|setPrintable|setCalculator|overlayMouseTarget|image|setImagePath|getImagePath|getImageExtension|setIgnoreHidden|getIgnoreHidden|getPanes|backgroundPosition|setTitle|setStyles|serif|setGridSize|fitMapToMarkers|sans|Arial|idle|fontFamily|zoom_changed|normal|msie|fontStyle|toLowerCase|userAgent|removeChild|navigator|bold|removeListener|batchSizeIE|fontWeight|setMinimumClusterSize|setMaxZoom|clearInstanceListeners|batchSize|setZoomOnClick|setAverageCenter|textDecoration|calculator|imageSizes|setImageExtension|createElement|getImageSizes|setImageSizes|textSize|imageExtension|getBatchSizeIE|setBatchSizeIE|imagePath|black|textColor|document|styles|maxZoom|anchorIcon|minimumClusterSize|60|gridSize|anchor|cancelBubble|setZoom|max|getSize|78|66|56|png|images|trunk|svn|com|clusterclick|v3|library|utility|500|2000|while|apply|in|clusteringend|getVisible|clearTimeout|clusteringbegin|40000|src|atan2|join|img|6371|toString|decoration|weight|family|http|color|slice|clearMarkers|googlecode|pointer|cssText|splice|markerclustererplus|break|cursor|removeMarkers|removeMarker|dragend|getDraggable|90||appendChild'.split('|'),0,{}))
</script>
  </head><body>
  <div id="map" style="width: 100%; height: 100%"></div>
  <script type="text/javascript">
]]
  markerdata = {}
  for n,t in pairs ivar2.channels[channel].nicks
    pos = ivar2.persist["location:coords:#{n}"]
    if pos
      lat, lon = pos\match('([^,]+),([^,]+)')
      marker = {
        account: n,
        formattedAddress: ivar2.persist["location:place:#{n}"] or 'N/A',
        lng: tonumber(lon),
        lat: tonumber(lat),
        channel: channel
      }
      markerdata[#markerdata + 1] = marker

  if #markerdata == 0 then
    html = 'Invalid channel'
    send html, '404'
    return

  html ..= [[
  var map = new google.maps.Map(document.getElementById("map"), {
    center: new google.maps.LatLng(0, 0),
    zoom: 3
  });
  var infoWindow = null;
  var markers = [];

  function makeInfoWindow(info) {
    return new google.maps.InfoWindow({
      content: makeMarkerDiv(info)
    });
  }

  function makeMarkerDiv(h) {
    return "<div style='line-height:1.35;overflow:hidden;white-space:nowrap'>" + h + "</div>";
  }

  function makeMarkerInfo(m) {
    return "<strong>" + m.get("account") + " on " + m.get("channel") + "</strong> " +
      m.get("formattedAddress");
  }

  function dismiss() {
    if (infoWindow !== null) {
      infoWindow.close();
    }
  }
  ]]..json.encode(markerdata)..[[.forEach(function (loc) {
    var marker = new google.maps.Marker({
      position: new google.maps.LatLng(loc.lat, loc.lng)
    });
    marker.setValues(loc);
    markers.push(marker);
    google.maps.event.addListener(marker, "mouseover", function () {
      dismiss();
      infoWindow = makeInfoWindow(makeMarkerInfo(marker));
      infoWindow.open(map, marker);
    });
    google.maps.event.addListener(marker, "mouseout", dismiss);
    google.maps.event.addListener(marker, "click", function () {
      map.setZoom(Math.max(8, map.getZoom()));
      map.setCenter(marker.getPosition());
    });
  });
  var mc = new MarkerClusterer(map, markers, {
    averageCenter: true
  });
  google.maps.event.addListener(mc, "mouseover", function (c) {
    dismiss();
    var markers = c.getMarkers();
    infoWindow = makeInfoWindow(markers.map(makeMarkerInfo).join("<br>"));
    infoWindow.setPosition(c.getCenter());
    infoWindow.open(map);
  });
  google.maps.event.addListener(mc, "mouseout", dismiss);
  google.maps.event.addListener(mc, "click", dismiss);

  </script>
  </body>
  </html>
  ]]
  --print('---- request finished, send response')
  send html, '200'

ivar2.webserver.regUrl "/location/(.*)$", on_finished

lookup = (address, cb) ->
  API_URL = 'http://maps.googleapis.com/maps/api/geocode/json'
  url = API_URL .. '?address=' .. urlEncode(address) .. '&sensor=false' .. '&language=en-GB'

  simplehttp url, (data) ->
      parsedData = json.decode data
      if parsedData.status ~= 'OK'
        return false, parsedData.status or 'unknown API error'

      location = parsedData.results[1]
      locality, country, adminArea

      findComponent = (field, ...) ->
        n = select('#', ...)
        for i=1, n
          searchType = select(i, ...)
          for _, component in ipairs(location.address_components)
            for _, type in ipairs(component.types)
              if type == searchType
                return component[field]

      locality = findComponent('long_name', 'locality', 'postal_town', 'route', 'establishment', 'natural_feature')
      adminArea = findComponent('short_name', 'administrative_area_level_1')
      country = findComponent('long_name', 'country') or 'Nowhereistan'

      if adminArea and #adminArea <= 5
        if not locality
          locality = adminArea
        else
          locality = locality..', '..adminArea

      locality = locality or 'Null'

      place = locality..', '..country

      cb place, location.geometry.location.lat..','..location.geometry.location.lng

PRIVMSG:
  '^%plocation set (.+)$': (source, destination, arg) =>
    lookup arg, (place, loc) ->
      nick = source.nick
      @.persist["location:place:#{nick}"] = place
      @.persist["location:coords:#{nick}"] = loc
      say '%s %s', place, loc
  '^%plocation map$': (source, destination, arg) =>
    channel = destination\sub(2)
    say "http://irc.lart.no:#{ivar2.config.webserverport}/location/?channel=#{channel}"
