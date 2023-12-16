#!/usr/bin/env ruby

require 'mini_magick'
require 'fileutils'
require 'date'

size = 1400
image_files = Dir.glob(File.expand_path("~/Desktop/blog-images/*.{jpg,png}"))
output_dir = File.expand_path("~/myprojects/tonyedwardspz/assets/images/2023/")

# Initialize counters and total size variables
total_images = image_files.count
resized_images = 0
total_starting_size = image_files.reduce(0) { |sum, file| sum + File.size(file) }
total_ending_size = 0

image_files.each do | image_file |
  image = MiniMagick::Image.open(image_file)

  # Resize the image, retaining the aspect ratio
  if image[:width] > size
    image.resize "#{size}x"
    resized_images += 1
  end

  # Set the quality to 85
  image.quality 85

  # Save the image in the jpg format
  new_file = image_file.sub(/\.[^.]+\z/, '.jpg')
  image.format 'jpg'
  image.write new_file

  # Move the image to the output directory
  new_file_path = File.join(output_dir, File.basename(new_file))
  FileUtils.mv new_file, new_file_path

  total_ending_size += File.size(new_file_path)
end

def convert_size(size)
  if size < 1024
    "#{size} B"
  elsif size < 1024 * 1024
    "#{(size / 1024.0).round(2)} KB"
  else
    "#{(size / 1024.0 / 1024.0).round(2)} MB"
  end
end

puts "Total images processed: #{total_images}"
puts "Total images resized: #{resized_images}"
puts "Total starting size: #{convert_size(total_starting_size)}"
puts "Total ending size: #{convert_size(total_ending_size)}"
puts "Saved: #{convert_size(total_starting_size - total_ending_size)}"
