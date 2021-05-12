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

Deface::Override.new(virtual_path: +"layouts/decidim/_impersonation_warning",
                     name: "google_analytics_noscript",
                     insert_before: "erb[silent]:contains('if current_user_impersonated?')",
                     text: google_analytics_noscript,
                     original: "2ef954f4ee9fd121b63cecdc94ed946f399c35bf")
