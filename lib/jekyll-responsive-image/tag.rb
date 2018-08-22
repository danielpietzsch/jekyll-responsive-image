module Jekyll
  module ResponsiveImage
    class Tag < Liquid::Tag
      def initialize(tag_name, markup, tokens)
        super

        @attributes = {}

        markup.scan(::Liquid::TagAttributes) do |key, value|
          # Strip quotes from around attribute values
          @attributes[key] = value.gsub(/^['"]|['"]$/, '')
        end
      end

      def render(context)
        @attributes['caption'] = markdownify(context, @attributes['caption'])

        Renderer.new(context.registers[:site], @attributes).render_responsive_image
      end

      private

      def markdownify(context, markdown_string)
        html_string = context.registers[:site].find_converter_instance(::Jekyll::Converters::Markdown).convert(markdown_string)

        remove_paragraph_tag_wrapping(html_string)
      end

      def remove_paragraph_tag_wrapping(html_string)
        Regexp.new('^<p>(.*)<\/p>$').match(html_string)[1]
      end
    end
  end
end
