# frozen_string_literal: true
require 'fileutils'
require 'strscan'

namespace :css do
  desc "Pisahkan TailwindCSS build menjadi folder per layer dan per .kt-*"
  task :split, [:source, :output] do |_, args|
    source_file = args[:source] || 'public/assets/css/styles.css'
    output_dir  = args[:output] || 'dist/metronic'

    abort("❌ File tidak ditemukan: #{source_file}") unless File.exist?(source_file)
    FileUtils.mkdir_p(output_dir)

    content = File.read(source_file)
    puts "📦 Membaca file CSS: #{source_file}"

    # Ambil blok @layer
    layers = extract_layers(content)
    if layers.empty?
      puts "⚠️ Tidak menemukan blok @layer pada file CSS."
      next
    end

    puts "🔍 Ditemukan layer: #{layers.map(&:first).join(', ')}"
    layers.each do |layer, css|

      layer_dir = File.join(output_dir, layer)
      FileUtils.mkdir_p(layer_dir)

      if layer == "components"
        kt_selectors = extract_kt_selectors(css)
        kt_selectors.each do |selector|
          name = selector.delete('.')
          # Tentukan root komponen (mis. kt-accordion dari kt-accordion-content)
          root = component_root_for(name)
          component_dir = File.join(layer_dir, "kt", root)
          FileUtils.mkdir_p(component_dir)
          # Untuk file root (mis. kt-accordion), tulis aturan ke file "kt-accordion-root.css".
          # File "kt-accordion.css" akan menjadi indeks @import yang dibuat setelah seluruh file ditulis.
          file_basename = (name == root ? "#{name}-root" : name)
          component_file = File.join(component_dir, "#{file_basename}.css")

          blocks = extract_blocks(css, selector)
          next if blocks.empty?

          header = header_comment("Component: #{name}", layer)
          File.open(component_file, 'a') { |f| f.write("#{header}@layer #{layer} {\n#{blocks}\n}\n") }
          puts "✅ components/kt/#{root}/#{file_basename}.css"
        end
        # Tulis index root per komponen (kt-<root>/<root>.css) berisi @import ke subfile
        write_component_root_indexes(layer_dir)
        # Tulis index komponen tingkat atas berbasis @import agar modular dan portabel
        write_components_index(layer_dir)
        puts "✅ components/components.css (index @import)"
      else
        # Khusus utilities: split dan group per selector
        if layer == "utilities"
          write_utilities_groups(layer_dir, css)
          write_utilities_index(layer_dir)
          puts "✅ utilities/utilities.css (index @import)"
        else
          # Dukungan opsi indeks @import untuk layer lain via ENV `CSS_INDEX_LAYERS`
          # Contoh: CSS_INDEX_LAYERS="base,properties,theme" akan membuat ketiganya menjadi indeks
          index_layers = (ENV['CSS_INDEX_LAYERS'] || '').split(',').map(&:strip)
          if index_layers.include?(layer)
            write_layer_index(layer_dir, layer)
            puts "✅ #{layer}/#{layer}.css (index @import)"
          else
            # Tulis file agregat untuk layer lain (default)
            file_path = File.join(layer_dir, "#{layer}.css")
            header = header_comment("Layer: #{layer}", layer)
            File.open(file_path, 'a') { |f| f.write("#{header}@layer #{layer} {\n#{css.strip}\n}\n") }
            puts "✅ #{layer}/#{layer}.css"
          end
        end
      end
    end

    puts "\n🎉 Semua layer dan komponen .kt-* berhasil dipisahkan!"
  end

  desc "Gabungkan file layer hasil split menjadi satu CSS"
  task :merge, [:input, :output] do |_, args|
    input_dir   = args[:input]  || 'dist/css_1'
    output_file = args[:output] || 'dist/css/merged.css'

    abort("❌ Folder tidak ditemukan: #{input_dir}") unless Dir.exist?(input_dir)
    FileUtils.mkdir_p(File.dirname(output_file))

    # Tentukan urutan layer yang umum: base, components, utilities, properties, theme
    preferred_order = %w[base components utilities properties theme]
    layers = Dir.children(input_dir).select { |d| File.directory?(File.join(input_dir, d)) }
    ordered_layers = (preferred_order & layers) + (layers - preferred_order)

    merged_parts = []
    ordered_layers.each do |layer|
      layer_file = File.join(input_dir, layer, "#{layer}.css")
      next unless File.exist?(layer_file)
      merged_parts << File.read(layer_file).strip
      puts "🔗 Menambahkan layer: #{layer}"
    end

    header = "/*! Merged CSS dari hasil split | Generated #{Time.now} */\n"
    File.write(output_file, header + merged_parts.join("\n\n") + "\n")
    puts "✅ Merged CSS ditulis ke #{output_file}"
  end

  # Task: Buat file indeks CSS berbasis @import
  # Fungsi: Menghasilkan satu file yang hanya berisi @import ke setiap file layer
  # Kelebihan: menjaga modularitas, urutan layer tetap, dan file kecil
  # Catatan: hanya mengimpor file agregat masing-masing layer (base/utilities/properties/theme)
  desc "Buat file indeks CSS menggunakan @import untuk setiap layer"
  task :import, [:input, :output] do |_, args|
    input_dir   = args[:input]  || 'dist/metronic'
    output_file = args[:output] || 'dist/css/merged-import.css'

    abort("❌ Folder tidak ditemukan: #{input_dir}") unless Dir.exist?(input_dir)
    FileUtils.mkdir_p(File.dirname(output_file))

    preferred_order = %w[base components utilities properties theme]
    layers = Dir.children(input_dir).select { |d| File.directory?(File.join(input_dir, d)) }
    ordered_layers = (preferred_order & layers) + (layers - preferred_order)

    # Bangun baris @import relatif dari output ke input_dir
    relative_root = File.expand_path(input_dir)
    output_root   = File.expand_path(File.dirname(output_file))
    rel_prefix    = Pathname.new(relative_root).relative_path_from(Pathname.new(output_root)).to_s

    imports = []
    ordered_layers.each do |layer|
      layer_file = File.join(input_dir, layer, "#{layer}.css")
      next unless File.exist?(layer_file)
      url = File.join(rel_prefix, layer, "#{layer}.css")
      imports << "@import url(\"#{url}\");"
      puts "📥 Import layer: #{layer}"
    end

    header = "/*! Index CSS via @import | Generated #{Time.now} */\n"
    File.write(output_file, header + imports.join("\n") + "\n")
    puts "✅ Import CSS ditulis ke #{output_file}"
  end

  # Task: Buat style.css di dist/metronic yang mengimpor seluruh layer melalui proxy
  # - Membuat proxy per-layer di `dist/metronic/<layer>/<layer>.css` yang mengarah ke `../css_1/<layer>/<layer>.css`
  # - Membuat `dist/metronic/style.css` yang mengimpor semua proxy dengan urutan konsisten
  desc "Buat style.css Metronic yang mengimpor semua layer via proxy"
  task :metronic_import, [:input_dir, :output_dir] do |_, args|
    input_dir  = args[:input_dir] || 'dist/css_1'
    output_dir = args[:output_dir] || 'dist/metronic'

    abort("❌ Folder tidak ditemukan: #{input_dir}") unless Dir.exist?(input_dir)
    FileUtils.mkdir_p(output_dir)

    write_metronic_index_direct(input_dir, output_dir)
    puts "✅ Metronic style.css (impor langsung) ditulis ke #{File.join(output_dir, 'style.css')}"
  end

  # Fungsi: Ekstraksi blok-blok @layer dari konten CSS
  # Input: `content` (String CSS mentah)
  # Output: Array pasangan [nama_layer, css_layer]
  def extract_layers(content)
    result = []
    scanner = StringScanner.new(content)
    while scanner.scan_until(/@layer\s+([\w-]+)\s*\{/)
      layer = scanner[1]
      start_pos = scanner.pos
      depth = 1
      buf_start = start_pos
      until scanner.eos?
        ch = scanner.getch
        if ch == '{'
          depth += 1
        elsif ch == '}'
          depth -= 1
          if depth == 0
            end_pos = scanner.pos - 1
            result << [layer, content[buf_start...end_pos]]
            break
          end
        end
      end
    end
    result
  end

  # Fungsi: Temukan semua selector kelas `.kt-*` di dalam CSS
  # Input: `css` (String CSS untuk suatu layer)
  # Output: Array unik selector, misal ['.kt-btn', '.kt-table']
  def extract_kt_selectors(css)
    css.scan(/\.kt-[\w-]+(?=[\s\{:\.,>]|$)/).uniq
  end

  # Fungsi: Ambil blok aturan CSS untuk selector tertentu
  # Catatan: Regex sederhana sesuai output Tailwind yang flat
  # Input: `css` (String), `selector` (misal '.kt-btn')
  # Output: String gabungan aturan untuk selector tersebut
  def extract_blocks(css, selector)
    result = []
    scanner = StringScanner.new(css)
    pattern = Regexp.new(Regexp.escape(selector))
    while scanner.scan_until(pattern)
      sel_end = scanner.pos
      sel_start = sel_end - selector.length
      open_idx = css.index('{', sel_end)
      break unless open_idx
      depth = 1
      i = open_idx + 1
      while i < css.length
        ch = css[i]
        if ch == '{'
          depth += 1
        elsif ch == '}'
          depth -= 1
          if depth == 0
            rule = css[sel_start..open_idx] + css[(open_idx + 1)..i]
            result << rule
            scanner.pos = i + 1
            break
          end
        end
        i += 1
      end
    end
    result.join("\n\n")
  end

  # Fungsi: Bangun header komentar standar untuk file hasil
  # Input: `title` (String penjelas), `layer` (nama layer)
  # Output: String komentar header
  def header_comment(title, layer)
    "/*! #{title} | Layer: #{layer} | Generated #{Time.now} */\n"
  end

  # Fungsi: Tulis utilitas terpisah per selector, dikelompokkan berdasarkan prefix
  # Struktur output: utilities/<group>/<selector>.css
  # Contoh: `.d-flex` -> group `d`, file `d-flex.css`
  def write_utilities_groups(layer_dir, css)
    selectors = extract_util_selectors(css)
    selectors.each do |selector|
      name = selector.delete('.')
      group = group_for_selector(name)
      subgroup = util_base_for(name)
      # Pastikan nama direktori aman di Windows (kolon, slash, backslash)
      group_dir = File.join(layer_dir, safe_dirname_for(group), safe_dirname_for(subgroup))
      FileUtils.mkdir_p(group_dir)
      filename = safe_filename_for(name)
      file_path = File.join(group_dir, "#{filename}.css")

      blocks = extract_blocks(css, selector)
      next if blocks.empty?

      header = header_comment("Utility: #{name}", 'utilities')
      File.open(file_path, 'a') { |f| f.write("#{header}@layer utilities {\n#{blocks}\n}\n") }
      puts "✅ utilities/#{group}/#{subgroup}/#{filename}.css"
    end
  end

  # Fungsi: Ekstrak selector kelas untuk utilities (exclude .kt- components)
  # Mendukung arbitrary value Tailwind seperti:
  #  - .top-\[17px\]
  #  - .top-\[calc\(var\(--header-height\)\+1\.5rem\)\]
  #  - .translate-x-1\/2 (slash di-escape: \/)
  # Pola: nama dasar (huruf/angka/_/-/\/), juga mendukung escape umum (\\.)
  def extract_util_selectors(css)
    # Hindari false-positive pada nilai numerik (mis. 1.5rem) atau titik di-escape dalam bracket
    # Gunakan negative lookbehind: titik tidak boleh diawali backslash atau digit
    css.scan(/(?<![\\\d])\.(?!kt-)(?:[a-zA-Z0-9_\/\-]|\\.)+(?:\\\[[^\]]+\\\])?(?=[\s\{:\.,>]|$)/).uniq
  end

  # Fungsi: Sanitasi nama file dari selector utilitas
  # - Menghapus escape backslash untuk karakter khusus Tailwind: [], (), +, ., /, :
  # - Mengganti '/' menjadi '-slash-' agar tidak membentuk subdirektori
  # - Mengganti ':' menjadi '-colon-' (portabilitas Windows)
  # - Mengganti spasi menjadi '-'
  def safe_filename_for(name)
    base = name
      .gsub('\\[', '[')
      .gsub('\\]', ']')
      .gsub('\\(', '(')
      .gsub('\\)', ')')
      .gsub('\\+', '+')
      .gsub('\\.', '.')
      .gsub('\\/', '/')
      .gsub('\\:', ':')
    # Hilangkan numeric escape sederhana seperti \5, \35 agar lebih terbaca
    base = base.gsub(/\\([0-9a-fA-F]{1,6})/, '\\1')
    base = base.gsub('/', '-slash-')
    base = base.gsub(':', '-colon-')
    # Ganti backslash residual agar aman di Windows
    base = base.gsub('\\', '-bslash-')
    base.gsub(/\s+/, '-')
  end

  # Fungsi: Sanitasi nama direktori (group & subgroup) agar aman di Windows
  # - Unescape karakter seperti pada safe_filename_for
  # - Ganti '/' menjadi '-slash-'
  # - Ganti '\\' menjadi '-bslash-'
  # - Ganti ':' menjadi '-colon-'
  # - Ganti spasi menjadi '-'
  def safe_dirname_for(name)
    base = name
      .gsub('\\[', '[')
      .gsub('\\]', ']')
      .gsub('\\(', '(')
      .gsub('\\)', ')')
      .gsub('\\+', '+')
      .gsub('\\.', '.')
      .gsub('\\/', '/')
      .gsub('\\:', ':')
    base = base.gsub('/', '-slash-')
               .gsub('\\', '-bslash-')
               .gsub(':', '-colon-')
    base.gsub(/\s+/, '-')
  end

  # Fungsi: Tentukan group dari nama selector utilitas.
  # Aturan:
  # - Jika ada variant (escaped colon) seperti `dark\:bg-...`, group = bagian sebelum `\:` (contoh: `dark`).
  # - Jika tidak ada variant, gunakan prefix sebelum '-' (contoh: `top-[...]` -> `top`).
  def group_for_selector(name)
    if name.include?("\\:")
      name.split("\\:").first
    else
      name.split('-').first
    end
  end

  # Fungsi: Tentukan utilitas dasar (subgroup) setelah varian, sebelum '-'
  # Contoh: `dark\:bg-orange-950` -> `bg`; `text-black/30` -> `text`
  def util_base_for(name)
    after_variant = name.include?("\\:") ? name.split("\\:").last : name
    after_variant.split('-').first
  end

  # Fungsi: Tulis index utilities.css berisi @import ke semua file utilitas
  # - Mengimpor setiap file .css di bawah layer_dir (kecuali utilities.css itu sendiri)
  # - Menggunakan jalur relatif dari utilities.css ke berkas utilitas
  def write_utilities_index(layer_dir)
    index_path = File.join(layer_dir, 'utilities.css')
    css_files = Dir.glob(File.join(layer_dir, '**', '*.css')).sort
    imports = []
    css_files.each do |path|
      next if File.expand_path(path) == File.expand_path(index_path)
      url = Pathname.new(path).relative_path_from(Pathname.new(layer_dir)).to_s
      imports << "@import url(\"./#{url}\");"
    end
    header = header_comment("Utilities Index via @import", 'utilities')
    File.write(index_path, header + imports.join("\n") + "\n")
  end

  # Fungsi: Tulis index components.css berisi @import ke semua file komponen
  # - Mengimpor setiap file .css di bawah layer_dir (kecuali components.css itu sendiri)
  # - Memastikan jalur relatif benar dari components.css ke berkas komponen
  def write_components_index(layer_dir)
    index_path = File.join(layer_dir, 'components.css')
    kt_dir = File.join(layer_dir, 'kt')
    imports = []
    if Dir.exist?(kt_dir)
      root_dirs = Dir.children(kt_dir).select { |d| File.directory?(File.join(kt_dir, d)) }.sort
      root_dirs.each do |root|
        root_index = File.join('kt', root, "#{root}.css")
        if File.exist?(File.join(layer_dir, root_index))
          imports << "@import url(\"./#{root_index}\");"
        else
          # Fallback: jika index root belum ada, impor semua file di dalam folder
          Dir.glob(File.join(layer_dir, 'kt', root, '*.css')).sort.each do |path|
            url = Pathname.new(path).relative_path_from(Pathname.new(layer_dir)).to_s
            imports << "@import url(\"./#{url}\");"
          end
        end
      end
    end
    header = header_comment("Components Index via @import", 'components')
    File.write(index_path, header + imports.join("\n") + "\n")
  end

  # Fungsi: Tulis index per root komponen di dalam `components/kt/<root>/<root>.css`
  # Tujuan: Menjadikan file root sebagai indeks @import yang mengimpor semua subfile dalam folder tersebut
  # Catatan: Menghindari impor diri sendiri, hanya mengimpor berkas selain `<root>.css`
  def write_component_root_indexes(layer_dir)
    kt_dir = File.join(layer_dir, 'kt')
    return unless Dir.exist?(kt_dir)
    Dir.children(kt_dir).select { |d| File.directory?(File.join(kt_dir, d)) }.each do |root|
      root_dir = File.join(kt_dir, root)
      index_path = File.join(root_dir, "#{root}.css")
      css_files = Dir.glob(File.join(root_dir, '*.css')).sort
      imports = []
      css_files.each do |path|
        next if File.expand_path(path) == File.expand_path(index_path)
        url = Pathname.new(path).relative_path_from(Pathname.new(root_dir)).to_s
        imports << "@import url(\"./#{url}\");"
      end
      header = header_comment("Component Root Index via @import", root)
      File.write(index_path, header + imports.join("\n") + "\n")
    end
  end

  # Fungsi: Tentukan root komponen dari nama `.kt-*`
  # Contoh: 'kt-accordion-content' -> 'kt-accordion'; 'kt-menu-link' -> 'kt-menu'; 'kt-btn' -> 'kt-btn'
  # Tujuan: pengelompokan file komponen menjadi subfolder konsisten: components/kt/<root>/<name>.css
  def component_root_for(name)
    parts = name.split('-')
    return name if parts.empty? || parts.first != 'kt'
    return name if parts.length < 2
    [parts[0], parts[1]].join('-')
  end

  # Fungsi: Tulis index <layer>.css berisi @import ke semua file layer
  # - Generik untuk layer selain utilities/components
  # - Mengimpor setiap file .css di bawah layer_dir (kecuali index itu sendiri)
  # - Jalur relatif dari file index ke berkas yang diimpor
  def write_layer_index(layer_dir, layer)
    index_path = File.join(layer_dir, "#{layer}.css")
    css_files = Dir.glob(File.join(layer_dir, '**', '*.css')).sort
    imports = []
    css_files.each do |path|
      next if File.expand_path(path) == File.expand_path(index_path)
      url = Pathname.new(path).relative_path_from(Pathname.new(layer_dir)).to_s
      imports << "@import url(\"./#{url}\");"
    end
    header = header_comment("#{layer.capitalize} Index via @import", layer)
    File.write(index_path, header + imports.join("\n") + "\n")
  end

  # Fungsi: Tulis indeks style.css Metronic dengan impor langsung ke dist/css_1
  # - Tanpa proxy; langsung mengimpor `../css_1/<layer>/<layer>.css` dari `dist/metronic/style.css`
  def write_metronic_index_direct(input_dir, output_dir)
    preferred_order = %w[base components utilities properties theme]
    layers = Dir.children(input_dir).select { |d| File.directory?(File.join(input_dir, d)) }
    ordered_layers = (preferred_order & layers) + (layers - preferred_order)

    # Hitung path relatif dari style.css ke folder input_dir
    rel_prefix = Pathname.new(File.expand_path(input_dir)).relative_path_from(Pathname.new(File.expand_path(output_dir))).to_s

    imports = []
    ordered_layers.each do |layer|
      source = File.join(input_dir, layer, "#{layer}.css")
      next unless File.exist?(source)
      url = File.join(rel_prefix, layer, "#{layer}.css")
      imports << "@import url(\"#{url}\");"
    end

    index_header = header_comment("Metronic Style Index via @import (direct)", 'metronic')
    File.write(File.join(output_dir, 'style.css'), index_header + imports.join("\n") + "\n")
  end
end
