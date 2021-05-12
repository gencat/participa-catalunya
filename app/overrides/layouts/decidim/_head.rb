# frozen_string_literal: true

google_analytics_javascript = <<~GAJS
  <!--Google Tag Manager -->
  <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
    new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
    j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;
    j.src='https://www.googletagmanager.com/gtm.js?id='+i+dl;
    f.parentNode.insertBefore(j,f);})(window,document,'script','dataLayer',
    'GTM-NH8MVLN');
  </script>
  <!--End Google Tag Manager -->
GAJS
Deface::Override.new(virtual_path: +"layouts/decidim/_head",
                     name: "google_analytics_javascript",
                     insert_before: "erb[loud]:contains('csrf_meta_tags')",
                     text: google_analytics_javascript,
                     original: "47a04df83b17bd3e03febe129ad8fd65e6680f48")
