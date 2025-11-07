# frozen_string_literal: true
require 'fileutils'

namespace :css do
  desc "Memisahkan file TailwindCSS hasil build menjadi folder per layer dan subfolder per komponen .kt-*"
  task :split do
    source_file = 'public/assets/css/styles.css'
    output_dir  = 'dist/css'

    abort("❌ File tidak ditemukan: #{source_file}") unless File.exist?(source_file)
    FileUtils.mkdir_p(output_dir)

    content = File.read(source_file)
    puts "📦 Membaca file CSS: #{source_file}"

    index = 0
    layers = []

    # Cari semua blok @layer beserta isi nested CSS-nya
    while (match = content.match(/@layer\s+([\w-]+)\s*\{/, index))
      layer_name = match[1]
      start_pos = match.end(0)
      depth = 1
      pos = start_pos

      while depth > 0 && pos < content.length
        char = content[pos]
        depth += 1 if char == '{'
        depth -= 1 if char == '}'
        pos += 1
      end

      block_content = content[start_pos...pos - 1]
      layers << [layer_name, block_content.strip]
      index = pos
    end

    # Pisahkan tiap layer
    layers.each do |layer, css|
      layer_dir = File.join(output_dir, layer)
      FileUtils.mkdir_p(layer_dir)

      # Khusus untuk @layer components, buat subfolder berdasarkan .kt-*
      if layer == "components"
        css.scan(/\.kt-[\w-]+/).uniq.each do |selector|
          component_name = selector.sub('.', '') # hapus titik
          component_dir = File.join(layer_dir, "kt")
          FileUtils.mkdir_p(component_dir)
          component_file = File.join(component_dir, "#{component_name}.css")

          # Ambil seluruh blok terkait komponen ini
          component_blocks = css.scan(/#{Regexp.escape(selector)}\s*\{[^}]*\}/m).join("\n\n")

          if component_blocks.empty?
            next
          end

          header = "/*! Component: #{component_name} | Layer: #{layer} | Generated #{Time.now} */\n"
          File.write(component_file, "#{header}@layer #{layer} {\n#{component_blocks}\n}\n")

          puts "✅ components/kt/#{component_name}.css"
        end
      else
        # Layer biasa, simpan seperti biasa
        file_path = File.join(layer_dir, "#{layer}_1.css")
        header = "/*! Layer: #{layer} | Generated #{Time.now} */\n"
        File.write(file_path, "#{header}@layer #{layer} {\n#{css}\n}\n")
        puts "✅ #{layer}/#{layer}_1.css"
      end
    end

    puts "\n🎉 Semua layer dan komponen .kt-* berhasil dipisahkan!"
  end
end
