module Globalize2
  module HomePageRedirectPageExtensions
    def self.included(base)
      base.class_eval do
        alias_method_chain :render, :language_detection
        alias_method_chain :headers, :language_detection
        alias_method_chain :response_code, :language_detection
        alias_method_chain :cache?, :language_detection
      end
    end
    
    def headers_with_language_detection
      needs_language_detection? ? { 'Location' => location, 'Vary' => "Accept-Language" } : headers_without_language_detection
    end
    
    def render_with_language_detection
      needs_language_detection? ? '<html><body>Redirecting...</body></html>' : render_without_language_detection
    end

    def response_code_with_language_detection
      needs_language_detection? ? 302 : response_code_without_language_detection
    end
    
    def cache_with_language_detection?
      needs_language_detection? ? false : cache_without_language_detection?
    end
    
    private
    
    def needs_language_detection?
      Globalize2Extension.redirect_home_page? and (not parent?) and request.path == '/'
    end
    
    def languages
      langs = (request.env["HTTP_ACCEPT_LANGUAGE"] || "").split(/[,\s]+/)
      langs_with_weights = langs.map do |ele|
        both = ele.split(/;q=/)
        lang = both[0].split('-').first
        weight = both[1] ? Float(both[1]) : 1
        [-weight, lang]
      end.sort_by(&:first).map(&:last)
    end

    def location
      language = languages.detect{|l| Globalize2Extension.locales.include?(l)} || Globalize2Extension.fallback_language 
      path = clean_url("#{language}#{request.path}")
      "#{request.protocol}#{request.host_with_port}#{path}" << (request.query_string.blank? ? '' : "?#{request.query_string}")
    end  
  end
end
