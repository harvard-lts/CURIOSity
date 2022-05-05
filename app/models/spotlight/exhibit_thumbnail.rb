
   
# frozen_string_literal: true

module Spotlight
  ##
  # A simple sub-class of FeaturedImage to store the
  # square thumbnail used on the exhibits landing page
  class ExhibitThumbnail < Spotlight::FeaturedImage
    private

    def image_size
      [450, 300]
    end
  end
end