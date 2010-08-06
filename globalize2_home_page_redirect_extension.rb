class Globalize2HomePageRedirectExtension < Radiant::Extension
  version "0.1"
  description "Adds home page redirect based on browser language"
  
  Globalize2Extension.class_eval do

    def self.fallback_language
      @@default_language ||= Radiant::Config['globalize.redirect_home_page_fallback_language'].blank? ? Globalize2Extension.default_language : Radiant::Config['globalize.redirect_home_page_fallback_language']
    end

    def self.redirect_home_page?
      @@redirect_home_page ||= Radiant::Config['globalize.redirect_home_page?'] == nil ? true : Radiant::Config['globalize.redirect_home_page?']
    end

  end

  def activate
    Page.send(:include, Globalize2::HomePageRedirectPageExtensions)
  end

  
  def deactivate
  end
  
end
