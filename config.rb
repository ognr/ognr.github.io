###
# Blog settings
###

Time.zone = "Lima"

activate :blog do |blog|
  # This will add a prefix to all links, template references and source paths
  # blog.prefix = "blog"

  blog.permalink = "{year}/{month}/{day}/{title}.html"
  # Matcher for blog source files
  # blog.sources = "{year}-{month}-{day}-{title}.html"
  blog.taglink = "tags/{tag}.html"
  blog.layout = "layout"
  blog.summary_separator = /(READMORE)/
  blog.summary_length = 250
  # blog.year_link = "{year}.html"
  # blog.month_link = "{year}/{month}.html"
  # blog.day_link = "{year}/{month}/{day}.html"
  # blog.default_extension = ".markdown"

  blog.tag_template = "tag.html"
  blog.calendar_template = "calendar.html"

  # Enable pagination
  blog.paginate = true
  blog.per_page = 20
  blog.page_link = "page/{num}"
end

page "/feed.xml", layout: false

###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", layout: false
#
# With alternative layout
# page "/path/to/file.html", layout: :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
# activate :livereload

# Methods defined in the helpers block are available in templates
helpers do
  
  # All of this cycle method is to add the ActionView cycle method
  
  # See https://github.com/rails/rails/blob/0e50b7bdf4c0f789db37e22dc45c52b082f674b4/actionview/lib/action_view/helpers/text_helper.rb#L298 for more info on where this comes from
  
  def cycle(first_value, *values)
    options = values.extract_options!
    name = options.fetch(:name, 'default')

    values.unshift(*first_value)

    cycle = get_cycle(name)
    unless cycle && cycle.values == values
      cycle = set_cycle(name, Cycle.new(*values))
    end
    cycle.to_s
  end

  def current_cycle(name = "default")
    cycle = get_cycle(name)
    cycle.current_value if cycle
  end
  
  def reset_cycle(name = "default")
    cycle = get_cycle(name)
    cycle.reset if cycle
  end

  class Cycle #:nodoc:
    attr_reader :values

    def initialize(first_value, *values)
      @values = values.unshift(first_value)
      reset
    end

    def reset
      @index = 0
    end

    def current_value
      @values[previous_index].to_s
    end

    def to_s
      value = @values[@index].to_s
      @index = next_index
      return value
    end

    private

    def next_index
      step_index(1)
    end

    def previous_index
      step_index(-1)
    end

    def step_index(n)
      (@index + n) % @values.size
    end
  end
  
  private
    # The cycle helpers need to store the cycles in a place that is
    # guaranteed to be reset every time a page is rendered, so it
    # uses an instance variable of ActionView::Base.
    def get_cycle(name)
      @_cycles = Hash.new unless defined?(@_cycles)
      return @_cycles[name]
    end

    def set_cycle(name, cycle_object)
      @_cycles = Hash.new unless defined?(@_cycles)
      @_cycles[name] = cycle_object
    end

    def split_paragraphs(text)
      return [] if text.blank?

      text.to_str.gsub(/\r\n?/, "\n").split(/\n\n+/).map! do |t|
        t.gsub!(/([^\n]\n)(?=[^\n])/, '\1<br />') || t
      end
    end

    def cut_excerpt_part(part_position, part, separator, options)
      return "", "" unless part

      radius   = options.fetch(:radius, 100)
      omission = options.fetch(:omission, "...")

      part = part.split(separator)
      part.delete("")
      affix = part.size > radius ? omission : ""

      part = if part_position == :first
        drop_index = [part.length - radius, 0].max
        part.drop(drop_index)
      else
        part.first(radius)
      end

      return affix, part.join(separator)
    end
    
    # End Cycle Method
    
end

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end

#Activate LiveReload
activate :livereload

# Pretty URLs
activate :directory_indexes
