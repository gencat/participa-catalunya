# frozen_string_literal: true

google_analytics_noscript = <<~GANS
  <!--Google Tag Manager (noscript) -->
  <noscript>
    <iframe src="https://www.googletagmanager.com/ns.html?id=GTM-NH8MVLN"height="0" width="0"
      style="display:none;visibility:hidden">
    </iframe>
  </noscript>
  <!--End Google Tag Manager (noscript) -->
GANS
Deface::Override.new(virtual_path: +"layouts/decidim/_application",
                     name: "google_analytics_noscript",
                     insert_top: "body",
                     text: google_analytics_noscript,
                     original: "c370667fe6a59cfd5bf006e0c97323920df4ba1d")
