module Jekyll

  class ImportTag < Liquid::Tag
    def initialize(tag_name, file, tokens)
      super
      @file = file.strip
    end

    def render(context)
      if @file !~ /^[a-zA-Z0-9_\/\.-]+$/ || @file =~ /\.\// || @file =~ /\/\./
        return "Import file '#{@file}' contains invalid characters or sequences"
      end

      site = context.registers[:site]

      Dir.chdir(File.join(site.source, '_includes')) do
        choices = Dir['**/*'].reject { |x| File.symlink?(x) }
        if choices.include?(@file)
          partial = Page.new(site, site.source, '', @file)
          partial.render(site.layouts, site.site_payload)
          partial.output
        else
          "Import file '#{@file}' not found in _includes directory"
        end
      end
    end
  end

end

Liquid::Template.register_tag('import', Jekyll::ImportTag)
