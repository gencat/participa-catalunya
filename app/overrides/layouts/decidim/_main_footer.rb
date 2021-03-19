# frozen_string_literal: true

Deface::Override.new(virtual_path: +"layouts/decidim/_main_footer",
                     name: "remote_logo",
                     remove: "div.main-footer a.main-footer__badge",
                     original: "4acba79b4f172ee3abaeb8a2f5385440646a50a8")

gencat_text = <<~GENCAT
  <div class="row"><br/></div>
  <div class="row">
    <div class="medium-2 small-12 column">
      <a rel="license" class="cc-badge part-logo-footer-gencat"
         href="http://www.gencat.cat" target="_blank">
        <%= image_tag("logo_generalitat_gris.png") %>
      </a>
    </div>
    <div class="medium-10 small-12 column">
      <div class="part-justify part-avis-legal">
        <a href="http://web.gencat.cat/<%= I18n.locale %>/menu-ajuda/ajuda/avis_legal/" target="_blank">
          <%= t("static.footer.legal_advice_title") %>:
        </a>
        <%= t("static.footer.legal_advice_text") %>
      </div>
    </div>
  </div>
  <div class="row"><br /></div>
GENCAT
Deface::Override.new(virtual_path: "layouts/decidim/_main_footer",
                     name: "gencat_footer2",
                     insert_after: "div.main-footer",
                     text: "<section>#{gencat_text}</section",
                     original: "4acba79b4f172ee3abaeb8a2f5385440646a50a8")

feder_text = <<~EOFEDER
  <section class="footer__subhero extended subhero home-section">
    <div class="row">
      <div class="columns small-12 large-9">
        <div class="row">
          <div class="small-10 medium-12 columns small-centered large-uncentered m-bottom">
            <%= t("decidim.pages.home.feder.description") %>
          </div>
        </div>
      </div>
      <div class="columns small-12 large-3 end">
        <div class="row">
          <div class="small-8 medium-6 large-12 columns small-centered ">
            <%= link_to "http://www.accio.gencat.cat/ca/accio/agencia/feder/", target: "_blank", class: "part-logo-footer-feder" do %>
              <%= image_tag "feder.png", alt: "FEDER" %>
            <% end %>
          </div>
        </div>
    </div>
  </section>
EOFEDER
Deface::Override.new(virtual_path: "layouts/decidim/_main_footer",
                     name: "feder_footer",
                     insert_after: "div.main-footer",
                     text: feder_text,
                     original: "4acba79b4f172ee3abaeb8a2f5385440646a50a8")
