

module URLHelpers
  def link_to(name, link)
    "<a href=#{link}>#{name}</a>"
  end

  def button_to(name, link, options = {method: :get})
    "<form action=\"#{link}\" method=\"#{options[:method]}\">

    <input type=\"submit\" value=\"#{name}\">
    </form>"

    # Wait until you've done CSRF - form_authenticity_token is undefined
    # <input type=\"hidden\" name=\"authenticity_token\"
    # value=\"<%= #{form_authenticity_token} %>\">
  end

  def self.included(base)
    base.class_eval do
      define_method "#{self.class.name.downcase}s_url" do
        "/#{self.class.name.downcase}s"
      end

      define_method "#{self.class.name.downcase}_url" do |argument|
        "/#{self.class.name.downcase}s/#{argument}"
      end

      define_method "edit_#{self.class.name.downcase}_url" do |argument|
        "/#{self.class.name.downcase}s/#{argument}/edit"
      end

      define_method "new_#{self.class.name.downcase}_url" do
        "/#{self.class.name.downcase}s/new"
      end
    end
  end
end
